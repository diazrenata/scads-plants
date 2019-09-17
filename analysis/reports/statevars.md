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
