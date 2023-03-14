install.packages("dismo")
install.packages("maptools")
install.packages("tidyverse")
install.packages("rJava")
install.packages("maps")
install.packages("spocc")

library(dismo)
library(maptools)
library(tidyverse)
library(rJava)
library(maps)
library(spocc)

#Query for Gopherus morafkai (Sonoran desert tortoise) data from GBIF, with a limit of 4000.
tortoiseQuery <- occ(query = "Gopherus morafkai", from="gbif", limit = 4000)
tortoiseQuery

tortoise <- tortoiseQuery$gbif$data$Gopherus_morafkai


#Cleaning data...
#Removing where lat/long are NA
clean.tortoise <- tortoise %>%
  filter(latitude != "NA", longitude != "NA") %>%
  #Removing duplicates
  mutate(location = paste(latitude, longitude, dateIdentified, sep = "/")) %>%
  distinct(location, .keep_all = TRUE) %>%
  filter(occurrenceStatus == "PRESENT")
#We did not feel the need to remove any illogical data points,
#because we felt that all of our occurrence data was very localized.