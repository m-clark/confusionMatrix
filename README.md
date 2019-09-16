
<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/m-clark/confusionMatrix.svg?branch=master)](https://travis-ci.org/m-clark/confusionMatrix)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/m-clark/confusionMatrix?branch=master&svg=true)](https://ci.appveyor.com/project/m-clark/confusionMatrix)
[![Codecov test
coverage](https://codecov.io/gh/m-clark/confusionMatrix/branch/master/graph/badge.svg)](https://codecov.io/gh/m-clark/confusionMatrix?branch=master)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-experimental-blue.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- <a href="https://github.com/m-clark/confusionMatrix" alt="Miscellaneous Shenanigans"> -->
<!--         <img src="https://img.shields.io/badge/Status-Meh-ff5500.svg?colorA=00aaff&longCache=true&style=for-the-badge"  width=20.5%/></a> -->

<!-- badges: end -->

# confusionMatrix

<br>

A hopefully straightforward re-implementation inspired by the `caret`
package to simplify input and return ‘tidy’ results with as few
dependencies as possible. The goal is to provide a wealth of simple(\!)
summary statistics that can be calculated from a single confusion
matrix.

``` r
library(confusionMatrix)

p = sample(letters[1:4], 250, replace = T, prob = 1:4)
o = sample(letters[1:4], 250, replace = T, prob = 1:4)

result = confusion_matrix(
  prediction = p,
  observed = o,
  return_table = TRUE
)

result
```

    $`Accuracy and Agreement`
    # A tibble: 1 x 7
      Accuracy `Accuracy LL` `Accuracy UL` `Accuracy Guess… `Accuracy P-val…
         <dbl>         <dbl>         <dbl>            <dbl>            <dbl>
    1    0.292         0.236         0.353            0.412            1.000
    # … with 2 more variables: Kappa <dbl>, `Corrected Rand` <dbl>
    
    $Other
    # A tibble: 4 x 14
      Class `Sensitivity/Re… `Specificity/TN… `PPV/Precision`   NPV `F1/Dice`
      <chr>            <dbl>            <dbl>           <dbl> <dbl>     <dbl>
    1 a               0.0385            0.897          0.0417 0.889     0.04 
    2 b               0.349             0.787          0.254  0.853     0.294
    3 c               0.295             0.692          0.303  0.684     0.299
    4 d               0.330             0.612          0.374  0.566     0.351
    # … with 8 more variables: Prevalence <dbl>, `Detection Rate` <dbl>,
    #   `Detection Prevalence` <dbl>, `Balanced Accuracy` <dbl>, FDR <dbl>,
    #   FOR <dbl>, `FPR/Fallout` <dbl>, FNR <dbl>
    
    $`Frequency Table`
             Observed
    Predicted  a  b  c  d
            a  1  3  5 15
            b  4 15 19 21
            c 10 10 23 33
            d 11 15 31 34

``` r
dplyr::glimpse(result$`Accuracy and Agreement`)
```

    Observations: 1
    Variables: 7
    $ Accuracy            <dbl> 0.292
    $ `Accuracy LL`       <dbl> 0.2364072
    $ `Accuracy UL`       <dbl> 0.3526017
    $ `Accuracy Guessing` <dbl> 0.412
    $ `Accuracy P-value`  <dbl> 0.9999679
    $ Kappa               <dbl> -0.004814024
    $ `Corrected Rand`    <dbl> -0.008424046

``` r
dplyr::glimpse(result$Other)
```

    Observations: 4
    Variables: 14
    $ Class                    <chr> "a", "b", "c", "d"
    $ `Sensitivity/Recall/TPR` <dbl> 0.03846154, 0.34883721, 0.29487179, 0.3…
    $ `Specificity/TNR`        <dbl> 0.8973214, 0.7874396, 0.6918605, 0.6122…
    $ `PPV/Precision`          <dbl> 0.04166667, 0.25423729, 0.30263158, 0.3…
    $ NPV                      <dbl> 0.8893805, 0.8534031, 0.6839080, 0.5660…
    $ `F1/Dice`                <dbl> 0.0400000, 0.2941176, 0.2987013, 0.3505…
    $ Prevalence               <dbl> 0.104, 0.172, 0.312, 0.412
    $ `Detection Rate`         <dbl> 0.004, 0.060, 0.092, 0.136
    $ `Detection Prevalence`   <dbl> 0.096, 0.236, 0.304, 0.364
    $ `Balanced Accuracy`      <dbl> 0.4678915, 0.5681384, 0.4933661, 0.4711…
    $ FDR                      <dbl> 0.9583333, 0.7457627, 0.6973684, 0.6263…
    $ FOR                      <dbl> 0.1106195, 0.1465969, 0.3160920, 0.4339…
    $ `FPR/Fallout`            <dbl> 0.1026786, 0.2125604, 0.3081395, 0.3877…
    $ FNR                      <dbl> 0.9615385, 0.6511628, 0.7051282, 0.6699…

### Installation

To install from GitHub the <span class="pack">devtools</span> package is
required.

``` r
devtools::install_github('m-clark/confusionMatrix')
```
