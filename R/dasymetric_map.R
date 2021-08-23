#' Create a dasymetric map
#'
#' @description Binary dasymetric mapping that uses urban areas to make more valuable predictions on population counts
#'
#' @import graphics
#' @importFrom rlang .data
#'
#' @param target sf object containing geometry of the desired spatial zones
#' @param source sf object that we want to interpolate
#' @param ancillary_data sf object containing geometry that helps to better interpolate (i.e. land use, building footprints)
#' @param tid Optional string denoting column with unique identifier for `target` geometries. Optional, and will otherwise be automatically generated
#' @param extensive Required atomic vector of strings denoting columns in `source` with extensive variables (i.e. count data)
#'
#' @return sf
#' @export
#'
#' @source <https://github.com/slu-openGIS/areal/pull/27/commits/d86490f6544af4235bdbdf5f51a9cab000d2b78e>
#'
#' @examples
#' source_geom = sf::st_union(population_counts)
#' source=sf::st_sf(ID=1,population=sum(population_counts["population"]$population),source_geom)
#' urban = prep_landuse(corine_18)
#' dasymetric_map(population_counts, source, urban, extensive = "population")
dasymetric_map <- function(target, source, ancillary_data, tid = NULL, extensive = NULL) {

  # Add IDs
  if(missing(tid)){
    target[['AW_tid']] <- 1:nrow(target)
    tid <- 'AW_tid'
  }
  source[['AW_sid']] <- 1:nrow(source)

  # Intersect Source to Intermediate
  first_int <- sf::st_intersection(source, ancillary_data)

  # Generate ID for Intersection
  first_int['AW_fid'] <- 1:nrow(first_int)

  # Compute Area for First Interpolation
  first_int['AW_area'] <- sf::st_area(first_int)

  # Calculate Area as a Proportion of Source Area
  cov_area <- first_int |>
    sf::st_drop_geometry() |>
    dplyr::group_by(.data$AW_sid) |>
    dplyr::summarise(AW_cov_area = sum(.data$AW_area))

  first_int <- dplyr::left_join(first_int, cov_area, by = 'AW_sid')
  first_int['AW_area_prp'] <- as.numeric(first_int$AW_area / first_int$AW_cov_area)

  # Multiply Extensive Variables by this Proportion
  for(i in extensive){
    first_int[[i]] <- first_int[[i]] * first_int[['AW_area_prp']]
  }

  # Intersect Again, Intermediate to Target
  target_int <- sf::st_intersection(first_int, target)

  # Calculate New Area (And Ratio)
  target_int['AW_t_area'] <- sf::st_area(target_int)
  target_int['AW_t_prp'] <- as.numeric(target_int[['AW_t_area']] / target_int[['AW_area']])

  # Multiply Extensive Again
  for(i in extensive){
    target_int[[i]] <- target_int[[i]] * target_int[['AW_t_prp']]
  }

  # Group And Summarise Extensive
  summary <- target_int |>
    sf::st_drop_geometry() |>
    dplyr::group_by(!!dplyr::sym(tid)) |>
    dplyr::summarise_at(extensive, sum)

  # Join To Target
  target <- dplyr::left_join(target, summary, by = tid)

  return(target)
}
