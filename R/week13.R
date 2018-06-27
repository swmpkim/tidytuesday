# week 13

library(tidyverse)
library(skimr)

dat <- read.csv("data/week13_alcohol_global.csv")

skim(dat)
head(dat)

# reshape for faceted plotting, because i'm lazy and want to make just one plot

dat2 <- dat %>%
    rename(beer = beer_servings,
           wine = wine_servings,
           spirits = spirit_servings) %>%
    top_n(40, total_litres_of_pure_alcohol) %>%
    mutate(country = as.factor(country)) %>%
    gather(key = "alc_type", value = "value", 
           -country, -total_litres_of_pure_alcohol) 
head(dat2)


plot(dat)

ggplot(dat2, aes(x = alc_type, y = value, fill = alc_type)) +
    geom_col() +
    facet_wrap(~country, ncol = 5) +
    scale_fill_brewer(type = "qual", palette = "Paired") +
    theme_bw()

# hm, how many countries have beer as top? spirits? wine?
# order within each country, and rank?
# not sure what to plot from this.... 

# thanks, stackoverflow, for dense_rank
# https://stackoverflow.com/questions/26106408/create-a-ranking-variable-with-dplyr

dat3 <- dat %>%
    rename(beer = beer_servings,
           wine = wine_servings,
           spirits = spirit_servings) %>%
    gather(key = "alc_type", value = "value", 
           -country, -total_litres_of_pure_alcohol) %>%
    group_by(country) %>%
    mutate(alc_rank = dense_rank(desc(value))) %>%
    arrange(country, alc_rank)

rank_summary <- dat3 %>%
    ungroup() %>%
    summarize()
