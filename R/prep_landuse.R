#' Prepare land use data for binary dasymetric mapping
#'
#' @description Extract features of a \emph{CORINE} land use sf that cover urban area.
#'
#' @importFrom rlang .data
#'
#' @param x sf containing \emph{CORINE} land use data
#' @param class_ids numeric identifiers that describes the urban CLC-classes (111 is Continuous urban fabric and 112 is Discontinuous urban fabric)
#'
#' @return sf containing geometries where people probably live
#' @export
#'
#' @seealso \code{\link{dasymetric_map}} for using the prepared dataset
#'
#' @examples
#' prep_landuse(corine_18)
prep_landuse <- function(x, class_ids=c(111,112)){
  urban_fabric <- x |> dplyr::filter(.data$CLC18 %in% class_ids)
  return(urban_fabric)
}
