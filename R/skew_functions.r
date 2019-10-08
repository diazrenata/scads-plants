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

#' Skewness
#'
#' @param fs_samples_df df of all samples, with column for abundance
#'
#' @return summary of skewness per sample
#' @export
#'
#' @importFrom e1071 skewness
#' @importFrom dplyr group_by_at summarize ungroup
#' @importFrom vegan diversity
add_dis <- function(fs_samples_df) {

  groupvars <- colnames(fs_samples_df)[ which(colnames(fs_samples_df) != "abund")]

  sim_dis <- fs_samples_df %>%
    dplyr::group_by_at(.vars = groupvars) %>%
    dplyr::summarize(skew = e1071::skewness(abund),
                     shannon = vegan::diversity(abund, index = "shannon", base = exp(1)),
                     simpson = vegan::diversity(abund, index = "simpson")) %>%
    dplyr::ungroup()

  return(sim_dis)
}



#' Get percentile values
#'
#' @param a_vector Vector of values
#'
#' @return Vector of percentile values for all values in the vector
#' @export
#'
get_percentiles <- function(a_vector) {

  nvals <- length(a_vector)

  percentile_vals <- vapply(as.matrix(a_vector), FUN = count_below, a_vector = a_vector, FUN.VALUE = 100)

  percentile_vals <- 100 * (percentile_vals / nvals)

  return(percentile_vals)
}


#' Count values below a value
#'
#' @param a_value Focal value
#' @param a_vector Vector for comparison
#'
#' @return Number of values in vector below value
#' @export
#'
count_below <- function(a_value, a_vector) {
  return(sum(a_vector < a_value))
}

#' Get one percentile value
#'
#' @param a_value Focal value
#' @param a_vector Comparison vector
#'
#' @return Percentile of focal value within comparison vector
#' @export
get_percentile <- function(a_value, a_vector) {

  count_below <- sum(a_vector < a_value)

  nvals <- length(a_vector)

  percentile_val <- 100 * (count_below / nvals)

  return(percentile_val)
}
