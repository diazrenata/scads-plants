#' Add singletons
#'
#' @param dat dataframe, result of get plant data
#'
#' @return dataframe with some extra singletons
#' @export
#'
#' @importFrom dplyr select bind_rows mutate arrange row_number group_by n summarise filter
#' @importFrom SPECIES chao1984 ChaoBunge ChaoLee1992
add_singletons <- function(dat) {
  freq = dat %>%
    select(abund) %>%
    group_by(abund) %>%
    summarise(freq = n()) %>%
    as.matrix()

  est_1984 = chao1984(freq)$Nhat
  cb = ChaoBunge(freq)$Nhat
  clee = mean(ChaoLee1992(freq)$Nhat)

  true_nspp <- nrow(dat)

  ests <- data.frame(est = c(est_1984, cb, clee)) %>%
    filter(!is.na(est),
           !is.nan(est),
           !is.infinite(est),
           est > 0)

  est_nspp <- ceiling(mean(ests$est))

  newdat <- data.frame(
    abund = rep(1, times = est_nspp - true_nspp)
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
