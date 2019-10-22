Diversity index report
================

### Distribution of skewnesses

    ## Warning: Removed 3 rows containing non-finite values (stat_ydensity).

    ## Warning in max(data$density): no non-missing arguments to max; returning -
    ## Inf

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](dis_files/figure-markdown_github/dist%20of%20skew-1.png)

2009 is problematic because the communities are very small (S = 1 and 3, N = 2 and 5 respectively). Similarly, winter of 2000 had 12 individuals of 2 species. Notably, winter 1996 had 34 individuals of 3 species, and this appears to be enough to get some interesting variation going.

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

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](dis_files/figure-markdown_github/skewness%20percentile%20hist-1.png)

Simpson's vs. skewness percentile values
----------------------------------------

    ## Warning: Removed 3 rows containing missing values (geom_point).

![](dis_files/figure-markdown_github/do%20simpson%20and%20skewness%20give%20the%20same%20answers-1.png)

#### Zoomed to the very weirdest

    ## Scale for 'x' is already present. Adding another scale for 'x', which
    ## will replace the existing scale.

    ## Scale for 'y' is already present. Adding another scale for 'y', which
    ## will replace the existing scale.

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](dis_files/figure-markdown_github/simp%20skew%20zoomed-1.png)

    ## [1] "How often is the Simpson percentile 0?"

    ## [1] 54

    ## [1] "How often is the skew percentile 100?"

    ## [1] 14

There's *some* relationship, but Simpson's drives to zero much earlier than the skewness percentile gets to 100. This squares with violin plots from earlier. Simpson's is more sensitive/less nuanced than skewness.

Would our conclusions change using Simpson's vs. skewness?
----------------------------------------------------------

![](dis_files/figure-markdown_github/do%20simpsons%20and%20skew%20give%20QUALITATIVELY%20same%20conclusions-1.png)

Orange is outliers. The Simpson *non-*outliers are a subset of the skew *non*-outliers. Distinguishing between a 5% threshold and a 2.5% threshold for outliers (vaguely one-sided v two-sided - but these are always one-sided) only changes one point.
