library(drake)
#library(scads)
library(feasiblesads)
library(scadsplants)

#expose_imports(scads)
expose_imports(scadsplants)

years <- 1990:2005

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
  master_p_table = target(build_p_table(all_dat)),
  fs = target(sample_fs_long(dat, nsamples, p_table),
              transform = map(dat = !!dat_targets, nsamples = 100, p_table = master_p_table)
  ),
  fs_list = target(MATSS::collect_analyses(list(fs)), transform = combine(fs)),
  fs_df = dplyr::bind_rows(fs_list)
)

skew_plan <- drake_plan(
  skew_summary_df = add_skew(fs_df),
  skew_long_df = dplyr::left_join(fs_df, skew_summary_df, by = c("sim", "year", "season", "treatment", "source"))
)

# reports

# run

all <- dplyr::bind_rows(datasets_plan)# , sample_plan, skew_plan)

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
