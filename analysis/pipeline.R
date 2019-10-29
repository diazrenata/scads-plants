library(drake)
#library(scads)
library(feasiblesads)
library(scadsplants)

#expose_imports(scads)
expose_imports(scadsplants)

max_s <-40
#max_s_to_sample <- ceiling(1.1 * max_s)
max_s_to_sample <- 62
max_n <- 15000
max_n_to_sample <- max_n

summer <- portalr::plant_abundance(level = "Treatment", type = "Summer Annuals", plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
  dplyr::filter(treatment == "control") %>%
  dplyr::select(year, species, abundance) %>%
  dplyr::rename(abund = abundance) %>%
  dplyr::group_by(year) %>%
  dplyr::summarize(nspp = dplyr::n(),
            nind = sum(abund)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(season = "summer")

winter <- portalr::plant_abundance(level = "Treatment", type = "Winter Annuals", plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
  dplyr::filter(treatment == "control") %>%
  dplyr::select(year, species, abundance) %>%
  dplyr::rename(abund = abundance) %>%
  dplyr::group_by(year) %>%
  dplyr::summarize(nspp = dplyr::n(),
                   nind = sum(abund)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(season = "winter")

years_dat <- dplyr::bind_rows(summer, winter) %>%
  dplyr::group_by(year) %>%
  dplyr::summarize(nspp = max(nspp),
            nind = max(nind)) %>%
  dplyr::filter(nspp <= max_s,
         nind <= max_n) %>%
  dplyr::select(year)


years <-years_dat$year


# get data
datasets_plan <- drake_plan(
dat =target(get_plant_sad(year, season, treatment),
            transform = cross(year = !!years,
                            season = c("summer", "winter"),
                            treatment = "control"),
            trigger = trigger(command = FALSE)),
dat_singles = target(add_singletons(dat, use_max = TRUE),
                     transform = map(dat)),
all_dat = target(MATSS::collect_analyses(list(dat)), transform = combine(dat)),
all_dat_singles = target(MATSS::collect_analyses(list(dat_singles)), transform = combine(dat_singles))
)

# sample fs

dat_targets <- list()
for(i in 1:(nrow(datasets_plan) -2)) {
  dat_targets[[i]] <- as.name(datasets_plan$target[i])
}

sample_plan <- drake_plan(
  master_p_table = target(feasiblesads::fill_ps(max_s = !!max_s_to_sample,
                                                max_n = !!max_n_to_sample,
                                                storeyn = FALSE)),
  fs = target(sample_fs_long(dat, nsamples, p_table),
              transform = map(dat = !!dat_targets, nsamples = 100, p_table = master_p_table)
  ),
  di = target(add_dis(fs),
                transform = map(fs)),
  fs_df = target(dplyr::bind_rows(fs), transform = combine(fs)),
  di_df = target(dplyr::bind_rows(di), transform = combine(di)),
  di_long_df = target(dplyr::left_join(fs_df, di_df, by = c("sim", "year", "season", "treatment", "source", "singletons")))#,
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
