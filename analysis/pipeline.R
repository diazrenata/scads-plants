library(drake)
#library(scads)
library(feasiblesads)
library(scadsplants)

#expose_imports(scads)
#expose_imports(scadsplants)

years <-c(1986, 1994, 1996, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2006, 2007, 2009)

max_s <-40

max_n <- 15000

# get data
datasets_plan <- drake_plan(
dat =target(get_plant_sad(year, season, treatment),
            transform = cross(year = !!years,
                            season = c("summer", "winter"),
                            treatment = "control"),
            trigger = trigger(command = FALSE)),
all_dat = target(MATSS::collect_analyses(list(dat)), transform = combine(dat))
)

# sample fs

dat_targets <- list()
for(i in 1:(nrow(datasets_plan) -1)) {
  dat_targets[[i]] <- as.name(datasets_plan$target[i])
}

sample_plan <- drake_plan(
  master_p_table = target(feasiblesads::fill_ps(max_s = !!max_s,
                                                max_n = !!max_n,
                                                storeyn = FALSE)),
  fs = target(sample_fs_long(dat, nsamples, p_table),
              transform = map(dat = !!dat_targets, nsamples = 10000, p_table = master_p_table)
  ),
  skew = target(add_skew(fs),
                transform = map(fs)),
  # coeffs = target(get_all_coeffs(fs),
  #                 transform = map(fs)),
  # cds = target(get_all_cds(fs, coeffs),
  #              transform = map(fs, coeffs)),
  # cds_list = target(MATSS::collect_analyses(list(cds)), transform = combine(cds)),
  # cds_df = target(dplyr::bind_rows(cds_list)),
  fs_list = target(MATSS::collect_analyses(list(fs)), transform = combine(fs)),
  fs_df = target(dplyr::bind_rows(fs_list)),
  skew_list = target(MATSS::collect_analyses(list(skew)), transform = combine(skew)),
  skew_df = target(dplyr::bind_rows(skew_list)),
  skew_long_df = target(dplyr::left_join(fs_df, skew_df, by = c("sim", "year", "season", "treatment", "source")))#,
#  cd_long_df = target(dplyr::left_join(cds_df, skew_df, by = c("sim", "year", "season", "treatment", "source")))
)

# reports

# run

all <- dplyr::bind_rows(datasets_plan, sample_plan)

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

## View the graph of the plan
if (interactive())
{
  config <- drake_config(all, cache = cache)
  sankey_drake_graph(config, build_times = "none")  # requires "networkD3" package
  vis_drake_graph(config, build_times = "none")     # requires "visNetwork" package
}

set.seed(1977)

## Run the pipeline
nodename <- Sys.info()["nodename"]
if(grepl("ufhpc", nodename)) {
  library(future.batchtools)
  print("I know I am on SLURM!")
  ## Run the pipeline parallelized for HiPerGator
  future::plan(batchtools_slurm, template = "slurm_batchtools.tmpl")
  make(all,
       force = TRUE,
       cache = cache,
       cache_log_file = here::here("analysis", "drake", "cache_log.txt"),
       verbose = 2,
       parallelism = "future",
       jobs = 64,
       caching = "master") # Important for DBI caches!
} else {
  # Run the pipeline on a single local core
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log.txt")))
}


print("Completed OK")
