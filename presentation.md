---
title       : "Road casualties in GB 1969–84: Simulation Experiment"
subtitle    : October 1, 2017
author      : Gennady Kalashnikov
framework   : io2012
highlighter : highlight.js
hitheme     : tomorrow
widgets     : []
mode        : selfcontained
knit        : slidify::knit2slides
---

## History

* The fact that introduction of compulsory wearing of seat belts greatly reduced number of road casualties is well known.

<img src="https://hk-coursera.github.io/r-shiny-assignment/presentation-historical-plot.png"
     height="450px" width="100%"/>

---

## Road casualties

* But can effect of seatbelts on total number of injuries be estimated?

* Or theoretical effect of introducing it sooner (or later)?

* This app makes an attempt to do it.

* It allows you to use model, trained on historical data, to simulate introduction of compulsory wearing of seat belts on any date.

## Simulation app

* Give it a new date of introduction of compulsory wearing of seat belts in Great Britain.

* Click 'simulate' button

* And it estimates the monthly totals of car drivers killed or seriously injured and drivers killed after this date (in Great Britain).

---

## Example of simulation plot

<img src="https://hk-coursera.github.io/r-shiny-assignment/presentation-simulated-plot.png"
     height="450px" width="100%"/>

Simulating introduction of compulsory of seat belts wearing set on 31 Jan 1978.

---

## Model




```r
modelDriversInjured <- train(drivers ~ law + mkm + month, method="gbm",
                             data=dtSrc, verbose=FALSE)
head(summary(modelDriversInjured, plot = FALSE))
```

```
##             var   rel.inf
## mkm         mkm 30.610638
## month12 month12 26.834156
## lawTRUE lawTRUE 15.179162
## month11 month11 10.969707
## month10 month10  8.034743
## month4   month4  4.963070
```

App uses a very simply model, but it's enough to display great influence of this law on road casualties.
