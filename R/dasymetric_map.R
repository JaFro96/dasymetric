#' Create a dasymetric map
#'
#' @import graphics
#'
#' @param x numeric
#' @param ancillary_data sf
#' @param target_geom sf
#'
#' @return sf
#' @export
#'
#' @examples dasymetric_map(a,b,c)
dasymetric_map <- function(x, ancillary_data, target_geom) {
  print("TODO!")
  p = sf::st_point(0:1)
  plot(p, pch = 16)
  title("point")
  box(col = 'grey')
  return(p)
}
