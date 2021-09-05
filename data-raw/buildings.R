## code to prepare `buildings` dataset goes here

# visit https://opendata.stadt-muenster.de/dataset/geb%C3%A4udeumrisse
# Select Format: "...als ESRI Shapefile"
# Select Gemarkung/Flur: "Alles (...dauert einige Minuten)"
fn = "inst/alkis_opendata/gebaeude.shp"
buildings = sf::read_sf(fn)
# exclude non-ASCII characters to purge WARNINGS
# sf::st_crs(buildings)$wkt = "PROJCRS[\"ETRS89 / UTM zone 32N\",\n    BASEGEOGCRS[\"ETRS89\",\n        DATUM[\"European Terrestrial Reference System 1989\",\n            ELLIPSOID[\"GRS 1980\",6378137,298.257222101,\n                LENGTHUNIT[\"metre\",1]]],\n        PRIMEM[\"Greenwich\",0,\n            ANGLEUNIT[\"degree\",0.0174532925199433]],\n        ID[\"EPSG\",4258]],\n    CONVERSION[\"UTM zone 32N\",\n        METHOD[\"Transverse Mercator\",\n            ID[\"EPSG\",9807]],\n        PARAMETER[\"Latitude of natural origin\",0,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8801]],\n        PARAMETER[\"Longitude of natural origin\",9,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8802]],\n        PARAMETER[\"Scale factor at natural origin\",0.9996,\n            SCALEUNIT[\"unity\",1],\n            ID[\"EPSG\",8805]],\n        PARAMETER[\"False easting\",500000,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8806]],\n        PARAMETER[\"False northing\",0,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8807]]],\n    CS[Cartesian,2],\n        AXIS[\"(E)\",east,\n            ORDER[1],\n            LENGTHUNIT[\"metre\",1]],\n        AXIS[\"(N)\",north,\n            ORDER[2],\n            LENGTHUNIT[\"metre\",1]],\n    USAGE[\n        SCOPE[\"Engineering survey, topographic mapping.\"],\n        AREA[\"Europe between 6°E and 12°E: Austria; Belgium; Denmark - onshore and offshore; Germany - onshore and offshore; Norway including - onshore and offshore; Spain - offshore.\"],\n        BBOX[38.76,6,83.92,12]],\n    ID[\"EPSG\",25832]]"
buildings |> filter(.data$funktion %in% c("Bootshaus","Gemischt genutztes Gebäude mit Wohnen",
                                          "Land- und forstwirtschaftliches Wohngebäude","Schwesternwohnheim",
                                          "Seniorenheim","Studenten-, Schülerwohnheim", "Wohngebäude mit Gemeinbedarf",
                                          "Wohngebäude mit Gewerbe und Industrie", "Wohngebäude mit Handel und Dienstleistungen",
                                          "Wohnhaus","Wohnheim"))
usethis::use_data(buildings, overwrite = TRUE)
