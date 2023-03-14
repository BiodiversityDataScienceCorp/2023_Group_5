

#Install packages and load libraries:

install.packages("spocc")
install.packages("tidyverse") #includes ggplot
library(spocc)
library(tidyverse)

# gbifopts: run occ_options('gbif') in console to see possibilities()
occ_options('gbif')
#In groups: write a query for Rana draytonii from GBIF. 
#Any country. Any time period. Limit 5000.

MyQuery <- occ(query='Rana draytonii', from=c('gbif'), limit=4000)

# Drill down to get the data using "$", and show from Env window

rana <- MyQuery$gbif$data$Rana_draytonii

### Let's initially plot the data on a map.

ggplot()+
  geom_point(data=rana, mapping=aes(x=longitude, y=latitude), show.legend=FALSE) +
  labs(title = "species occurences", x="longitude", y="latitude")

wrld <- ggplot2::map_data("world")
# say we want to add country lines

ggplot()+
  geom_polygon(data=wrld, mapping=aes(x=long, y=lat, group=group), fill="grey75", color = "grey60")+
  geom_point(data=rana, mapping=aes(x=longitude, y=latitude), show.legend=FALSE) +
  labs(title = "species occurences", x="longitude", y="latitude")

# 5 minute break!

#cleaning data: what do we need to do based on the reading for today? 
##remove outliers (outside normal species range), remove duplicates, deal with NA values

#removing outliers:
noAfricaPoints <- rana %>% filter(longitude < 0)

#NA values: 
noNApoints <- noAfricaPoints %>% filter(latitude != "NA", longitude != "NA")

#remove duplicates: 
noDuplicates <- noNApoints %>% mutate(location = paste(latitude, longitude, sep = "/")) %>% 
  distinct(location, .keep_all=TRUE)

cleanRana <- rana %>% 
  filter(longitude < 0) %>% 
  filter(latitude != "NA", longitude != "NA") %>% 
  mutate(location = paste(latitude, longitude, dateIdentified, sep = "/"))%>%
  distinct(location, .keep_all=TRUE)


# set x and y limits
xmax <- max(cleanRana$longitude)
xmin <- min(cleanRana$longitude)
ymax <- max(cleanRana$latitude)
ymin <- min(cleanRana$latitude)

# re-do map code with cleaned data and x/y limits
ggplot()+
  geom_polygon(data=wrld, mapping=aes(x=long, y=lat, group=group), fill="lavender", color = "grey60")+
  geom_point(data=cleanRana, mapping=aes(x=longitude, y=latitude), show.legend=FALSE) +
  labs(title = "species occurences of R. draytonii from 1938-2023", x="longitude", y="latitude") +
  coord_fixed(xlim = c(xmin, xmax), ylim = c(ymin,ymax))+
  scale_size_area()+
  borders("state")

#make it better by adding a date range in the title: 
range(as.Date(na.omit(cleanRana$dateIdentified)))



