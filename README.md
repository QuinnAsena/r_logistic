# Discrete Logistic Population Growth Models

An interactive [Shiny](https://shiny.rstudio.com/) application for exploring deterministic, discrete, density-dependent logistic population growth models.

## Overview

This app provides two tabs, each implementing a different parameterisation of the discrete logistic growth model:

1. **r discrete model** — uses the discrete growth factor *r<sub>d</sub>*:

   *N<sub>t+1</sub> = N<sub>t</sub> + r<sub>d</sub> N<sub>t</sub> (1 − N<sub>t</sub> / K)*

2. **λ (lambda) discrete model** — uses the finite rate of increase *λ*:

   *N<sub>t+1</sub> = λ N<sub>t</sub> (1 − N<sub>t</sub> / K)*

A third tab provides background on the models, their assumptions, and references.

## Features

- Adjustable sliders for starting population (*N*), carrying capacity (*K*), growth rate (*r* or *λ*), and time (*t*).
- Real-time plots of population size over time and rate of population change vs. population size.
- Demonstrates stable equilibria, damping oscillations, limit cycles, and chaotic dynamics depending on the growth rate.

## Running the App

### Prerequisites

- [R](https://cran.r-project.org/) (≥ 3.5)
- R packages: `shiny`, `grDevices`, `knitr`

### Launch

```r
# From the project directory
shiny::runApp()
```

Or open `app.R` in RStudio and click **Run App**.

## References

- Gillman, M. (2005). Population Dynamics: Introduction. *Encyclopedia of Life Sciences*.
- Gillman, M. (2009). *An Introduction to Mathematical Models in Ecology and Evolution: Time and Space*. Wiley-Blackwell.
- Gotelli, N. J. (2001). *A Primer of Ecology* (3rd ed.). Sinauer Associates.
