Rarefaction/estimated richness report
================

Developing a rarefaction protocol
---------------------------------

The x-axis is the actual number of species and the y-axis is the mean of 3 estimators (`chao1984`, `ChaoBunge`, `ChaoLee1992` from `SPECIES`). The black line is the 1:1 line and the blue line is the 1:1.1 line, which represents the 10% I initially added. This is often sufficient but also often conservative.

Very small communities break the estimators and have been removed. (I think S must be &gt;3?)

![](rarefaction_files/figure-markdown_github/rarefaction-1.png)

### Sensitivity of percentile to adding singletons

Does adding singletons change our conclusions about weirdness?

This is a plot of true-value (x) vs. singletons-added (y) percentiles for skewness and Simpson's. Color corresponds to the number of species added because of the estimation. I have removed points where the estimate was equal to the actual value. The black line is the 1:1 line.

![](rarefaction_files/figure-markdown_github/conclusions%201%20to%201%20plot-1.png)

Let's zoom in on the regions of these plots where there are actually data points.

This is Simpson's. We've zoomed in to the bottom left corner. The purple guidelines are the 2.5 percentile and the blue ones are the 5 percentile. Adding singletons consistently drives the percentile value down, i.e. more extreme. It never changes whether we think the vector is "weird" to 5%, but it does push two samples from "not weird" to "weird" at 2.5%.

![](rarefaction_files/figure-markdown_github/simp%201%20to%201-1.png)

This is skewness. We've zoomed to the top right. Again, the purple lines are the 97.5, and the blue are 95. The grey is 1:1. Again, adding singletons pushes the sample to a higher, more extreme, percentile. It basically doesn't change our conclusions if we use the 95% mark (except for the one that jumps from 80 to 97.4!), but it does change our conclusions to the 97.5%. For the 97.5, two samples that are not outliers become outliers if we add singletons.

There's also one *just* on 95/97.5 line, which I'm not counting above.

![](rarefaction_files/figure-markdown_github/skew%201%20to%201-1.png)

Sometimes skewness is super small! Zooming in to the bottom left of the skewness plot, it turns out we have 1 point that is 0 and 0. This community has only 2 unique draws from the feasible set, out of 10000, so don't put a lot of stock in it.

![](rarefaction_files/figure-markdown_github/skewness%20bottom-1.png)
