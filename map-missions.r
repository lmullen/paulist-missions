#!/usr/bin/env Rscript --vanilla

# Map missions of the Paulist Fathers over time
# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggplot2)
library(ggthemes)
library(maps)

missions <- read.csv("demographics-religion/data/paulist-chronicles/paulist-missions.geocoded.csv", 
                     stringsAsFactors = FALSE)

# Maps 
canada <- map_data("world", "Canada")
mexico <- map_data("world", "Mexico")
us     <- map_data("state")

# Three datasets
missions_1 <- subset(missions, year < 1866)
missions_2 <- subset(missions, year >= 1866 & year <= 1882 )
missions_3 <- subset(missions, year >= 1883)

# Base map
base_map <- ggplot() +
  coord_map() +
  geom_path(data = us, 
            aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .3) +
  geom_path(data = canada, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .3) +
  geom_path(data = mexico, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = .3) +
  theme_tufte() +
  theme(panel.border = element_blank(),
        axis.ticks   = element_blank(),
        axis.text    = element_blank(),
        axis.title   = element_blank()) +
  guides(size=guide_legend(title="Converts\nper mission")) +
  scale_size(range = c(3, 8))


# Map 1
map_1 <- base_map +
  xlim(-93,-65) +
  ylim(23, 49) +
  geom_point(data = missions_1,
             aes(x = geo.lon, y=geo.lat, size = converts_total),
             alpha = 0.5) +
  ggtitle("Redemptorist and Paulist Missions, 1852-1865") +

# pdf(file = "paulists-map-pre-civil-war.pdf",
#     height = 8.5, width = 11)
print(map_1)
# dev.off()

# Map 2
map_2 <- base_map +
#   geom_path(data = rail, aes(x = long, y= lat, group = group),
#             color = 'black', alpha = .5, size = .3) +
  xlim(-126,-65) +
  ylim(23, 51) +
  geom_point(data = missions_2,
             aes(x = geo.lon, y=geo.lat, size = converts_total),
             alpha = 0.5) +
  ggtitle("Paulist Missions 1871-1882, with Railroads in 1870")

# pdf(file = "outputs/paulists/paulists-map-post-civil-war.pdf",
#     height = 8.5, width= 11)
print(map_2)
# dev.off()

# Map 3
map_3 <- base_map +
#   geom_path(data = rail, aes(x = long, y= lat, group = group),
#             color = 'black', alpha = .5, size = .3) +
  xlim(-126,-65) +
  ylim(23, 51) +
  geom_point(data = missions_3,
             aes(x = geo.lon, y=geo.lat, size = converts_total),
             alpha = 0.5) +
  ggtitle("Paulist Missions 1883-1893, with Railroads in 1870")

# pdf(file = "outputs/paulists/paulists-map-post-civil-war.pdf",
#     height = 8.5, width= 11)
print(map_3)
# dev.off()
