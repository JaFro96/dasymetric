## code to prepare `population_counts` dataset goes here
require(readr)
require(dplyr)
require(tidyr)
population_counts <- read_delim("inst/population_counts.csv",delim = ";",
                                escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),trim_ws = TRUE)

population_counts <- population_counts %>% filter(ZEIT=="31.12.2018") %>% separate(col = RAUM, c("NR_STATIST","name"), sep = 2)

population_counts <- inner_join(districts,population_counts) %>% rename(pop_counts=WERT) %>%
    select(c(NR_STATIST,NAME_STATI,STADTBEZIR,pop_counts,SHAPE_AREA))

usethis::use_data(population_counts, overwrite = TRUE)
