#===============================================================================================================================================================================================================
# Absolute basics
install.packages()
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
# alternative way of doing the same thing
msleep %>% 
  filter(order %in% c("Carnivora", "Primates") &
           sleep_total > 8) %>%
  select(name, order, sleep_total) %>% 
  arrange(order) %>% 
  View()
# If arranged by order (non numerical value) it'll be sorted alphabetically

# Change observations (mutate)
msleep %>% 
  mutate(brainwt = brainwt * 1000) %>% 
  View()
# by multiplying the weight by 1000 we're mutating the weight from kg to g
msleep %>% 
  mutate(brainwt_in_grams = brainwt * 1000) %>% 
  View()
# keep original variable and instead creates a new one

# Conditional changes (if_else)
## logical vector based on a condition
msleep$brainwt
msleep$brainwt > 0.01

size_of_brain <- msleep %>% 
  select(name, brainwt) %>% 
  drop_na(brainwt) %>% 
  mutate(brain_size = if_else(brainwt > 0.01,
                              "large",
                              "small"))
size_of_brain

# Recode data and rename variable
## Change observations of "large" and "small into 1s and 2s
size_of_brain %>% 
  mutate(brain_size = recode(brain_size,
                             "large" = 1,
                             "small" = 2))

# Reshape the data from wide to long or long to wide
library(gapminder)
View(gapminder)

data <- select(gapminder, country, year, lifeExp)
View(data) # long dataset, you'll know once you see it, it's long

wide_data <- data %>%
  pivot_wider(names_from = year, values_from = lifeExp)
View(wide_data) # wide, looking muuuch better

long_data <- wide_data %>%
  pivot_longer(2:13,
               names_to = "year",
               values_to = "lifeExp")
# first which columns do you want to work with (skip first column - names),
## then create a new variable 
View(long_data)
# we're now back to what we used to have, just 3 columns, name, year, lifeExp

#===============================================================================================================================================================================================================
# Describe and Summarise
library(tidyverse)
View(msleep)
# Describe the spread, centrality and variance
min(msleep$awake)
max(msleep$awake)
range(msleep$awake)
IQR(msleep$awake)
mean(msleep$awake)
median(msleep$awake)
var(msleep$awake)

# Summary of a variable
summary(msleep$awake)
# Summary of multiple variables
msleep %>%
  select(sleep_total, brainwt) %>%
  summary()

# Task
## Create a summary table
## For each category of "vore
## Show the min, max, difference
## And average "sleep_total"
## Arrange data by the average
msleep %>%
  drop_na(vore) %>%
  group_by(vore) %>%
  summarise(Lower = min(sleep_total),
            Average = mean(sleep_total),
            Upper = max(sleep_total),
            Difference =
              max(sleep_total)-min(sleep_total)) %>%
  arrange(Average) %>%
  View()

# Creating contingency tables
library(MASS)
attach(Cars93)
glimpse(Cars93)

table(Origin)
table(AirBags, Origin)
addmargins(table(AirBags, Origin), 1)
# 1 means 1 extra row, 2 = extra column, 0 = both

table((AirBags, Origin))
prop.table(table(AirBags, Origin))*100
# prop.table(table(AirBags, Origin),2)*100
## the 2 means that each column adds up to 100%, if left blank then both columns together = 100%
round(prop.table(table(AirBags, Origin),2)*100)
# rounded to the nearest whole number

# Now, instead of doing addmargins, we can use tidyverse
Cars93 %>%
  group_by(Origin, AirBags) %>%
  summarise(number = n()) %>%
  pivot_wider(names_from = Origin,
              values_from = number)
  # like the previous table but the way we got there is different than addmargin

#===============================================================================================================================================================================================================
# Data Visualisation

# gg stands for grammar of graphics
# grammar being: data, aesthetics, geometry 

# Data - this is what our plots will visualise
# Aesthetics - X & Y axes, point colour etc
# Geometry - scatterbox, barplot, lineplot, histogram etc

# Basic Anatomy of a ggplot code
ggplot(data=your_data, aes(x=var1, y=var2)) +
  geom_point(aes(color=var3, fill))


# Example
library(tidyverse)
library(gapminder)

View(gapminder)

gapminder %>%
  filter(continent %in% c("Africa", "Europe")) %>%
  filter(gdpPercap < 30000) %>%
  ggplot(aes(x = gdpPercap,
             y = lifeExp,
             size = pop,
             color = year)) +
  geom_point() +
  facet_wrap(~continent)+
  labs(title = "Life expectancty explained by GDP",
       x = "GDP Per capita",
       y = "Life Expectancy")



# If we were to use ggplot on its own (here it's part of the tidyverse library),
## then in line 369 we'd need our first argument to be:
# ggplot(data = gapminder,
#        aes(x = gdpPercap)) etc



# ==========
# More examples in Cheat Sheets/Visualisation/Data Visualisation
# ==========

#===============================================================================================================================================================================================================
# Analysis
library(tidyverse)
library(patchwork)
library(gapminder)

View(gapminder)

########## Single sample t-test ##########
# H0: mean life expectancy is 50 years
# H1: mean life expectancy is not 50 years

# Observation: Sample data provides a mean life expectancy of 48.9.
# Is this statististically significant?

gapminder %>%
  filter(continent == "Africa") %>%
  select(lifeExp) %>%
  t.test(mu = 50)
# Of all the observations, we only want observations where continent is Africa
# mu being population mean
# Result = p-value, probability that we would get the same result under the assumption that null is true

my_ttest <- gapminder %>%
  filter(continent == "Africa") %>%
  select(lifeExp) %>%
  t.test(mu = 50)
# same code but assigning the results to a variable, now we can search for specific things
attributes(my_ttest)
# names of all callable functions
my_ttest$p.value

########## two sided t-test for difference of means ##########
gapminder %>%
  filter(continent %in% c("Africa", "Europe")) %>%
  t.test(lifeExp ~ continent, data = .,
         alternative = "two.sided")
# data - . is where you want to pipe that data into

########## one sided t-test for difference of means ##########
gapminder %>%
  filter(country %in% c("Ireland", "Switzerland")) %>%
  t.test(lifeExp ~ country, data = .,
         alternative = "less",
         conf.level = 0.95)
# alternative "less" is what makes this code a one sided t-test
# null mean lifeExp in Ireland is greater or equal to the mean lifeExp in Switzerland
# alt mean lifeExp is LESS THAN the mean lifeExp in Switzerland
# if we didn't put conf.level it would default to 0.95 anyway
# P HACKING reducing sig level to 90% because our results are 0.05835 and we want them to be significant - BAD SCIENCE

########## paired t-test ##########
gapminder %>%
  filter(year %in% c(1957, 2007)&
           continent == "Africa") %>%
  mutate(year = factor(year, levels = c(2007, 1957))) %>%
  t.test(lifeExp ~ year, data = .,
         paired = TRUE)
# code won't work, but this is basically how to do a paired test

### ASSUMPTIONS OF T-TEST ###
# 1) Large, representative sample
# 2) Values are normally distributed 
# 3) Two samples have similar variance
var(gapminder$lifeExp[gapminder$country=="Ireland"])
var(gapminder$lifeExp[gapminder$country=="Switzerland"])
# variance 13 and 16, so not that bad 

#===============================================================================================================================================================================================================
# Probability

########## Binomial Distribution ##########
# To find exactly one outcome use the dbinom function
# P(X = 3)
dbinom(x = 3, size = 20, prob = 1/6)
# 0.2378866 

# To find cumulative probability use pbinom
# P(X < 20)
pbinom(19, size = 50, prob = 0.6)
# 19 because in binomial P(X < 20) = P(X ≤ 19)

# To calculate >, you need to reorganise your formula
# P(X > 20) = 1 - P(X ≤ 20)
1 - pbinom(20, size = 50, prob = 0.6)
# note q = 20 not 19

########## Normal Distribution ##########
rnorm(5, mean = 0, sd = 1)
# rnorm(n, mean = x, sd = y) = generates n random values from the normal distribution with mean x and standard deviation y

pnorm(5, mean = 3, sd = 2)
# pnorm is the cumulative distribution function of the normal distribution
# 5 meaning P(X≤5), so to get P(X≥5) you'd do 1-P(X<5)
# remember P(X<x) = 1-P(X≥x) & P(X≤x) = 1-P(X>x)

qnorm(p, mean, sd) # inverse cdf of the normal distribution, returns the value x such that pnorm(x, mean, sd) = p

# Example: Flipper lengths of a certain kind of penguin are normally distributed with mean 192.9mm and standard deviation 7.1mm
# 1) What is the probability that a randomly-selected penguin has a flipper less than 200mm long? More than 200mm?
# 2) What is the 90th percentile for flippers length in these penguins?
# 3) Simulate 500 random selections from this population and plot the results

## ANSWERS
# 1) P(X<200mm) = pnorm(200, 192.9, 7.1) = 0.8413447 AND P(X>200mm) = 1 - pnorm(200, 192.9, 7.1) = 0.1586553
# 2) qnorm(.90, 192.9, 7.1) = 201.999
# 3) flippers <- rnorm(500, 192.9, 7.1) ==> library(ggplot2)/ or tidyverse ==> qplot(flippers, col = I("black"))
