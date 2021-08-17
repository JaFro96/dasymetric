#' Prepare land use data for binary dasymetric mapping
#'
#' @param x sf containing CORINE land use data
#' @param class_ids numeric identifiers that describes the urban CLC-classes (111 is Continuous urban fabric and 112 is Discontinuous urban fabric)
#'
#' @return sf containing geometries where people probably live
#' @export
#'
#'
#' @examples
#' prep_landuse(corine_18)
prep_landuse <- function(x, class_ids=c(111,112)){
  urban_fabric <- x |> dplyr::filter(CLC18 %in% class_ids)
  return(urban_fabric)
}
