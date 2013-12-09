#!/usr/bin/env Rscript --vanilla

# Map missions of the Paulist Fathers over time
# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggplot2)
library(ggthemes)
library(maps)

missions <- read.csv("demographics-religion/data/paulist-chronicles/paulist-missions.geocoded.csv", 
                     stringsAsFactors = FALSE)

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
missions_precw <- subset(missions, year < 1866)

map_precw <- ggplot() +
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
  geom_point(data = missions_precw,
             aes(x = geo.lon, y=geo.lat, size = converts),
             alpha = 0.5) +
  ggtitle("Redemptorist and Paulist Missions, 1852-1865 ") +
  my_theme +
  guides(size=guide_legend(title="Converts\nper mission")) +
  scale_size(range = c(3, 8))

pdf(file = "paulists-map-pre-civil-war.pdf",
    height = 8.5, width = 11)
print(map_precw)
dev.off()

# Map after the Civil War
missions_postcw <- subset(missions, year >= 1866 )

map_postcw <- ggplot() +
  coord_map() +
  geom_path(data = us, 
            aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .2) +
  geom_path(data = canada, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .2) +
  geom_path(data = mexico, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .2) +
#   geom_path(data = rail, aes(x = long, y= lat, group = group),
#             color = 'black', alpha = .5, size = .3) +
  xlim(-126,-65) +
  ylim(23, 51) +
  geom_point(data = missions_postcw,
             aes(x = geo.lon, y=geo.lat, size = converts),
             alpha = 0.5) +
  my_theme +
  theme(legend.position="bottom") +
  scale_size(range = c(3, 8)) +
  guides(size=guide_legend(title="Converts\nper mission")) +
  ggtitle("Paulist Missions 1871-1886, with Railroads in 1870")

pdf(file = "outputs/paulists/paulists-map-post-civil-war.pdf",
    height = 8.5, width= 11)
print(map_postcw)
dev.off()
