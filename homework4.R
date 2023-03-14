#this is the homework 4 in-class assignment
#guess i should load in the packages the other one had --the gbif querying mapping one:

install.packages("spocc")
install.packages("tidyverse") #includes ggplot
library(spocc)
library(tidyverse)
#animal: sonoran desert tortoise
#scientific name: gopherus morafakai
#let's try searcing gbif
myquery <- occ(query='gopherus morafakai', from=c('gbif'), limit=4000)
#that did nothing. hmm
#group said to rerun these:
library(spocc)
library(tidyverse)
#trying again now
myquery <- occ(query='gopherus morafakai', from=c('gbif'), limit=4000)
myquery
#still not great. why 0 results
myquery <- occ(query='Gopherus morafakai', from=c('gbif'), limit=4000)
myquery
#?!
#oh they misspelled it on the spreadsheet.
myquery <- occ(query='Gopherus morafkai', from=c('gbif'), limit=4000)
myquery
#THATS what im talking about!
#drilling down in the data --ignoring the other databases:
morafkai<-myquery$gbif$data$Gopherus_morafkai
#let's try a rudimentary map now
ggplot() + geom_point(data=morafkai, mapping=aes(x=longitude, y=latitude), show.legend=FALSE) + 
  labs(title="species occurences", x="longitude", y="latitude")
#cool. that looks like nothing cause i can't see continents. lets do that second step
wrld <- ggplot2::map_data("world")
#oh right. you have to run the wlrd one first and then the ggplot string.
ggplot() + geom_point(data=morafkai, mapping=aes(x=longitude, y=latitude), show.legend=FALSE) + 
  labs(title="species occurences", x="longitude", y="latitude")
#hmm i guess that's just how it's supposed to look?
ggplot()+
  geom_polygon(data=wrld, mapping=aes(x=long, y=lat, group=group), fill="grey75", color="grey60")+ 
  geom_point(data=morafkai, mapping=aes(x=longitude, y=latitude), show.legend=FALSE)+
  borders("county")+
  labs(title="Species occurences of G. morafkai", x="longitude", y="latitude")
#oh darn it still has the county thing in there
ggplot()+
  geom_polygon(data=wrld, mapping=aes(x=long, y=lat, group=group), fill="grey75", color="grey60")+ 
  geom_point(data=morafkai, mapping=aes(x=longitude, y=latitude), show.legend=FALSE)+
  labs(title="Species occurences of G. morafkai", x="longitude", y="latitude")
#yeah baby. that's what i want exactly.
#now i should probably try doing some basic cleaning like last week.
noNApoints <- morafkai %>% filter (latitude != "NA", longitude !="NA")
#ok that's good. can't check w/ group cause they cleaned all at once but i think that's right
#now to delete duplicates
#make new column first
noDuplicates <- noNApoints %>% mutate(location = paste 
                                       (latitude, longitude, dateIdentified, sep = "/") )
#why. it was messed up last time too.
#oh it was a capitalization issue and it was fine from last time
#now this new function will look in the new column and do its stuff. 
#I'll call it noDuplicates2
noDuplicates2 <- noDuplicates %>% distinct(location, .keep_all = TRUE)
#making x and y limits

xMax <- max(noDuplicates2$longitude)
xMin <- min(noDuplicates2$longitude)
yMax <- max(noDuplicates2$latitude)
yMin <- min(noDuplicates2$latitude)

#now to make the map with x and y values "zoomed in"
ggplot()+
  geom_polygon(data=wrld, mapping=aes(x=long, y=lat, group=group), fill="grey75", color="grey60")+ 
  geom_point(data=noDuplicates2, mapping=aes(x=longitude, y=latitude), show.legend=FALSE)+
  scale_size_area()+ 
  coord_fixed(xlim = c(xMin, xMax), ylim = c(yMin, yMax))+ 
  borders("state")+
  labs(title="Species occurrences of G. morafkai", x="longitude", y="latitude")
#nice, that worked
#oh, more filtering needs to be done apparently because we haven't actually
#[con'td]... done the stage where we "remove points where occurrence status is not present". 
#i'll make ANOTHER new variable...
#didn't work at first but then i realized i hadn't referred it to any data
#so I added in the noDuplicates2 variable and a comma and that worked:
cleanTortoise <- filter(noDuplicates2, occurrenceStatus == "PRESENT")
#that worked great but i guess now the map is maybe outdated idk
#guess not, technically the points are the same
#date range in title --a fun little thing to add
range(as.Date(na.omit(occurrencePresent$dateIdentified)))
#there we go
#now let's put it in the graph title
ggplot()+
  geom_polygon(data=wrld, mapping=aes(x=long, y=lat, group=group), fill="grey75", color="grey60")+ 
  geom_point(data=noDuplicates2, mapping=aes(x=longitude, y=latitude), show.legend=FALSE)+
  scale_size_area()+ 
  coord_fixed(xlim = c(xMin, xMax), ylim = c(yMin, yMax))+ 
  borders("state")+
  labs(title="Species occurrences of G. morafkai, 1968-2022", x="longitude", y="latitude")
#mila also suggested fancying up the map by adding colors or state names or something
#Whitney appears to be struggling with writing code to put state names on map
#apparently this is a pretty complicated thing to add; the other 2 members are consulting intensely

