#' Get Portal plant abundance
#'
#' @param census_year census year
#' @param season "summer" or "winter"
#' @param plot_treatment "control" or "exclosure"
#'
#' @return dataframe of abundance and rank
#' @export
#'
#' @importFrom portalr plant_abundance
#' @importFrom dplyr filter select rename mutate arrange row_number
get_plant_sad <- function(census_year = 1994, season = "summer", plot_treatment = "control") {

  if(season == "winter") {
    planttype <- "Winter Annuals"
  } else if(season == "summer") {
    planttype <- "Summer Annuals"
  }

  portal_sad <- portalr::plant_abundance(level = "Treatment", type = planttype, plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
    dplyr::filter(treatment == plot_treatment) %>%
    dplyr::select(year, species, abundance) %>%
    dplyr::filter(year == census_year) %>%
    dplyr::select(-year) %>%
    dplyr::rename(abund = abundance) %>%
    dplyr::select(abund) %>%
    dplyr::arrange(abund) %>%
    dplyr::mutate(rank = dplyr::row_number(),
                  sim = -99,
                  source = "observed",
                  season = season,
                  year = census_year,
                  treatment = plot_treatment,
                  singletons = FALSE)

  return(portal_sad)

}
