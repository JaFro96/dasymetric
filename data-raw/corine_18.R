## code to prepare `corine_18` dataset goes here

load("data/districts.rda")
temp = tempfile()
temp2 = tempfile()
download.file("https://daten.gdz.bkg.bund.de/produkte/dlm/clc5_2018/aktuell/clc5_2018.utm32s.shape.zip",temp)
require(sf)
unzip(zipfile=temp, exdir = temp2)
file_list = list.files(temp2, pattern = "xx.shp$", recursive = TRUE, full.names=TRUE)
SHP_file_list = lapply(file_list, read_sf)
SHP_file_list = lapply(SHP_file_list,st_crop(st_bbox(districts)))
SHP_file = rbind(SHP_file_list[[1]], SHP_file_list[[2]], SHP_file_list[[3]], SHP_file_list[[4]], SHP_file_list[[5]])
corine_18 = st_crop(SHP_file, st_bbox(districts))

usethis::use_data(corine_18, overwrite = TRUE)
