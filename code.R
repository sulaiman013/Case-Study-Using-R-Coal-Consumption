#SETTING WORKING DIRECTORY AND INSTALLING NECESSARY PACKAGES

setwd("F:\\work\\Data Wrangling In R\\Coal Consumption")
library(tidyverse)

#IMPORTING DATASET
coal <- read_csv('coal.csv', skip = 2)
glimpse(coal)

#CHANGING 1ST COLUMN NAME
colnames(coal)[1] <- 'region'

#SUMMARY STATISTICS
summary(coal)

#MAKING WIDE DATASET LONG USING GATHER FUNCTION

coal_long <- gather(coal, 'year', 'coal_consumption', -region)

#FIXING CLASSES OF VARIABLES AND ASSIGNING PROPER CLASSES
coal_long$year <- as.integer(coal_long$year)
coal_long$coal_consumption <- as.numeric(coal_long$coal_consumption)

glimpse(coal_long)

#SEPERATING NA (NULL) VALUES AND REMOVING THEM FROM DATASET
coal_na <- which(is.na(coal_long$coal_consumption))
coal_long <- coal_long[-coal_na,]

#DATASET OPTIMIZING : SEPERATING 'NON COUNTRY' ELEMENTS FROM REGION VARIABLE

unique(coal_long$region)
non_countries <- c("North America", "Central & South America","Antarctica",
                   "Europe", "Eurasia","Middle East","Africa", "World")

match(coal_long$region, non_countries)
matches <- which(!is.na(match(coal_long$region, non_countries)))

coal_country <- coal_long[-matches,]
colnames(coal_country)[1] <- 'Country'

coal_region <- coal_long[matches,]
unique(coal_region$region)


#DATASET OPTIMIZING: SEPERATING 'WORLD' OBSERVATIONS FROM COAL_REGION AND CREATING
#ANOTHER DATASET  

world <- c("World")
matches2 <- which(!is.na(match(coal_region$region, world)))

coal_region <- coal_region[-matches2,]
coal_world <- coal_region[matches2,]

colnames(coal_world)[1] <- 'Planet'
unique(coal_world$region)

#LETS SEE THE DATASET

glimpse(coal_country)
unique(coal_country$Country)

glimpse(coal_region)
unique(coal_region$region)

glimpse(coal_world)
unique(coal_world$Planet)

#DATA VISUALIZATION

ggplot(data = coal_region, aes(x = year, y= coal_consumption)) +
  geom_line(aes(colour = region))

ggplot(data = coal_world, aes(x = year, y= coal_consumption)) +
  geom_line(aes(colour = Planet))