## code to prepare `districts` dataset goes here

temp = tempfile()
temp2 = tempfile()
download.file("https://www.stadt-muenster.de/fileadmin//user_upload/stadt-muenster/61_stadtentwicklung/pdf/karten/stadtteil_statistischer-bezirk.zip",temp)
require(sf)
unzip(zipfile=temp, exdir = temp2)
SHP_file = list.files(temp2, pattern = ".shp$",full.names=TRUE)
districts = sf::read_sf(SHP_file)

usethis::use_data(districts, overwrite = TRUE)
