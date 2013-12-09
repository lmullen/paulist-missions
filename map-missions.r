#!/usr/bin/env Rscript --vanilla

# Map missions of the Paulist Fathers over time
# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(lubridate)
library(ggplot2)
library(ggthemes)
library(maps)

missions <- read.csv("demographics-religion/data/paulist-chronicles/paulist-missions.geocoded.csv", 
                     stringsAsFactors = FALSE)

missions$year <- year(mdy(missions$start_date))

# Give approximations of the values "several" and "many"; replace NA with 0
missions$converts[missions$converts == "several"] <- 3
missions$converts[missions$converts == "many"]    <- 7
missions$converts <- as.integer(missions$converts)
missions$converts[is.na(missions$converts)]       <- 0

# Count converts and those left under instruction together
missions$under_instruction <- as.integer(missions$under_instruction)
missions$under_instruction[is.na(missions$under_instruction)]       <- 0
missions$converts_total <- missions$converts + missions$under_instruction

# Defaults for maps 
my_theme <- theme_tufte() +
  theme(panel.border = element_blank(),
        axis.ticks   = element_blank(),
        axis.text    = element_blank(),
        axis.title   = element_blank())

# Maps 
canada <- map_data("world", "Canada")
mexico <- map_data("world", "Mexico")
us     <- map_data("state")

# Map of missions before Civil War
missions_cw <- subset(missions, year < 1866)

plot <- ggplot() +
  coord_map() +
  geom_path(data = us, 
            aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .3) +
  geom_path(data = canada, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .3) +
  geom_path(data = mexico, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .3) +
  xlim(-93,-65) +
  ylim(23, 49) +
  geom_point(data = missions_cw,
             aes(x = geo.lon, y=geo.lat, size = converts),
             alpha = 0.5) +
  ggtitle("Redemptorist and Paulist Missions, 1852-1865 ") +
  my_theme +
  guides(size=guide_legend(title="Converts\nper mission")) +
  scale_size(range = c(3, 8))
print(plot)

