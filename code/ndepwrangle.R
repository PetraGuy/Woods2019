
#convert Ndep data to long lat and extratc relevant data
setwd("C:/dev/code/Woods2019/code")
library(rgdal)

ndep = read.csv("../data/Ndep2014.csv", 
                stringsAsFactors = TRUE, 
                header = TRUE, skip = 6)

#coords <- cbind(Easting = as.numeric(as.character(ndep$Easting)),
                #Northing = as.numeric(as.character(ndep$Northing)))
#creatre unique id for each row
ndep_ID =  1:nrow(ndep)
ndep = cbind(ndep_ID, ndep)


coords <- cbind(Easting = as.numeric(as.character(ndep$Easting)),
                Northing = as.numeric(as.character(ndep$Northing)))


#create spatioal points dataframe
ndepSP = SpatialPointsDataFrame(coords, 
                            data = data.frame(ndep$Value,ndep$ndep_ID), 
                            proj4string = CRS("+init=epsg:27700"))

#convert to long lat
ndeplonglat = spTransform(ndepSP,  CRS("+proj=longlat +datum=WGS84"))

#change colnames
colnames(ndeplonglat@coords)[colnames(ndeplonglat@coords) == "Easting"] <- "Longitude"
colnames(ndeplonglat@coords)[colnames(ndeplonglat@coords) == "Northing"] <- "Latitude"

#take out long lat and ndep value in new df

ndeplonglatdf = as.data.frame(cbind(long = ndeplonglat@coords[,1],
                      lat = ndeplonglat@coords[,2],
                      ndep = ndeplonglat@data[,1]))

#look at the ndep values?
library(ggrepel)
library(ggplot2)
library(maps)
library(mapproj)
library(ggmap)

register_google(key = "key")

UK <- map_data(map = "world", region = "UK") # changed map to "world"
ggplot(data = UK, aes(x = long, y = lat, group = group)) + 
  geom_polygon(alpha = 0.5) +
  scale_x_continuous(breaks = c(-6,-5,-4,-3,-2,-1,0,1),limits = c(-7,2))+
  scale_y_continuous(breaks = c(50,51,52,53,54,55,56,57,58),limits = c(50,59))+
  coord_map()+
  geom_point(data = ndeplonglatdf, mapping = aes(x = long, y = lat), # this data is file of long and lats
             inherit.aes = FALSE)+
  #geom_text_repel(data = ndeplonglatdf, aes(x = long, y = lat,label = site), 
                 # inherit.aes = FALSE, size = 4, hjust = 0.5, vjust = 0.5)+
  theme(plot.margin=unit(c(0,0,0,0),"mm"))

# add a clour gradient

UK = get_map(location = c(lon = -1.5, lat = 54),
                    color = "color",
                    source = "google",
                    maptype = "satellite",
                    zoom = 6)
ggmap(UK) +
  geom_point(data = ndeplonglatdf, 
             aes(x = long, y = lat, colour = ndep))+
  scale_colour_gradient(low = "white", 
                        high = "red") + 
  scale_size_continuous(range = c(0,10))
  
  




