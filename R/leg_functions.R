#' Legendre coefficients
#'
#' @param fs_samples_df df of all samples, with columns for sim, year, season, treatment, source
#' @param nleg nb of polynomials to use, defaults to min(10, nspp - 2)
#' @return dataframe of leg coefficients
#' @export
#'
#' @importFrom scads legendre_approx
#' @importFrom dplyr bind_rows filter mutate
#' @importFrom tidyr gather
get_all_coeffs <- function(fs_samples_df, nleg = NULL) {


  if(is.null(nleg)) {
    nspp <- max(fs_samples_df$rank)
    nleg <- min(10, nspp - 2)
  }

  get_coeffs <- function(sim_index, samples_df, nleg) {
    this_vec <- dplyr::filter(samples_df, sim == sim_index)$abund
    this_vec <- this_vec / sum(this_vec)
    coeffs <- scads::legendre_approx(this_vec, nleg)$coefficients
    names(coeffs)[1] <- "intercept"
    return(coeffs)
  }

  leg_fits <- lapply(as.list(unique(fs_samples_df$sim)),
                     FUN = get_coeffs,
                     samples_df = fs_samples_df,
                     nleg = nleg)

  names(leg_fits) <- unique(fs_samples_df$sim)

  leg_coeffs <- dplyr::bind_rows(leg_fits) %>%
    t() %>%
    as.data.frame()

  colnames(leg_coeffs) <- names(leg_fits[[1]])

  leg_coeffs <- leg_coeffs %>%
    dplyr::mutate(sim = unique(fs_samples_df$sim)) %>%
    tidyr::gather(-sim, key = "parameter", value = "value")

  return(leg_coeffs)
}

#' Get distance to centroid
#'
#' @param fs_samples_df df of all samples, with columns for sim, year, season, treatment, source
#' @param leg_coeffs_df result of get_all_coeffs
#'
#' @return fs_samples_df with column for distance to centroid
#' @export
#'
#' @importFrom dplyr filter group_by summarize ungroup left_join
#' @importFrom scads eucl_rows
get_all_cds <- function(fs_samples_df, leg_coeffs_df) {

  centroid <- dplyr::filter(leg_coeffs_df, sim > 0) %>%
    dplyr::group_by(parameter)  %>%
    dplyr::summarize(centroid_value = mean(value)) %>%
    dplyr::ungroup()

  centroid_dists <- leg_coeffs_df %>%
    dplyr::group_by(sim) %>%
    dplyr::summarize(centroid_dist = scads::eucl_rows(value, centroid$centroid_value)) %>%
    dplyr::ungroup()

  fs_samples_df <- dplyr::left_join(fs_samples_df, centroid_dists, by = "sim")

  return(fs_samples_df)

}
