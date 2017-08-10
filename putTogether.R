#In this section we'll take what we've learned and do something useful:
# build a 15x20 matrix containing the reviews made on 20 movies by 15 users.
# We'll use this matrix in the next lesson to build a recommendation system.

#First, we select the 15 users we want to use. I've chosen to use 15 users
# with moderately frequent viewing habits (remember there are 700 users
#  and 9000 movies), mainly to make sure there are some (but not too many) empty ratings.

users_frq <- ratings %>% group_by(userId) %>% summarize(count = n()) %>% arrange(desc(count))
my_users <- users_frq$userId[101:115]

#Next, we select the 20 movies we want to use:
movies_frq <- ratings %>% group_by(movieId) %>% summarize(count = n()) %>% arrange(desc(count))
my_movies <- movies_frq$movieId[101:120]

# Now we make a dataset with only those 15 users and 20 movies:
ratings_red <- ratings %>% filter(userId %in% my_users, movieId %in% my_movies) 

# and check there are 15 users and 20 movies in the reduced dataset
n_users <- length(unique(ratings_red$userId))
n_movies <- length(unique(ratings_red$movieId))
print(paste("number of users is",n_users))
print(paste("number of movies is",n_movies))

#Let's see what the 20 movies are:
movies %>% filter(movieId %in% my_movies) %>% select(title)

#However, note all the movie titles are still being kept:
head(levels(ratings_red$title))

#This actually isn't what we want, so let's drop the ones we won't use.
ratings_red <- droplevels(ratings_red)
levels(ratings_red$title)

#We now want to reshape the data frame into a 15x20 matrix
# i.e.from "long" format to "wide" format.
# We can do this using the spread() verb.
ratings_red %>% spread(key = movieId, value = rating)

#The preceding line doesn't work: as you can see we land up with more than
#one row per user.But it is useful as an illustration of spread().
# Question: why doesn't it work? ANS: Got something to do with genres...

#Here's the corrected version:
ratings_red %>% select(userId,title,rating) %>% spread(key = title, value = rating)

#Finally, since we just want to know who has seen what,
# we replace all NAs with 0 and all other ratings with 1:
viewed_movies <- ratings_red %>% 
select(userId,title,rating) %>% 
complete(userId, title) %>% 
mutate(seen = ifelse(is.na(rating),0,1)) %>% 
select(userId,title,seen) %>% 
spread(key = title, value = seen)

#We could have got this more simply with a call to table(), which creates a two-way frequency table.

table(ratings_red$userId,ratings_red$title)

#Finally, we save our output for use in the next lesson!
save(ratings_red, viewed_movies, file = "output/recommender.RData")
