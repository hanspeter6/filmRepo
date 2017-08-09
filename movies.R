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
arrange(u1_likes, desc(rating))
arrange(u1_likes, desc(rating),timestamp)

#using pipe
u1_likes %>% arrange(desc(rating))

#combining filter and arrange, using pipe
ratings %>% filter(userId == 1 & rating > 3) %>% arrange(desc(rating))

#FUN select()
select(u1_likes,title,rating)
#can exclude
select(u1_likes,-userId,-timestamp)
#using FUN everything() and ordering
# original order
u1_likes

# reorder so title is first
select(u1_likes, title, everything())

#FUN mutate()
mutate(u1_likes, this_is = "stupid")
mutate(u1, like = ifelse(rating > 3, 1, 0))  

#and using pipes
ratings %>% 
        mutate(like = ifelse(rating > 3, 1, 0)) %>%
                filter(userId == 1) %>% 
                        select(like, everything()) 

# FUN summarise(): rows into a single row
summarise(u1, mean = mean(rating), likes = sum(rating > 3))
# for NAs
# with na.rm = T
summarise(u1, mean = mean(rating, na.rm = T), likes = sum(rating > 3, na.rm = T))

# FUN groupby() : very useful to use with summarise()
# tell dplyr to group ratings by userId
ratings_by_user <- group_by(ratings, userId)

# apply summarize() to see how many movies each user has rated
ratings_by_user %>% summarize(count = n()) %>% head()

# get sorted counts (plus some presentation stuff)
ratings %>% 
        group_by(userId) %>% 
        summarize(count = n()) %>% 
        arrange(desc(count)) %>% 
        head(20) %>%     # take first two rows
        t()  # transpose 
# or with the pipe (last time)
ratings %>% group_by(userId) %>% summarize(count = n()) %>% head(10)

# using grouped grouped filters and grouped mutates
# example of a grouped filter
ratings %>% group_by(userId) %>% filter(rank(desc(rating)) < 2)

# example of a grouped mutate
ratings %>% 
        group_by(userId) %>%
        mutate(centered_rating = rating - mean(rating)) %>% 
        select(-movieId,-timestamp,-genres)
