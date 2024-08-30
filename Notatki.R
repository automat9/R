x <- 5 # this is how you assign numbers to variables
power_rangers_seasons <- read_csv("C:/Users/10/Desktop/power_rangers_seasons.csv") # example of how to assign a dataset to a variable
View(power_rangers_seasons) # view your dataset, CASE SENSITIVE
mean(power_rangers_seasons$season_num) # Matt, you'll never believe what this does
filtered_data <-filter(power_rangers_seasons, number_of_episodes > 40) # find all seasons that have > 40 episodes (RUN IN SCRIPT EDITOR - CLICK 'SOURCE THE CONTENTS OF THE ACTIVE DOCUMENT')
# a simple boxplot
ggplot(power_rangers_seasons, aes(x = season_num, y = number_of_episodes)) +
  geom_col()

# a not so simple boxplot
ggplot(power_rangers_seasons, aes(x = season_num, y = number_of_episodes)) +
  geom_col() +
  geom_line(size = 2, color = "red") +
  scale_x_continuous(breaks = 1:28) +
  labs(x = 'Season Number', y = 'Number of Episodes')
