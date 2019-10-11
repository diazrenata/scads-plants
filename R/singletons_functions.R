#' Add singletons
#'
#' @param dat dataframe, result of get plant data
#' @param singletons_prop Proportion of S to add as singletons. Defaults to .1. Will add `ceiling(singletons_prop * S)` species with 1 individual each.
#'
#' @return dataframe with some extra singletons
#' @export
#'
#' @importFrom dplyr select bind_rows mutate arrange row_number
add_singletons <- function(dat, singletons_prop = .1) {

  true_nspp <- max(dat$rank)
  true_nind <- sum(dat$abund)

  new_nspp <- ceiling(true_nspp * (1 + singletons_prop))

  newdat <- data.frame(
    abund = rep(1, times = new_nspp - true_nspp)
  )

  dat <- dat %>%
    dplyr::select(-rank) %>%
    dplyr::bind_rows(newdat) %>%
    dplyr::mutate(
      sim = sim[1],
      source = source[1],
      season = season[1],
      year = year[1],
      treatment = treatment[1]
    ) %>%
    dplyr::arrange(abund) %>%
    dplyr::mutate(
      rank = dplyr::row_number()
    )

  return(dat)

}
