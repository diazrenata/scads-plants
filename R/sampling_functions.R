#' Build largest necessary P table
#'
#' @param list_of_datasets a list of datasets
#'
#' @return P table that will cover all the datasets
#' @export
#'
#' @importFrom feasiblesads fill_ps
build_p_table <- function(list_of_datasets) {
  max_s <- lapply(list_of_datasets,
               FUN = function(sad_df)
                 return(max(sad_df$rank))) %>%
    unlist() %>%
    max()
  max_n <- lapply(list_of_datasets,
                  FUN = function(sad_df)
                    return(sum(sad_df$abund))) %>%
    unlist() %>%
    max()

  p_table <- feasiblesads::fill_ps(max_s = max_s, max_n = max_n, storeyn = F)

  return(p_table)
}

#' Sample the feasible set
#'
#' @param dataset SAD df to base on
#' @param nsamples nb samples
#' @param p_table p table
#'
#' @return long dataframe of sim, rank, and abundance
#' @export
#'
#' @importFrom dplyr mutate group_by arrange ungroup row_number bind_rows
#' @importFrom tidyr gather
#' @importFrom feasiblesads fill_ps sample_fs
sample_fs_long <- function(dataset, nsamples, p_table = NULL) {

  if(is.na(dataset)) {
    return(NA)
  }

  max_s = max(dataset$rank)
  max_n = sum(dataset$abund)

  if(is.null(p_table)) {
    p_table <- feasiblesads::fill_ps(max_s, max_n, storeyn = F)
  }

  p_table <- p_table[1:max_s, 1:(max_n + 1)]

  fs_samples <- feasiblesads::sample_fs(s = max_s, n = max_n, nsamples = nsamples, p_table = p_table) %>%
    unique() %>%
    t() %>%
    as.data.frame() %>%
    tidyr::gather(key = "sim", value = "abund") %>%
    dplyr::mutate(sim = as.integer(substr(sim, 2, nchar(sim)))) %>%
    dplyr::group_by(sim) %>%
    dplyr::arrange(abund) %>%
    dplyr::mutate(rank = dplyr::row_number()) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(source = "sampled",
                  season = dataset$season[1],
                  year = dataset$year[1],
                  treatment = dataset$treatment[1]) %>%
    dplyr::bind_rows(dataset)

  return(fs_samples)

}
