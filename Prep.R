library(tidyverse)
library(readxl)
library(leaflet)
library(maps)
library(htmltools)
library(fs)
library(sf)
library(janitor)

dir_create("raw-data")
dir_create("graphics")

download.file("https://github.com/washingtonpost/data-school-shootings/raw/master/school-shootings-data.csv",
              destfile = "raw-data/shootings.csv")

shootings <- read_csv("raw-data/shootings.csv", col_types = cols(
  .default = col_character(),
  uid = col_double(),
  year = col_double(),
  time = col_time(format = ""),
  enrollment = col_number(),
  killed = col_double(),
  injured = col_double(),
  casualties = col_double(),
  age_shooter1 = col_double(),
  shooter_deceased1 = col_double(),
  age_shooter2 = col_double(),
  shooter_deceased2 = col_double(),
  white = col_number(),
  black = col_double(),
  hispanic = col_double(),
  asian = col_double(),
  american_indian_alaska_native = col_double(),
  hawaiian_native_pacific_islander = col_double(),
  two_or_more = col_double(),
  resource_officer = col_double(),
  lat = col_double()
  # ... with 4 more columns
)) %>% clean_names()

x <- shootings %>% 
  mutate_at(vars(lat, long), funs(as.numeric)) %>% filter(!is.na(lat))

map <- leaflet(data = x) %>% addProviderTiles(providers$CartoDB.Positron) %>% 
  setView(lat = 39.8283, lng = -98.5795, zoom = 2) %>% 
  addCircleMarkers(
    radius = ~ifelse(x$casualties<=4, 2, 6),
    lng = ~long, lat = ~lat, 
    popup = ~paste0(
      "<div>",
      "<h3>",
      x$school_name,
      "</h3>",
      "Date: ",
      x$date,
      "<br>",
      "Casualties: ",
      x$casualties,
      "</div>"
    )
  )

write_rds(map, "graphics/map.rds")

library(shiny)
file_copy(path = "graphics/map.rds", new_path = "Project/map.rds")

p <- read_rds("Project/map.rds")

