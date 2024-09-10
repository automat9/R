#===============================================================================================================================================================================================================
# Absolute basics
library(tidyverse)
%>% # = shift + ctrl + M
# Common steps of data analysis using R: 
# Explore
# Clean
# Manipulate
# Describe & Summarise
# Visualise
# Analyse

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
# Explore
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

#===============================================================================================================================================================================================================
# Clean

# What does it even mean?
# A: Each variable is the correct type of data (e.g. int), 
# select and filter data you want to use
# find missing data and duplicates,
# recode values. 


library(tidyverse)
View(starwars)

# Variable types
glimpse(starwars) #chr,character int,integer, dbl,double(float), list, fct,factor (stores values + possible levels (of importance))
class(starwars$gender) # class of variable
unique(starwars$skin_color) # unique values in that variable

starwars$gender <- as.factor(starwars$gender)
class(starwars$gender) # assigning order/rank to values in a variable
levels(starwars$gender) # 1.feminine, 2.masculine, to change it do:
starwars$gender <- factor((starwars$gender), levels = c("masculine", 
                                                        "feminine")) # good practice to rearrange vertically not horizontally)
levels(starwars$gender)

# Select variables

names(starwars) # names of variables

starwars %>%
  select(name, height, ends_with("color")) %>%
  print(n = 77) # selects name, height, and all variables that end with color, then prints out 77 results (without it it would've been the first 10)

# Filter
unique(starwars$hair_color)

starwars %>%
  select(name, height, ends_with("color")) %>%
  filter(hair_color %in% c("blond", "brown") & height < 180) # OR = concatenate, AND = & (separate element from the list)

# Missing Data # do not exclude all missing data, as some of that info might be useful
mean(starwars$height, na.rm = TRUE) # removes 'not available' from calculation, thus making it possible to calculate mean

starwars %>%
  select(name, gender, hair_color, height)

starwars %>%
  select(name, gender, hair_color, height) %>%
  na.omit() # easy way out, we don't know what we've lost, it just omitts all the missing data

starwars %>%
  select(name, gender, hair_color, height) %>%
  filter(!complete.cases(.)) %>%
  drop_na(height)
# VERY IMPORTANT, without ! it would filter by complete cases (essentially same one as above), but with ! we now get a list showing all the entries with missing d
# here, drop_na omitts missing height

starwars %>%
  select(name, gender, hair_color, height) %>%
  filter(!complete.cases(.)) %>%
  mutate(hair_color2 = replace_na(hair_color, "none"))
# characters with missing hair are in fact robots, so they can't have hair
# we can use hair_color or hair_color 2  (as shown above) to either update the old column or create a new one for comparison)

# Duplicates (no duplicates in starwars, so let's create a new dataset)
Names <- c("Peter", "Andy", "John", "Peter")
Age <- c(22, 33, 44, 22)

friends <- data.frame(Names, Age)

friends[!duplicated(friends), ] # omitts duplicates

# Recoding variables # e.g. if we need some variables to be coded as 1 and 2
starwars %>% 
  select(name, gender) %>%
  mutate(gender = recode(gender,
                         "masculine" = 1,
                         "feminine" = 2))

#===============================================================================================================================================================================================================
# Manipulate
library(tidyverse)
View(msleep)

# Rename
msleep %>%
  rename("conserv" = "conservation")
glimpse(msleep)

# Reorder variables
msleep %>% 
  select(vore, name, everything()) # first vore, name, then everything else

# Change a variable type
class(msleep$vore)
msleep$vore <- as.factor(msleep$vore)
glimpse(msleep)
levels(msleep$vore) # shows values stored in that variable (ranked/ordered)
# another way to do the same thing
msleep %>% 
  mutate(vore = as.character(vore)) %>% 
  glimpse()

# Select variables to work with (selecting columns/variables)
names(msleep) # list of variables, let's select a few of them

msleep %>% 
  select(2:4,
         awake, 
         starts_with("sleep"),
         contains("wt")) %>% 
  names()
 # takes second, third and fourth variable, then awake, then ones that start with sleep, then ones that contain wt)

# Filter and arrange data (selecting rows)
unique(msleep$order)

msleep %>% 
  filter((order == "Carnivora" |
            order == "Primates") &
           sleep_total > 8) %>% 
  select(name, order, sleep_total) %>% 
  arrange(-sleep_total) %>% 
  View()
# "|" means "or", but why or and not "and"? because basic statistics dumbass
# also -sleep_total means from highest to lowest, not the "usual" way around 

cont 14:20
