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
  
statevar_plot <- ggplot(data = all_dat, aes(x = nspp, y = nind, label = year)) +
  geom_label() +
  theme_bw()

statevar_plot
```

![](statevars_files/figure-markdown_github/load%20stuff-1.png)
