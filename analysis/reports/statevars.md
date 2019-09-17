State vars report
================

``` r
loadd(all_dat, cache = cache)

all_dat <- bind_rows(all_dat)

all_dat <- all_dat %>%
  group_by(year, season, treatment) %>%
  summarize(nspp = max(rank),
            nind = sum(abund)) %>%
  ungroup()
  
statevar_plot <- ggplot(data = all_dat, aes(x = nspp, y = nind, label = year, color = season)) +
  geom_label() +
  theme_bw() +
  scale_color_viridis_d(end = .6)

statevar_plot
```

![](statevars_files/figure-markdown_github/load%20stuff-1.png)

``` r
small_years <- all_dat %>%
  filter(nspp <= 25,
         nind <= 10000) %>%
  group_by(year) %>%
  summarize(nb_seasons = n()) %>%
  ungroup() %>%
  filter(nb_seasons == 2)

small_years_dat <- all_dat %>%
  filter(year %in% small_years$year)

small_statevar_plot <- ggplot(data = small_years_dat, aes(x = nspp, y = nind, label = year, color = season)) +
  geom_label() +
  theme_bw() +
  scale_color_viridis_d(end = .6)

small_statevar_plot
```

![](statevars_files/figure-markdown_github/get%20smaller%20years-1.png)

``` r
small_years_dat
```

    ## # A tibble: 10 x 5
    ##     year season treatment  nspp  nind
    ##    <dbl> <chr>  <chr>     <int> <int>
    ##  1  1996 summer control      18  1348
    ##  2  1996 winter control       3    34
    ##  3  1999 summer control      23  1084
    ##  4  1999 winter control       7   215
    ##  5  2000 summer control      13  1051
    ##  6  2000 winter control       2    12
    ##  7  2003 summer control       4  3995
    ##  8  2003 winter control      17  4675
    ##  9  2009 summer control       1     2
    ## 10  2009 winter control       3     5

\`\`\`
