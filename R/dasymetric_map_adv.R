#' Create a dasymetric map
#'
#' @description IMMATURE! RESULTS IN WAY TOO LESS POPULATION! Advanced dasymetric mapping that uses CORINE land use classes to make more valuable predictions on population counts. R
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
#' @source <https://github.com/slu-openGIS/areal/pull/27/commits/d86490f6544af4235bdbdf5f51a9cab000d2b78e>,
#'  <https://www.eea.europa.eu/data-and-maps/data/population-density/mapping-population-density/mapping-population-density/download>
#'
#' @references Peedell, Steve (1999): Mapping Population Density. Distribution of Population using CORINE Land Cover. Ispra.
#'
#' @examples
#' source_geom = sf::st_union(population_counts)
#' source=sf::st_sf(ID=1,population=sum(population_counts["population"]$population),source_geom)
#' dasymetric_map_adv(population_counts, source, corine_18, extensive = "population")
dasymetric_map_adv <- function(target, source, ancillary_data, tid = NULL, extensive = NULL) {

  # Population densities are derived from Peedell, Steve (1999): Mapping Population Density. Distribution of Population using CORINE Land Cover. Ispra.
  pop_densities = dplyr::tibble(
    CLC18 = as.character(
              c(111,112,121,122,123,124,131,132,133,141,142,
              211,212,213,221,222,223,231,241,242,243,244,
              311,312,313,321,322,323,324,331,332,333,334,335,
              411,412,421,422,423,
              511,512,521,522,523)),
    pop_density = c(32,25,1,1,1,1,0,0,0,1,1,3,3,1,2,2,2,
      3,5,5,3,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)/100
  )

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
  first_int <- dplyr::left_join(first_int, pop_densities, by = 'CLC18')

  # Multiply Extensive Variables by this Proportion
  for(i in extensive){
    first_int[[i]] <- first_int[[i]] * first_int[['AW_area_prp']] * first_int[['pop_density']]
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
