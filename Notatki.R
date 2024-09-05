#===============================================================================================================================================================================================================
# Absolute basics

x <- 5 # this is how you assign numbers to variables

power_rangers_seasons <- read_csv("C:/Users/10/Desktop/power_rangers_seasons.csv") # example of how to assign a dataset to a variable

View(power_rangers_seasons) # view your dataset, CASE SENSITIVE

mean(power_rangers_seasons$season_num) # $ is for extracting elements by name from a list/dataframe

filtered_data <-filter(power_rangers_seasons, number_of_episodes > 40) # find all seasons that have > 40 episodes (RUN IN SCRIPT EDITOR - CLICK 'SOURCE THE CONTENTS OF THE ACTIVE DOCUMENT')

# %>% aka the pipe operator passes the result of the expression on its left-hand side as the first argument to the function on its right-hand side.
library(dplyr)
# Without %>%
result <- summarize(group_by(filter(mtcars, mpg > 20), cyl), mean_mpg = mean(mpg))
# With %>% (%>% can also mean "and then")
result <- mtcars %>%
  filter(mpg > 20) %>%
  group_by(cyl) %>%
  summarize(mean_mpg = mean(mpg))

# a simple boxplot
ggplot(power_rangers_seasons, aes(x = season_num, y = number_of_episodes)) +
  geom_col()
# a not so simple boxplot
ggplot(power_rangers_seasons, aes(x = season_num, y = number_of_episodes)) +
  geom_col() +
  geom_line(size = 2, color = "red") +
  scale_x_continuous(breaks = 1:28) +
  labs(x = 'Season Number', y = 'Number of Episodes')

#===============================================================================================================================================================================================================
# Basic Statistics
library(tidyverse)
data() # shows all datasets available IN THE CURRENTLY LOADED LIBRARY (in this case tidyverse)
data(package = .packages(all.available = TRUE)) # shows all available datasets in all your downloaded libraries, whether they're loaded or not

# Just like in python
mean(x)
median(x)
sum(x)
prod(x)

# Get an overview of the dataset (descriptives sorted by column)
summary(USPersonalExpenditure) # USPers... is the table name

# Obtaining mean from a table
food_tobacco <-USPersonalExpenditure['Food and Tobacco',] # row = Food and Tobacco
mean_food_tobacco <- mean(as.numeric(food_tobacco))
print(mean_food_tobacco)

# Obtaining mean from a vector
food_tobacco <- c(22.200, 44.500, 59.60, 73.2, 86.80) # create a vector and name it
mean_food_tobacco <- mean(food_tobacco)
print(mean_food_tobacco)

#===============================================================================================================================================================================================================
# Exploring Data
library(tidyverse)
?starwars
dim(starwars) # how many rows then how many variables
str(starwars) # shows the structure
glimpse(starwars) # similar to the one above but more neat
View(starwars)
head(starwars) # same in Pandas
tail(starwars) # same in Pandas
starwars$name # this is how you filter by name

attach(starwars) # so that I don't have to type starwars each time
names(starwars) # names of variables, useful to know if _ or simply space, cut and paste
class(hair_color) # type of data, was also shown in glimpse
length(hair_color) # number of observations/rows
unique(hair_color) # number of unique values within this variabe (note NA - missing data)

table(hair_color) # counts how many observations have each of these values (ie how many blonde, brown, etc)
sort(table(hair_color)) # from smallest to largest
sort(table(hair_color), decreasing = TRUE) # largest to smallest
View(sort(table(hair_color), decreasing = TRUE)) # easier to look at
barplot(sort(table(hair_color), decreasing = TRUE)) # a graph!
# you can use tidyverse to create a more intuitive code
starwars %>% # keep in mind %>% "and then"
  select(hair_color) %>%
  count(hair_color) %>%
  arrange(desc(n)) %>%
  View()

View(starwars[is.na(hair_color), ]) # argument 'is not available' shows mising values
starwars[ , ] # as you may rememeber, first position is for rows second is variables
# if given argument in first position, only SOME rows will be selected
# if second position blank = all variables/columns will be selected for the rows where the condition is true
# finding missing data will help you find the root cause of the missing data

# If dealing with numerical data, these are useful:
class(height)
length(height)
summary(height)
boxplot(height)
hist(height)
