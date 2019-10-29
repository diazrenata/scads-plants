#' Add singletons
#'
#' @param dat dataframe, result of get plant data
#'
#' @return dataframe with some extra singletons
#' @export
#'
#' @importFrom dplyr select bind_rows mutate arrange row_number group_by n summarise filter
#' @importFrom vegan estimateR
add_singletons <- function(dat, use_max =F) {
  freq = dat %>%
    select(abund) %>%
    as.matrix() %>%
    t()

  s0 <- ncol(freq)
  n0 <- sum(freq)


  est <- vegan::estimateR(freq)

  chao_est <- est[2] - s0
  ace_est <- est[4] - s0

  if(use_max) {
    chao_est <- chao_est + est[3]
    ace_est <- ace_est + est[5]
  }

  ests <- data.frame(est = c(chao_est, ace_est)) %>%
    filter(!is.na(est),
           !is.nan(est),
           !is.infinite(est),
           est >= 0)

  if(nrow(ests) == 0) {
    return(NA)
  }

  est_nspp <- ceiling(mean(ests$est))

  if(est_nspp == 0) {
    return(dat)
  }

  newdat <- data.frame(
    abund = rep(1, times = est_nspp)
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
      rank = dplyr::row_number(),
      singletons = TRUE
    )

  return(dat)

}
