# read in the csv files
links <- read.csv("data/links.csv")
movies <- read.csv("data/movies.csv")
ratings <- read.csv("data/ratings.csv")
tags <- read.csv("data/tags.csv")

# save as .RData
save(links,movies,ratings,tags,file="data/movielens-small.RData")

# check that its worked
rm(list=ls())
load("data/movielens-small.RData")

#loads bunch of packages...including dplyr
library(tidyverse)

load("data/movielens-small.RData")

# convert ratings to a "tibble"
ratings <- as.tibble(ratings)
ratings
glimpse(ratings)
str(ratings)
glimpse(movies)

# left join..
ratings <- left_join(ratings, movies)

# FUN filter() 
# eg...user one data
u1 <- filter(ratings, userId == 1)
u1
# more specific
filter(ratings, userId == 1 & rating > 3) 
#or, same thing
filter(ratings, userId == 1, rating > 3)
#using %in% useful
filter(ratings, userId == 1, rating %in% c(1,4))

# filtering with the pipe
ratings %>% filter(userId == 1)
# first filter on userId then on rating
u1_likes <- ratings %>% filter(userId == 1) %>% filter(rating > 3)
u1_likes

# another way of doing the same thing
ratings %>% filter(userId == 1 & rating > 3)

#FUN arrange()
