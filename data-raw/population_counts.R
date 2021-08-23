## code to prepare `population_counts` dataset goes here
require(readr)
require(dplyr)
require(tidyr)
population_counts <- read_delim("inst/population_counts.csv",delim = ";",
                                escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),trim_ws = TRUE)

population_counts <- population_counts |> filter(ZEIT=="31.12.2018") |> separate(col = RAUM, c("NR_STATIST","name"), sep = 2)

population_counts <- inner_join(districts,population_counts) |> rename(population=WERT) |>
    select(c(NR_STATIST,NAME_STATI,STADTBEZIR,population,SHAPE_AREA))
sf::st_crs(population_counts)$wkt = "PROJCRS[\"ETRS89 / UTM zone 32N\",\n    BASEGEOGCRS[\"ETRS89\",\n        DATUM[\"European Terrestrial Reference System 1989\",\n            ELLIPSOID[\"GRS 1980\",6378137,298.257222101,\n                LENGTHUNIT[\"metre\",1]]],\n        PRIMEM[\"Greenwich\",0,\n            ANGLEUNIT[\"degree\",0.0174532925199433]],\n        ID[\"EPSG\",4258]],\n    CONVERSION[\"UTM zone 32N\",\n        METHOD[\"Transverse Mercator\",\n            ID[\"EPSG\",9807]],\n        PARAMETER[\"Latitude of natural origin\",0,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8801]],\n        PARAMETER[\"Longitude of natural origin\",9,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8802]],\n        PARAMETER[\"Scale factor at natural origin\",0.9996,\n            SCALEUNIT[\"unity\",1],\n            ID[\"EPSG\",8805]],\n        PARAMETER[\"False easting\",500000,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8806]],\n        PARAMETER[\"False northing\",0,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8807]]],\n    CS[Cartesian,2],\n        AXIS[\"(E)\",east,\n            ORDER[1],\n            LENGTHUNIT[\"metre\",1]],\n        AXIS[\"(N)\",north,\n            ORDER[2],\n            LENGTHUNIT[\"metre\",1]],\n    USAGE[\n        SCOPE[\"Engineering survey, topographic mapping.\"],\n        AREA[\"Europe between 6°E and 12°E: Austria; Belgium; Denmark - onshore and offshore; Germany - onshore and offshore; Norway including - onshore and offshore; Spain - offshore.\"],\n        BBOX[38.76,6,83.92,12]],\n    ID[\"EPSG\",25832]]"

usethis::use_data(population_counts, overwrite = TRUE)
