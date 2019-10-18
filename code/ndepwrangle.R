
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

  




