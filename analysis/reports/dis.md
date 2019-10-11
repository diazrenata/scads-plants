Diversity index report
================

### Is skewness unique to an element of the FS?

    ## # A tibble: 6 x 5
    ##    year season treatment n_elements n_skews
    ##   <int> <chr>  <chr>          <int>   <int>
    ## 1  2009 summer control            4       2
    ## 2  2009 winter control            6       4
    ## 3  2013 summer control         8060    7047
    ## 4  2013 winter control        20002   19998
    ## 5  2018 summer control        20002   20001
    ## 6  2018 winter control        20002   20002

Skewness is not entirely unique to an element of the FS, but you don't get re-used skews until you have extremely small feasible sets.

### Distribution of skewnesses

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning in max(data$density): no non-missing arguments to max; returning -
    ## Inf

    ## Warning in max(data$density): no non-missing arguments to max; returning -
    ## Inf

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](dis_files/figure-markdown_github/dist%20of%20skew-1.png)

2009 is problematic because the communities are very small (S = 1 and 3, N = 2 and 5 respectively). Similarly, winter of 2000 had 12 individuals of 2 species. Notably, winter 1996 had 34 individuals of 3 species, and this appears to be enough to get some interesting variation going.

So far, this result contrasts with what I was finding earlier. Skewness is not always an incredible outlier. I am going to do this with the 1994 data to confirm that I haven't messed up somewhere.

If this holds (and perhaps even if it doesn't) perhaps it's worth re-investigating Legendre approximation over a broader set of datasets. It looks like the ones I pulled might have been unusual.

#### Shannon violins

    ## Warning in max(data$density): no non-missing arguments to max; returning -
    ## Inf

    ## Warning in max(data$density): no non-missing arguments to max; returning -
    ## Inf

![](dis_files/figure-markdown_github/shannon%20violins-1.png)

#### Simpson violins

    ## Warning in max(data$density): no non-missing arguments to max; returning -
    ## Inf

    ## Warning in max(data$density): no non-missing arguments to max; returning -
    ## Inf

![](dis_files/figure-markdown_github/simspon%20violins-1.png)

### Frequency of diversity index percentiles

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](dis_files/figure-markdown_github/skewness%20percentile%20hist-1.png)

### Sensitivity of percentile to adding singletons

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](dis_files/figure-markdown_github/singletons%201to1-1.png)
