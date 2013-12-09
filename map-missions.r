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
# -------------------------------------------------------------------
my_theme <- theme_tufte() +
  theme(panel.border = element_blank(),
        axis.ticks   = element_blank(),
        axis.text    = element_blank(),
        axis.title   = element_blank())
