Skewness report
================

### Is skewness unique to an element of the FS?

    ## # A tibble: 12 x 5
    ##     year season treatment n_elements n_skews
    ##    <dbl> <chr>  <chr>          <int>   <int>
    ##  1  1994 summer control        10001   10001
    ##  2  1994 winter control        10001   10001
    ##  3  1996 summer control        10001   10001
    ##  4  1996 winter control           97      92
    ##  5  1999 summer control        10001   10001
    ##  6  1999 winter control        10000    9998
    ##  7  2000 summer control        10001   10001
    ##  8  2000 winter control            7       2
    ##  9  2003 summer control        10001   10001
    ## 10  2003 winter control        10001   10001
    ## 11  2009 summer control            2       1
    ## 12  2009 winter control            3       2

Skewness is not entirely unique to an element of the FS, but you don't get re-used skews until you have extremely small feasible sets.

### Distribution of skewnesses

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning in max(data$density): no non-missing arguments to max; returning -
    ## Inf

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](skewness_files/figure-markdown_github/skewness%20violins-1.png)

2009 is problematic because the communities are very small (S = 1 and 3, N = 2 and 5 respectively). Similarly, winter of 2000 had 12 individuals of 2 species. Notably, winter 1996 had 34 individuals of 3 species, and this appears to be enough to get some interesting variation going.

So far, this result contrasts with what I was finding earlier. Skewness is not always an incredible outlier. I am going to do this with the 1994 data to confirm that I haven't messed up somewhere.

If this holds (and perhaps even if it doesn't) perhaps it's worth re-investigating Legendre approximation over a broader set of datasets. It looks like the ones I pulled might have been unusual.

### Heatmaps

    ## Warning in max(filter(this_pool, skew <= observed_percentile$skew[i])
    ## $skew_rank): no non-missing arguments to max; returning -Inf

![](skewness_files/figure-markdown_github/heatmap%20of%20fs-1.png)

### Relating observed skewness to S and N

    ## $title
    ## [1] "Skewness vs S"
    ## 
    ## attr(,"class")
    ## [1] "labels"

![](skewness_files/figure-markdown_github/obs%20S%20and%20N-1.png)

### Distribution of centroid distances

    ## Warning: Removed 105 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](skewness_files/figure-markdown_github/distance%20violins-1.png)

### Heatmaps of distance to centroid

    ## Warning in max(filter(this_pool, centroid_dist <=
    ## observed_percentile$centroid_dist[i])$dist_rank): no non-missing arguments
    ## to max; returning -Inf

    ## Warning in max(filter(this_pool, centroid_dist <=
    ## observed_percentile$centroid_dist[i])$dist_rank): no non-missing arguments
    ## to max; returning -Inf

    ## Warning in max(filter(this_pool, centroid_dist <=
    ## observed_percentile$centroid_dist[i])$dist_rank): no non-missing arguments
    ## to max; returning -Inf

    ## Warning in max(filter(this_pool, centroid_dist <=
    ## observed_percentile$centroid_dist[i])$dist_rank): no non-missing arguments
    ## to max; returning -Inf

![](skewness_files/figure-markdown_github/distheatmap%20of%20fs-1.png)

### Relating observed centroid distance to S and N

    ## $title
    ## [1] "Centroid distance vs S"
    ## 
    ## attr(,"class")
    ## [1] "labels"

![](skewness_files/figure-markdown_github/distobs%20S%20and%20N-1.png)

### Skewness vs distance

![](skewness_files/figure-markdown_github/skew%20v%20dist-1.png)

### Heatmaps of coeffs

    ## Warning: Removed 2 rows containing missing values (geom_path).

    ## geom_path: Each group consists of only one observation. Do you need to
    ## adjust the group aesthetic?
    ## geom_path: Each group consists of only one observation. Do you need to
    ## adjust the group aesthetic?
    ## geom_path: Each group consists of only one observation. Do you need to
    ## adjust the group aesthetic?

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](skewness_files/figure-markdown_github/coeffs%20heatmaps-1.png)

    ## Warning: Removed 2 rows containing missing values (geom_path).

    ## geom_path: Each group consists of only one observation. Do you need to
    ## adjust the group aesthetic?
    ## geom_path: Each group consists of only one observation. Do you need to
    ## adjust the group aesthetic?
    ## geom_path: Each group consists of only one observation. Do you need to
    ## adjust the group aesthetic?

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](skewness_files/figure-markdown_github/coeffs%20heatmaps-2.png)
