Week 13 Color Palettes - looping through paletteer
================

-   [Setup and Data import](#setup-and-data-import)
    -   [libraries](#libraries)
    -   [import and look at](#import-and-look-at)
    -   [reshape](#reshape)
    -   [Bar chart with ggplot](#bar-chart-with-ggplot)
-   [Set up the graphing function](#set-up-the-graphing-function)
    -   [Pull out the data frame with package and palette names](#pull-out-the-data-frame-with-package-and-palette-names)
    -   [Make a function for plotting](#make-a-function-for-plotting)
    -   [Use purrr::map2 to loop through it](#use-purrrmap2-to-loop-through-it)

Setup and Data import
=====================

libraries
---------

``` r
# week 13

library(tidyverse)
```

    ## -- Attaching packages ------------------------------------------------ tidyverse 1.2.1 --

    ## v ggplot2 2.2.1     v purrr   0.2.5
    ## v tibble  1.4.2     v dplyr   0.7.5
    ## v tidyr   0.8.1     v stringr 1.3.1
    ## v readr   1.1.1     v forcats 0.3.0

    ## -- Conflicts --------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(skimr)
library(paletteer)
```

import and look at
------------------

``` r
dat <- read.csv("../data/week13_alcohol_global.csv")

skim(dat)
```

    ## Skim summary statistics
    ##  n obs: 193 
    ##  n variables: 5 
    ## 
    ## -- Variable type:factor -----------------------------------------------------------------
    ##  variable missing complete   n n_unique                     top_counts
    ##   country       0      193 193      193 Afg: 1, Alb: 1, Alg: 1, And: 1
    ##  ordered
    ##    FALSE
    ## 
    ## -- Variable type:integer ----------------------------------------------------------------
    ##         variable missing complete   n   mean     sd p0 p25 p50 p75 p100
    ##    beer_servings       0      193 193 106.16 101.14  0  20  76 188  376
    ##  spirit_servings       0      193 193  80.99  88.28  0   4  56 128  438
    ##    wine_servings       0      193 193  49.45  79.7   0   1   8  59  370
    ##      hist
    ##  <U+2587><U+2583><U+2582><U+2582><U+2582><U+2582><U+2581><U+2581>
    ##  <U+2587><U+2583><U+2582><U+2582><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ## 
    ## -- Variable type:numeric ----------------------------------------------------------------
    ##                      variable missing complete   n mean   sd p0 p25 p50
    ##  total_litres_of_pure_alcohol       0      193 193 4.72 3.77  0 1.3 4.2
    ##  p75 p100     hist
    ##  7.2 14.4 <U+2587><U+2583><U+2583><U+2585><U+2582><U+2582><U+2582><U+2581>

``` r
head(dat)
```

    ##             country beer_servings spirit_servings wine_servings
    ## 1       Afghanistan             0               0             0
    ## 2           Albania            89             132            54
    ## 3           Algeria            25               0            14
    ## 4           Andorra           245             138           312
    ## 5            Angola           217              57            45
    ## 6 Antigua & Barbuda           102             128            45
    ##   total_litres_of_pure_alcohol
    ## 1                          0.0
    ## 2                          4.9
    ## 3                          0.7
    ## 4                         12.4
    ## 5                          5.9
    ## 6                          4.9

reshape
-------

Only select top 4 countries for easier-to-see plots

``` r
# reshape so I can group and make faceted plots
# top_n to pull out 40 countries with highest consumption
# make country a factor
# gather() to put it in long format
dat2 <- dat %>%
    rename(beer = beer_servings,
           wine = wine_servings,
           spirits = spirit_servings) %>%
    top_n(4, total_litres_of_pure_alcohol) %>%  
    mutate(country = as.factor(country)) %>%  
    gather(key = "alc_type", value = "value", 
           -country, -total_litres_of_pure_alcohol) 
```

Bar chart with ggplot
---------------------

``` r
# exploratory bar chart
p <- ggplot(dat2, aes(x = alc_type, y = value, fill = alc_type)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~country, ncol = 2) +
    theme_bw() +
    labs(x = "alcohol type", 
         y = "# servings")
```

``` r
print(p)
```

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-5-1.png)

Set up the graphing function
============================

Pull out the data frame with package and palette names
------------------------------------------------------

``` r
palettes <- palettes_d_names
```

Make a function for plotting
----------------------------

``` r
plot_fun <- function(base_plot, col_pkg, col_pal) {
    Title <- paste(col_pkg, col_pal)
    out <- base_plot +
        scale_fill_paletteer_d(!!ensym(col_pkg), !!ensym(col_pal)) +
        ggtitle(Title)
    return(out)
}
```

Use purrr::map2 to loop through it
----------------------------------

``` r
# p is my base plot from up above
map2(palettes$package, palettes$palette, ~ plot_fun(p, .x, .y))
```

    ## [[1]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-1.png)

    ## 
    ## [[2]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-2.png)

    ## 
    ## [[3]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-3.png)

    ## 
    ## [[4]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-4.png)

    ## 
    ## [[5]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-5.png)

    ## 
    ## [[6]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-6.png)

    ## 
    ## [[7]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-7.png)

    ## 
    ## [[8]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-8.png)

    ## 
    ## [[9]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-9.png)

    ## 
    ## [[10]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-10.png)

    ## 
    ## [[11]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-11.png)

    ## 
    ## [[12]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-12.png)

    ## 
    ## [[13]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-13.png)

    ## 
    ## [[14]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-14.png)

    ## 
    ## [[15]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-15.png)

    ## 
    ## [[16]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-16.png)

    ## 
    ## [[17]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-17.png)

    ## 
    ## [[18]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-18.png)

    ## 
    ## [[19]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-19.png)

    ## 
    ## [[20]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-20.png)

    ## 
    ## [[21]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-21.png)

    ## 
    ## [[22]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-22.png)

    ## 
    ## [[23]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-23.png)

    ## 
    ## [[24]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-24.png)

    ## 
    ## [[25]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-25.png)

    ## 
    ## [[26]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-26.png)

    ## 
    ## [[27]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-27.png)

    ## 
    ## [[28]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-28.png)

    ## 
    ## [[29]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-29.png)

    ## 
    ## [[30]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-30.png)

    ## 
    ## [[31]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-31.png)

    ## 
    ## [[32]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-32.png)

    ## 
    ## [[33]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-33.png)

    ## 
    ## [[34]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-34.png)

    ## 
    ## [[35]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-35.png)

    ## 
    ## [[36]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-36.png)

    ## 
    ## [[37]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-37.png)

    ## 
    ## [[38]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-38.png)

    ## 
    ## [[39]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-39.png)

    ## 
    ## [[40]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-40.png)

    ## 
    ## [[41]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-41.png)

    ## 
    ## [[42]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-42.png)

    ## 
    ## [[43]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-43.png)

    ## 
    ## [[44]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-44.png)

    ## 
    ## [[45]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-45.png)

    ## 
    ## [[46]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-46.png)

    ## 
    ## [[47]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-47.png)

    ## 
    ## [[48]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-48.png)

    ## 
    ## [[49]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-49.png)

    ## 
    ## [[50]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-50.png)

    ## 
    ## [[51]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-51.png)

    ## 
    ## [[52]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-52.png)

    ## 
    ## [[53]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-53.png)

    ## 
    ## [[54]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-54.png)

    ## 
    ## [[55]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-55.png)

    ## 
    ## [[56]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-56.png)

    ## 
    ## [[57]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-57.png)

    ## 
    ## [[58]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-58.png)

    ## 
    ## [[59]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-59.png)

    ## 
    ## [[60]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-60.png)

    ## 
    ## [[61]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-61.png)

    ## 
    ## [[62]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-62.png)

    ## 
    ## [[63]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-63.png)

    ## 
    ## [[64]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-64.png)

    ## 
    ## [[65]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-65.png)

    ## 
    ## [[66]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-66.png)

    ## 
    ## [[67]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-67.png)

    ## 
    ## [[68]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-68.png)

    ## 
    ## [[69]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-69.png)

    ## 
    ## [[70]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-70.png)

    ## 
    ## [[71]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-71.png)

    ## 
    ## [[72]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-72.png)

    ## 
    ## [[73]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-73.png)

    ## 
    ## [[74]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-74.png)

    ## 
    ## [[75]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-75.png)

    ## 
    ## [[76]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-76.png)

    ## 
    ## [[77]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-77.png)

    ## 
    ## [[78]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-78.png)

    ## 
    ## [[79]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-79.png)

    ## 
    ## [[80]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-80.png)

    ## 
    ## [[81]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-81.png)

    ## 
    ## [[82]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-82.png)

    ## 
    ## [[83]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-83.png)

    ## 
    ## [[84]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-84.png)

    ## 
    ## [[85]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-85.png)

    ## 
    ## [[86]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-86.png)

    ## 
    ## [[87]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-87.png)

    ## 
    ## [[88]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-88.png)

    ## 
    ## [[89]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-89.png)

    ## 
    ## [[90]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-90.png)

    ## 
    ## [[91]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-91.png)

    ## 
    ## [[92]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-92.png)

    ## 
    ## [[93]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-93.png)

    ## 
    ## [[94]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-94.png)

    ## 
    ## [[95]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-95.png)

    ## 
    ## [[96]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-96.png)

    ## 
    ## [[97]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-97.png)

    ## 
    ## [[98]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-98.png)

    ## 
    ## [[99]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-99.png)

    ## 
    ## [[100]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-100.png)

    ## 
    ## [[101]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-101.png)

    ## 
    ## [[102]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-102.png)

    ## 
    ## [[103]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-103.png)

    ## 
    ## [[104]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-104.png)

    ## 
    ## [[105]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-105.png)

    ## 
    ## [[106]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-106.png)

    ## 
    ## [[107]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-107.png)

    ## 
    ## [[108]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-108.png)

    ## 
    ## [[109]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-109.png)

    ## 
    ## [[110]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-110.png)

    ## 
    ## [[111]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-111.png)

    ## 
    ## [[112]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-112.png)

    ## 
    ## [[113]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-113.png)

    ## 
    ## [[114]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-114.png)

    ## 
    ## [[115]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-115.png)

    ## 
    ## [[116]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-116.png)

    ## 
    ## [[117]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-117.png)

    ## 
    ## [[118]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-118.png)

    ## 
    ## [[119]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-119.png)

    ## 
    ## [[120]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-120.png)

    ## 
    ## [[121]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-121.png)

    ## 
    ## [[122]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-122.png)

    ## 
    ## [[123]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-123.png)

    ## 
    ## [[124]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-124.png)

    ## 
    ## [[125]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-125.png)

    ## 
    ## [[126]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-126.png)

    ## 
    ## [[127]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-127.png)

    ## 
    ## [[128]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-128.png)

    ## 
    ## [[129]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-129.png)

    ## 
    ## [[130]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-130.png)

    ## 
    ## [[131]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-131.png)

    ## 
    ## [[132]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-132.png)

    ## 
    ## [[133]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-133.png)

    ## 
    ## [[134]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-134.png)

    ## 
    ## [[135]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-135.png)

    ## 
    ## [[136]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-136.png)

    ## 
    ## [[137]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-137.png)

    ## 
    ## [[138]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-138.png)

    ## 
    ## [[139]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-139.png)

    ## 
    ## [[140]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-140.png)

    ## 
    ## [[141]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-141.png)

    ## 
    ## [[142]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-142.png)

    ## 
    ## [[143]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-143.png)

    ## 
    ## [[144]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-144.png)

    ## 
    ## [[145]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-145.png)

    ## 
    ## [[146]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-146.png)

    ## 
    ## [[147]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-147.png)

    ## 
    ## [[148]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-148.png)

    ## 
    ## [[149]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-149.png)

    ## 
    ## [[150]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-150.png)

    ## 
    ## [[151]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-151.png)

    ## 
    ## [[152]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-152.png)

    ## 
    ## [[153]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-153.png)

    ## 
    ## [[154]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-154.png)

    ## 
    ## [[155]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-155.png)

    ## 
    ## [[156]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-156.png)

    ## 
    ## [[157]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-157.png)

    ## 
    ## [[158]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-158.png)

    ## 
    ## [[159]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-159.png)

    ## 
    ## [[160]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-160.png)

    ## 
    ## [[161]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-161.png)

    ## 
    ## [[162]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-162.png)

    ## 
    ## [[163]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-163.png)

    ## 
    ## [[164]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-164.png)

    ## 
    ## [[165]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-165.png)

    ## 
    ## [[166]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-166.png)

    ## 
    ## [[167]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-167.png)

    ## 
    ## [[168]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-168.png)

    ## 
    ## [[169]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-169.png)

    ## 
    ## [[170]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-170.png)

    ## 
    ## [[171]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-171.png)

    ## 
    ## [[172]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-172.png)

    ## 
    ## [[173]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-173.png)

    ## 
    ## [[174]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-174.png)

    ## 
    ## [[175]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-175.png)

    ## 
    ## [[176]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-176.png)

    ## 
    ## [[177]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-177.png)

    ## 
    ## [[178]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-178.png)

    ## 
    ## [[179]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-179.png)

    ## 
    ## [[180]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-180.png)

    ## 
    ## [[181]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-181.png)

    ## 
    ## [[182]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-182.png)

    ## 
    ## [[183]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-183.png)

    ## 
    ## [[184]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-184.png)

    ## 
    ## [[185]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-185.png)

    ## 
    ## [[186]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-186.png)

    ## 
    ## [[187]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-187.png)

    ## 
    ## [[188]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-188.png)

    ## 
    ## [[189]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-189.png)

    ## 
    ## [[190]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-190.png)

    ## 
    ## [[191]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-191.png)

    ## 
    ## [[192]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-192.png)

    ## 
    ## [[193]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-193.png)

    ## 
    ## [[194]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-194.png)

    ## 
    ## [[195]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-195.png)

    ## 
    ## [[196]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-196.png)

    ## 
    ## [[197]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-197.png)

    ## 
    ## [[198]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-198.png)

    ## 
    ## [[199]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-199.png)

    ## 
    ## [[200]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-200.png)

    ## 
    ## [[201]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-201.png)

    ## 
    ## [[202]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-202.png)

    ## 
    ## [[203]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-203.png)

    ## 
    ## [[204]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-204.png)

    ## 
    ## [[205]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-205.png)

    ## 
    ## [[206]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-206.png)

    ## 
    ## [[207]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-207.png)

    ## 
    ## [[208]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-208.png)

    ## 
    ## [[209]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-209.png)

    ## 
    ## [[210]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-210.png)

    ## 
    ## [[211]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-211.png)

    ## 
    ## [[212]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-212.png)

    ## 
    ## [[213]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-213.png)

    ## 
    ## [[214]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-214.png)

    ## 
    ## [[215]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-215.png)

    ## 
    ## [[216]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-216.png)

    ## 
    ## [[217]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-217.png)

    ## 
    ## [[218]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-218.png)

    ## 
    ## [[219]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-219.png)

    ## 
    ## [[220]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-220.png)

    ## 
    ## [[221]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-221.png)

    ## 
    ## [[222]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-222.png)

    ## 
    ## [[223]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-223.png)

    ## 
    ## [[224]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-224.png)

    ## 
    ## [[225]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-225.png)

    ## 
    ## [[226]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-226.png)

    ## 
    ## [[227]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-227.png)

    ## 
    ## [[228]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-228.png)

    ## 
    ## [[229]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-229.png)

    ## 
    ## [[230]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-230.png)

    ## 
    ## [[231]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-231.png)

    ## 
    ## [[232]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-232.png)

    ## 
    ## [[233]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-233.png)

    ## 
    ## [[234]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-234.png)

    ## 
    ## [[235]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-235.png)

    ## 
    ## [[236]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-236.png)

    ## 
    ## [[237]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-237.png)

    ## 
    ## [[238]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-238.png)

    ## 
    ## [[239]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-239.png)

    ## 
    ## [[240]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-240.png)

    ## 
    ## [[241]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-241.png)

    ## 
    ## [[242]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-242.png)

    ## 
    ## [[243]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-243.png)

    ## 
    ## [[244]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-244.png)

    ## 
    ## [[245]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-245.png)

    ## 
    ## [[246]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-246.png)

    ## 
    ## [[247]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-247.png)

    ## 
    ## [[248]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-248.png)

    ## 
    ## [[249]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-249.png)

    ## 
    ## [[250]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-250.png)

    ## 
    ## [[251]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-251.png)

    ## 
    ## [[252]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-252.png)

    ## 
    ## [[253]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-253.png)

    ## 
    ## [[254]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-254.png)

    ## 
    ## [[255]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-255.png)

    ## 
    ## [[256]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-256.png)

    ## 
    ## [[257]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-257.png)

    ## 
    ## [[258]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-258.png)

    ## 
    ## [[259]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-259.png)

    ## 
    ## [[260]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-260.png)

    ## 
    ## [[261]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-261.png)

    ## 
    ## [[262]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-262.png)

    ## 
    ## [[263]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-263.png)

    ## 
    ## [[264]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-264.png)

    ## 
    ## [[265]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-265.png)

    ## 
    ## [[266]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-266.png)

    ## 
    ## [[267]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-267.png)

    ## 
    ## [[268]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-268.png)

    ## 
    ## [[269]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-269.png)

    ## 
    ## [[270]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-270.png)

    ## 
    ## [[271]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-271.png)

    ## 
    ## [[272]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-272.png)

    ## 
    ## [[273]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-273.png)

    ## 
    ## [[274]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-274.png)

    ## 
    ## [[275]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-275.png)

    ## 
    ## [[276]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-276.png)

    ## 
    ## [[277]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-277.png)

    ## 
    ## [[278]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-278.png)

    ## 
    ## [[279]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-279.png)

    ## 
    ## [[280]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-280.png)

    ## 
    ## [[281]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-281.png)

    ## 
    ## [[282]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-282.png)

    ## 
    ## [[283]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-283.png)

    ## 
    ## [[284]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-284.png)

    ## 
    ## [[285]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-285.png)

    ## 
    ## [[286]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-286.png)

    ## 
    ## [[287]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-287.png)

    ## 
    ## [[288]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-288.png)

    ## 
    ## [[289]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-289.png)

    ## 
    ## [[290]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-290.png)

    ## 
    ## [[291]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-291.png)

    ## 
    ## [[292]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-292.png)

    ## 
    ## [[293]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-293.png)

    ## 
    ## [[294]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-294.png)

    ## 
    ## [[295]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-295.png)

    ## 
    ## [[296]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-296.png)

    ## 
    ## [[297]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-297.png)

    ## 
    ## [[298]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-298.png)

    ## 
    ## [[299]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-299.png)

    ## 
    ## [[300]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-300.png)

    ## 
    ## [[301]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-301.png)

    ## 
    ## [[302]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-302.png)

    ## 
    ## [[303]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-303.png)

    ## 
    ## [[304]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-304.png)

    ## 
    ## [[305]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-305.png)

    ## 
    ## [[306]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-306.png)

    ## 
    ## [[307]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-307.png)

    ## 
    ## [[308]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-308.png)

    ## 
    ## [[309]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-309.png)

    ## 
    ## [[310]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-310.png)

    ## 
    ## [[311]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-311.png)

    ## 
    ## [[312]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-312.png)

    ## 
    ## [[313]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-313.png)

    ## 
    ## [[314]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-314.png)

    ## 
    ## [[315]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-315.png)

    ## 
    ## [[316]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-316.png)

    ## 
    ## [[317]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-317.png)

    ## 
    ## [[318]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-318.png)

    ## 
    ## [[319]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-319.png)

    ## 
    ## [[320]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-320.png)

    ## 
    ## [[321]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-321.png)

    ## 
    ## [[322]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-322.png)

    ## 
    ## [[323]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-323.png)

    ## 
    ## [[324]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-324.png)

    ## 
    ## [[325]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-325.png)

    ## 
    ## [[326]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-326.png)

    ## 
    ## [[327]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-327.png)

    ## 
    ## [[328]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-328.png)

    ## 
    ## [[329]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-329.png)

    ## 
    ## [[330]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-330.png)

    ## 
    ## [[331]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-331.png)

    ## 
    ## [[332]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-332.png)

    ## 
    ## [[333]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-333.png)

    ## 
    ## [[334]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-334.png)

    ## 
    ## [[335]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-335.png)

    ## 
    ## [[336]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-336.png)

    ## 
    ## [[337]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-337.png)

    ## 
    ## [[338]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-338.png)

    ## 
    ## [[339]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-339.png)

    ## 
    ## [[340]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-340.png)

    ## 
    ## [[341]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-341.png)

    ## 
    ## [[342]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-342.png)

    ## 
    ## [[343]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-343.png)

    ## 
    ## [[344]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-344.png)

    ## 
    ## [[345]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-345.png)

    ## 
    ## [[346]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-346.png)

    ## 
    ## [[347]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-347.png)

    ## 
    ## [[348]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-348.png)

    ## 
    ## [[349]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-349.png)

    ## 
    ## [[350]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-350.png)

    ## 
    ## [[351]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-351.png)

    ## 
    ## [[352]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-352.png)

    ## 
    ## [[353]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-353.png)

    ## 
    ## [[354]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-354.png)

    ## 
    ## [[355]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-355.png)

    ## 
    ## [[356]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-356.png)

    ## 
    ## [[357]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-357.png)

    ## 
    ## [[358]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-358.png)

    ## 
    ## [[359]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-359.png)

    ## 
    ## [[360]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-360.png)

    ## 
    ## [[361]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-361.png)

    ## 
    ## [[362]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-362.png)

    ## 
    ## [[363]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-363.png)

    ## 
    ## [[364]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-364.png)

    ## 
    ## [[365]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-365.png)

    ## 
    ## [[366]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-366.png)

    ## 
    ## [[367]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-367.png)

    ## 
    ## [[368]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-368.png)

    ## 
    ## [[369]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-369.png)

    ## 
    ## [[370]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-370.png)

    ## 
    ## [[371]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-371.png)

    ## 
    ## [[372]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-372.png)

    ## 
    ## [[373]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-373.png)

    ## 
    ## [[374]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-374.png)

    ## 
    ## [[375]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-375.png)

    ## 
    ## [[376]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-376.png)

    ## 
    ## [[377]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-377.png)

    ## 
    ## [[378]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-378.png)

    ## 
    ## [[379]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-379.png)

    ## 
    ## [[380]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-380.png)

    ## 
    ## [[381]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-381.png)

    ## 
    ## [[382]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-382.png)

    ## 
    ## [[383]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-383.png)

    ## 
    ## [[384]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-384.png)

    ## 
    ## [[385]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-385.png)

    ## 
    ## [[386]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-386.png)

    ## 
    ## [[387]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-387.png)

    ## 
    ## [[388]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-388.png)

    ## 
    ## [[389]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-389.png)

    ## 
    ## [[390]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-390.png)

    ## 
    ## [[391]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-391.png)

    ## 
    ## [[392]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-392.png)

    ## 
    ## [[393]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-393.png)

    ## 
    ## [[394]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-394.png)

    ## 
    ## [[395]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-395.png)

    ## 
    ## [[396]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-396.png)

    ## 
    ## [[397]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-397.png)

    ## 
    ## [[398]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-398.png)

    ## 
    ## [[399]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-399.png)

    ## 
    ## [[400]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-400.png)

    ## 
    ## [[401]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-401.png)

    ## 
    ## [[402]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-402.png)

    ## 
    ## [[403]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-403.png)

    ## 
    ## [[404]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-404.png)

    ## 
    ## [[405]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-405.png)

    ## 
    ## [[406]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-406.png)

    ## 
    ## [[407]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-407.png)

    ## 
    ## [[408]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-408.png)

    ## 
    ## [[409]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-409.png)

    ## 
    ## [[410]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-410.png)

    ## 
    ## [[411]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-411.png)

    ## 
    ## [[412]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-412.png)

    ## 
    ## [[413]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-413.png)

    ## 
    ## [[414]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-414.png)

    ## 
    ## [[415]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-415.png)

    ## 
    ## [[416]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-416.png)

    ## 
    ## [[417]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-417.png)

    ## 
    ## [[418]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-418.png)

    ## 
    ## [[419]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-419.png)

    ## 
    ## [[420]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-420.png)

    ## 
    ## [[421]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-421.png)

    ## 
    ## [[422]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-422.png)

    ## 
    ## [[423]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-423.png)

    ## 
    ## [[424]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-424.png)

    ## 
    ## [[425]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-425.png)

    ## 
    ## [[426]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-426.png)

    ## 
    ## [[427]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-427.png)

    ## 
    ## [[428]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-428.png)

    ## 
    ## [[429]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-429.png)

    ## 
    ## [[430]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-430.png)

    ## 
    ## [[431]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-431.png)

    ## 
    ## [[432]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-432.png)

    ## 
    ## [[433]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-433.png)

    ## 
    ## [[434]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-434.png)

    ## 
    ## [[435]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-435.png)

    ## 
    ## [[436]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-436.png)

    ## 
    ## [[437]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-437.png)

    ## 
    ## [[438]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-438.png)

    ## 
    ## [[439]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-439.png)

    ## 
    ## [[440]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-440.png)

    ## 
    ## [[441]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-441.png)

    ## 
    ## [[442]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-442.png)

    ## 
    ## [[443]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-443.png)

    ## 
    ## [[444]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-444.png)

    ## 
    ## [[445]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-445.png)

    ## 
    ## [[446]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-446.png)

    ## 
    ## [[447]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-447.png)

    ## 
    ## [[448]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-448.png)

    ## 
    ## [[449]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-449.png)

    ## 
    ## [[450]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-450.png)

    ## 
    ## [[451]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-451.png)

    ## 
    ## [[452]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-452.png)

    ## 
    ## [[453]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-453.png)

    ## 
    ## [[454]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-454.png)

    ## 
    ## [[455]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-455.png)

    ## 
    ## [[456]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-456.png)

    ## 
    ## [[457]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-457.png)

    ## 
    ## [[458]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-458.png)

    ## 
    ## [[459]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-459.png)

    ## 
    ## [[460]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-460.png)

    ## 
    ## [[461]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-461.png)

    ## 
    ## [[462]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-462.png)

    ## 
    ## [[463]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-463.png)

    ## 
    ## [[464]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-464.png)

    ## 
    ## [[465]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-465.png)

    ## 
    ## [[466]]

![](week13_loopingcolors_files/figure-markdown_github/unnamed-chunk-8-466.png)
