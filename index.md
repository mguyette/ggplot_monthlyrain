
This tutorial illustrates how to use the R package **ggplot2** to build a simple plot. This plot was designed for land managers at the St. Johns River Water Management District interested in the conditions in the Lake Apopka area to determine whether the conditions are appropriate for prescribed burns.

Input data
----------

The input data for this plot is a data frame called Ap\_Rain with the following structure:
<table style="width:100%" border="0">
<tr>
    <th>Column</th>
    <th>Description</th>
    <th>Coordinates</th>

</tr>
<tr>
    <td>date</td>
    <td>date in Date format</td>
    <td></td>

</tr>
<tr>
    <td>MFWRain</td>
    <td>Rain in inches at the Lake Apopka Marsh Flow-Way</td>
    <td>Lat:28.67143722<br>Long:-81.67500639</td>

</tr>
<tr>
    <td>Ph2Rain</td>
    <td>Rain in inches at the Lake Apopka North Shore Restoration Area, Phase 2</td>
    <td>Lat:28.63771<br>Long:-81.54675</td>

</tr>
<tr>
    <td>ET</td>
    <td>Evapotranspiration in inches from the Apopka IFAS FAWN station</td>
    <td></td>

</tr>
</table>
``` r
load("./DataFiles/Apopka_Rain.RData")
```

The first few rows of the table look like this:

|    date    | MFWRain | Ph2Rain |  ET  |
|:----------:|:-------:|:-------:|:----:|
| 2016-07-01 |   0.56  |   0.08  | 0.19 |
| 2016-07-02 |   0.01  |   0.28  | 0.15 |
| 2016-07-03 |    0    |    0    | 0.19 |
| 2016-07-04 |    0    |    0    | 0.23 |
| 2016-07-05 |    0    |    0    | 0.23 |
| 2016-07-06 |    0    |   0.01  |  NA  |

This data frame is not formatted well for ggplot, which works best with single record per line data. The **pivot\_longer** function in the **tidy** package is quick and easy way to pivot from wide to long format:

``` r
df.long <- Ap_Rain %>%
    pivot_longer(cols = c(MFWRain, Ph2Rain, ET), names_to = "variable")
```

Now the first few rows look like this:

|    date    | variable | value |
|:----------:|:--------:|:-----:|
| 2016-07-01 |  MFWRain |  0.56 |
| 2016-07-01 |  Ph2Rain |  0.08 |
| 2016-07-01 |    ET    |  0.19 |
| 2016-07-02 |  MFWRain |  0.01 |
| 2016-07-02 |  Ph2Rain |  0.28 |
| 2016-07-02 |    ET    |  0.15 |

From month to month, the land managers were interested in seeing the same basic plot with updated data. Sometimes there are high rainfall values that would skew the y-axis if we allowed ggplot to autoscale the y-axis each month. Instead, I chose to fix the y-axis scale to range between 0 and 2. In order to handle high rainfall events, I added a new variable, **high**, that is used to annotate the plot whenever rainfall exceeds 2 inches:

``` r
df.long <- df.long %>%
    mutate(high = case_when(value > 2 ~ value, value <= 2 ~ NA_real_)) %>%
    arrange(desc(high))
```

After sorting by the new variable, high, the first few rows of the data frame now look like this:

|    date    | variable | value | high |
|:----------:|:--------:|:-----:|:----:|
| 2016-07-12 |  Ph2Rain |  2.46 | 2.46 |
| 2016-07-01 |  MFWRain |  0.56 |  NA  |
| 2016-07-01 |  Ph2Rain |  0.08 |  NA  |
| 2016-07-01 |    ET    |  0.19 |  NA  |
| 2016-07-02 |  MFWRain |  0.01 |  NA  |
| 2016-07-02 |  Ph2Rain |  0.28 |  NA  |

ggplot2
-------

T

Creating a plot
---------------

The first step is to identify the input data and aesthetic mapping.

``` r
p <- ggplot(df.long,aes(x=date,
                        y=value,
                        group=variable,
                        color=variable)) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-7-1.png)

As you can see, without adding a geometric object to the Add a geometric object, in this case we will use a stairstep plot

``` r
p <- p + geom_step(aes(size = variable)) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-8-1.png)

Change the size of the lines on the plot

``` r
p <- p + scale_size_manual(values = c(1.6, 1.4, 1.4), guide = "none") ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-9-1.png)

Change the size of the lines in the legend

``` r
p <- p + guides(colour = guide_legend(override.aes = list(size = 1.4))) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-10-1.png)

Change the colors and the labels for each line

``` r
p <- p + scale_colour_manual(values = c("ET" = "black", "MFWRain" = "blue", "Ph2Rain" = "red"),
                             labels = c("Evapotranspiration",
                                      "Rain at the Marsh Flow-Way",
                                      "Rain at NSRA Phase 2")) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-11-1.png)

Change to a black and white theme

``` r
p <- p + theme_bw() ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-12-1.png)

Remove the x label and add a more informative y label:

``` r
p <- p + 
    xlab("") +
    ylab("Rainfall or Evapotranspiration (in)"); p
```

![](index_files/figure-markdown_github/unnamed-chunk-13-1.png) Add a title

``` r
p <- p + ggtitle(paste(month(df.long$date[1], label = T),
                       year(df.long$date[1]),
                       "Rainfall and Evapotranspiration")) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-14-1.png)

The **theme** function is where you can change text elements and design components. Here I increased text size for axis labels and titles and horizontally adjusted x-axis text so that the left edge aligns close to the tick marks. I removed the legend title, increased legend text size, and moved the legend to the bottom, and I increased the title text size.

``` r
p <- p + theme(axis.text = element_text(face = "bold", size = 11),
               axis.title = element_text(face = "bold", size = 17),
               axis.text.x = element_text(hjust = 0.1),
               legend.title = element_blank(),
               legend.text = element_text(face = "bold", size = 14),
               legend.position = "bottom",
               title = element_text(face = "bold", size = 20)) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-15-1.png)

The Define a vector that defines the date breaks for the x axisSet the x-axis labels for every other day starting on the first day of the month

``` r
break.vec <- c(seq(from = min(df.long$date),
                   to = max(df.long$date) - 1,
                   by = "2 days"))

p <- p + scale_x_date(breaks = break.vec,
                      limits = c(min(df.long$date), max(df.long$date)),
                      expand = c(0,0),
                      labels = date_format("%b %d")) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-16-1.png)

Set the y limits to range from 0 to 2 (with a little buffer). Note that coord\_cartesian is required here if you want to show data that goes outside the limits

``` r
p <- p + coord_cartesian(ylim = c(-0.1, 2.1)) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-17-1.png)

Add text when the rainfall exceeds 2 inches

``` r
p <- p + geom_text(aes(x = date + 0.5,
                       y = 2.0,
                       label = ifelse(is.na(high), "", high),
                       group = variable,
                       colour = variable,
                       fontface = "bold"),
                   size = 3.5) ; p
```

![](index_files/figure-markdown_github/unnamed-chunk-18-1.png)
