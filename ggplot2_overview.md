<style>
.reveal h3 {
  font-size: 2.5em;
  color: blue;
}

.reveal ul,
.reveal ol {
  font-size: 2em;
  color: black;
  list-style-type: circle;
  line-height: 125%;
}

.reveal p {
  font-size: 2.1em;
  margin-bottom: .4em;
}

.reveal pre code {
  font-size: 3.4em;
}

.section .reveal .state-background {
  background: white;
}
.section .reveal h1 {
  color: blue;
  position: relative;
  font-size: 3em;
  top: 10%;
}
.section .reveal p {
  color: black;
  position: relative;
  font-size: 2em;
  top: 10%
}
</style>

Data Visualization with ggplot2
========================================================
author: R Users Group Meeting
date: August 23, 2016
font-family: 'Arial'
autosize: true


Why do we visualize data?
========================================================

- To Explore
- To Examine
- To Communicate


ggplot2
========================================================

- R package
- Created by Hadley Wickham, Chief Scientist at RStudio
- <span style="color:orange">g</span>rammar of <span style="color:orange">g</span>raphics <span style="color:orange">plot</span>


grammar of graphics plots
========================================================

<p style="color:green">Layered components of the graphical display</p>

- data
- aesthetic mapping (x, y, and more)
- geometric objects (e.g., lines, points, histogram)
- scales
- statistics
- facets

Basic function components
========================================================

```r
ggplot(data = yourdata,
       aes(x = your_x_variable,
           y = your_y_variable)) +
    geom_point() +
    scale_x_date(date_breaks = "1 month",
                 date_labels = "%b %Y") +
    stat_sum() +
    facet_wrap(~your_grouping_variable)
```

Sample Figures
============


Resources
========================================================

- ggplot2 documentation site: <http://docs.ggplot2.org/current/>
- Cookbook for R: <http://www.cookbook-r.com/Graphs/>
- Quick-R dates: <http://www.statmethods.net/input/dates.html>


