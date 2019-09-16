
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
    1    0.276         0.222         0.336            0.416            1.000
    # … with 2 more variables: Kappa <dbl>, `Corrected Rand` <dbl>
    
    $Other
    # A tibble: 4 x 14
      Class `Sensitivity/Re… `Specificity/TN… `PPV/Precision`   NPV `F1/Dice`
      <chr>            <dbl>            <dbl>           <dbl> <dbl>     <dbl>
    1 a               0.0769            0.888          0.0741 0.892    0.0755
    2 b               0.137             0.734          0.117  0.768    0.126 
    3 c               0.275             0.674          0.244  0.709    0.259 
    4 d               0.394             0.699          0.482  0.618    0.434 
    # … with 8 more variables: Prevalence <dbl>, `Detection Rate` <dbl>,
    #   `Detection Prevalence` <dbl>, `Balanced Accuracy` <dbl>, FDR <dbl>,
    #   FOR <dbl>, `FPR/Fallout` <dbl>, FNR <dbl>
    
    $`Frequency Table`
             Observed
    Predicted  a  b  c  d
            a  2  5  8 12
            b  6  7 25 22
            c 12 18 19 29
            d  6 21 17 41

``` r
dplyr::glimpse(result$`Accuracy and Agreement`)
```

    Observations: 1
    Variables: 7
    $ Accuracy            <dbl> 0.276
    $ `Accuracy LL`       <dbl> 0.221542
    $ `Accuracy UL`       <dbl> 0.3358561
    $ `Accuracy Guessing` <dbl> 0.416
    $ `Accuracy P-value`  <dbl> 0.9999984
    $ Kappa               <dbl> -0.01648845
    $ `Corrected Rand`    <dbl> 0.007924734

``` r
dplyr::glimpse(result$Other)
```

    Observations: 4
    Variables: 14
    $ Class                    <chr> "a", "b", "c", "d"
    $ `Sensitivity/Recall/TPR` <dbl> 0.07692308, 0.13725490, 0.27536232, 0.3…
    $ `Specificity/TNR`        <dbl> 0.8883929, 0.7336683, 0.6740331, 0.6986…
    $ `PPV/Precision`          <dbl> 0.07407407, 0.11666667, 0.24358974, 0.4…
    $ NPV                      <dbl> 0.8923767, 0.7684211, 0.7093023, 0.6181…
    $ `F1/Dice`                <dbl> 0.0754717, 0.1261261, 0.2585034, 0.4338…
    $ Prevalence               <dbl> 0.104, 0.204, 0.276, 0.416
    $ `Detection Rate`         <dbl> 0.008, 0.028, 0.076, 0.164
    $ `Detection Prevalence`   <dbl> 0.108, 0.240, 0.312, 0.340
    $ `Balanced Accuracy`      <dbl> 0.4826580, 0.4354616, 0.4746977, 0.5464…
    $ FDR                      <dbl> 0.9259259, 0.8833333, 0.7564103, 0.5176…
    $ FOR                      <dbl> 0.1076233, 0.2315789, 0.2906977, 0.3818…
    $ `FPR/Fallout`            <dbl> 0.1116071, 0.2663317, 0.3259669, 0.3013…
    $ FNR                      <dbl> 0.9230769, 0.8627451, 0.7246377, 0.6057…
