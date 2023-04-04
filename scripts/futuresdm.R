
# get climate data 
currentEnv <- clim # renaming from the last sdm because clim isn't very specific

#to set our specific future data
futureEnv <- raster::getData(name = 'CMIP5', var = 'bio', res = 2.5,
                             rcp = 45, model = 'IP', year = 70, path="data") 

names(futureEnv) = names(currentEnv)
# look at current vs future climate vars
plot(currentEnv[[1]])
plot(futureEnv[[1]])


# crop clim to the extent of the map you want
geographicAreaFutureC5 <- crop(futureEnv, predictExtent)


# predict  model onto future climate
tortoisePredictPlotFutureC5 <- raster::predict(tortoiseSDM, geographicAreaFutureC5)  

# for ggplot, we need the prediction to be a data frame 
#convert output of ranapredictplot to a data frame
raster.spdfFutureC5 <- as(tortoisePredictPlotFutureC5, "SpatialPixelsDataFrame")
tortoisePredictDfFutureC5 <- as.data.frame(raster.spdfFutureC5)

#PLOT IT!!!
wrld <- ggplot2::map_data("world")

# get our lat/long boundaries
xmax <- max(tortoisePredictDfFutureC5$x)
xmin <- min(tortoisePredictDfFutureC5$x)
ymax <- max(tortoisePredictDfFutureC5$y)
ymin <- min(tortoisePredictDfFutureC5$y)


ggplot() +
  geom_polygon(data = wrld, mapping = aes(x = long, y = lat, group = group),
               fill = "grey75") +
  geom_raster(data = tortoisePredictDfFutureC5, aes(x = x, y = y, fill = layer)) + 
  scale_fill_gradientn(colors = terrain.colors(10, rev = T), limits = c(0,1)) +
  coord_fixed(xlim = c(xmin, xmax), ylim = c(ymin, ymax), expand = F) +
  scale_size_area() +
  borders("world") +
  borders("state") +
  labs(title = "SDM of G. Morafkai Under CMIP 5 Climate Conditions",
       x = "longitude",
       y = "latitude",
       fill = "Env Suitability") +
  theme(legend.box.background=element_rect(),legend.box.margin=margin(5,5,5,5)) 


#Live ggsave here:

ggsave(filename="futureSDM.jpg", plot=last_plot(),path="output", width=1600, height=800, units="px")


