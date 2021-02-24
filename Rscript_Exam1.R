                         ###Pre-processing###

install.packages(stringr)
library(stringr)

--------------------------------------------------------------------------------

                 ###Processing for eggs_CUFES.csv###

#"Use the “str_sub” (library stringr) function in ‘R’ to extract the year from 
#the ‘cruise’ field 
egg <- read.csv(file = "eggs_CUFES.csv", header = T, stringsAsFactors = F)

cruise_year <- str_sub(string = egg$cruise, start = 1, end = 4)

#Checking to make sure it worked
head(cruise_year)

#"Assign that value to a new field in your data frame."
egg$year <- cruise_year

#Reduce data fram to only the columns we care about
egg.exportready = egg[, c("cruise","lat_degN","lon_degE","anchovy_eggs_count","sardine_eggs_count","year")]

#"Export your processed egg data (containing only these fields) as a new .csv file"
write.csv(x = egg.exportready , file = "Eggs_Final.csv", row.names = F)

#Extraneous fields were deleted outside of R (in Excel)

--------------------------------------------------------------------------------

                 ###Processing for 195101-201404_Zoop.csv###
  
#Read in raw file
meta <- read.csv(file = "195101-201404_Zoop.csv", header = T, stringsAsFactors = F) 

  
#convert the latitude and longitude values to decimal degrees. Note the hemisphere.

###Latitude:

#Isolate characters
la.deg <- str_sub(string = meta$Lat_Deg, start = 1, end = 2)
head(la.deg)

la.min <- str_sub(string = meta$Lat_Min, start = 1, end = 4)
head(la.min)

#Make into numbers
la.deg <- as.numeric(la.deg)
la.min <- as.numeric(la.min)

#Convert to decimal degrees
dd.lat <- la.deg + la.min/60
head(dd.lat)

#Add converted decimal degrees back into data frame
meta$dd.lat <- dd.lat


###Longitude:

#Isolate characters
lo.deg <- str_sub(string = meta$Lon_Deg, start = 1, end = 3)
head(lo.deg)

lo.min <- str_sub(string = meta$Lon_Min, start = 1, end = 4)
head(lo.min)

#Make into numbers
lo.deg <- as.numeric(lo.deg)
lo.min <- as.numeric(lo.min)

#Convert to decimal degrees
dd.lon <- lo.deg + lo.min/60
head(dd.lon)

#Add in a negative sign in front of the longitude because its in the western hem.
dd.lon <- str_c("-",dd.lon, sep = "")
str(dd.lon)

#Add converted coordinates back to dataset
meta$dd.lon <- dd.lon
head(meta)

#Create a separate year field from the “Tow_Date” ...
year <- str_sub(string = meta$Tow_Date, start = 6, end = 9)
str(year)

#...and convert it from a character to integer data type
year <- as.integer(year)
str(year)

#Add it into the data frame
meta$year <- year

#Reduce data frame to only the columns we care about
meta.exportready = meta[, c("Cruise","St_Station","Tow_Date","Tow_Time","Vol_StrM3", "Tow_DpthM","dd.lat","dd.lon","year")]

#Export final product
write.csv(x = meta.exportready , file = "Metadata_Final.csv", row.names = F)