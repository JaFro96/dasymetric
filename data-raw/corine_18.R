## code to prepare `corine_18` dataset goes here

load("data/districts.rda")
temp = tempfile()
temp2 = tempfile()
#download.file("https://daten.gdz.bkg.bund.de/produkte/dlm/clc5_2018/aktuell/clc5_2018.utm32s.shape.zip",temp)
temp = "C:/Users/janni/Downloads/clc5_2018.utm32s.shape.zip"
require(sf)
unzip(zipfile=temp, exdir = temp2)
file_list = list.files(temp2, pattern = "xx.shp$", recursive = TRUE, full.names=TRUE)
shp_list = lapply(file_list,read_sf)
shp_list[[1]] = st_crop(shp_list[[1]],st_bbox(districts))
shp_list[[2]] = st_crop(shp_list[[2]],st_bbox(districts))
shp_list[[3]] = st_crop(shp_list[[3]],st_bbox(districts))
shp_list[[4]] = st_crop(shp_list[[4]],st_bbox(districts))
shp_list[[5]] = st_crop(shp_list[[5]],st_bbox(districts))
#shp_list = lapply(shp_list,st_crop(y = st_bbox(districts)))
corine_18 = rbind(shp_list[[1]], shp_list[[2]], shp_list[[3]], shp_list[[4]], shp_list[[5]])
# corine_18 = st_crop(SHP_file, st_bbox(districts))

usethis::use_data(corine_18, overwrite = TRUE)
