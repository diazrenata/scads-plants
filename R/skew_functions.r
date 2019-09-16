#' Skewness
#'
#' @param fs_samples_df df of all samples, with columns for sim, year, season, treatment, source
#'
#' @return summary of skewness per sample
#' @export
#'
#' @importFrom e1071 skewness
#' @importFrom dplyr group_by summarize ungroup
add_skew <- function(fs_samples_df) {

  sim_skews <- fs_samples_df %>%
    dplyr::group_by(sim, year, season, treatment, source) %>%
    dplyr::summarize(skew = e1071::skewness(abund)) %>%
    dplyr::ungroup()

  return(sim_skews)
}
