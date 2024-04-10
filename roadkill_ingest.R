pacman::p_load(tidyverse,
               fs,
               janitor,
               glue,
               sf)
# Take data from the Road Lab AKA project splatter, filter to LEP area and save as csv for upload to ODS portal
# Load the data

lep_boundary <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LEP_Dec_2014_UGCB_in_England_2022/FeatureServer/0/query?where=lep14nm%20%3D%20'WEST%20OF%20ENGLAND'&outFields=lep14cd,lep14nm&outSR=4326&f=json")

#https://www.theroadlab.co.uk/

rk_raw <- read_csv("data/records-2024-04-10.csv")

rk_sf  <-  rk_raw %>% 
  clean_names() %>% 
  filter(!is.na(longitude_wgs84) & !is.na(latitude_wgs84)) %>% 
  filter(osgr_100km == "ST") %>%
  st_as_sf(coords = c("longitude_wgs84", "latitude_wgs84"), crs = 4326) %>% 
  st_intersection(lep_boundary) %>% 
  dplyr::mutate(longitude_wgs84 = sf::st_coordinates(.)[, 1],  # Longitude
                latitude_wgs84 = sf::st_coordinates(.)[, 2])  %>%
  st_drop_geometry()

# Filter out records that are not within the boundary of the LEP
  
  
rk_sf %>% write_csv("data/rk_sf.csv", na = "")
