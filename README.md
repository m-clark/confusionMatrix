
<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/m-clark/confusionMatrix.svg?branch=master)](https://travis-ci.org/m-clark/confusionMatrix)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/m-clark/confusionMatrix?branch=master&svg=true)](https://ci.appveyor.com/project/m-clark/confusionMatrix)
[![Codecov test
coverage](https://codecov.io/gh/m-clark/confusionMatrix/branch/master/graph/badge.svg)](https://codecov.io/gh/m-clark/confusionMatrix?branch=master)
<!-- <a href="https://github.com/m-clark/confusionMatrix" alt="Miscellaneous Shenanigans"> -->
<!--         <img src="https://img.shields.io/badge/Status-Meh-ff5500.svg?colorA=00aaff&longCache=true&style=for-the-badge"  width=20.5%/></a> -->
<!-- badges: end -->

<br> <br>

A hopefully straightforward re-implementation inspired by the `caret`
package to simplify input and return ‘tidy’ results. The goal is to
provide a wealth of simple summary statistics that can be calculated
from a single confusion matrix.

``` r
library(confusionMatrix)
p = sample(letters[1:4], 250, replace = T, prob = 1:4)
o = sample(letters[1:4], 250, replace = T, prob = 1:4)

confusion_matrix(
  prediction = p,
  observed = o,
  return_table = TRUE
)
```

    $`Accuracy and Agreement`
    # A tibble: 1 x 7
      Accuracy `Accuracy LL` `Accuracy UL` `Accuracy Guess… `Accuracy P-val…
         <dbl>         <dbl>         <dbl>            <dbl>            <dbl>
    1    0.304         0.248         0.365            0.372            0.990
    # … with 2 more variables: Kappa <dbl>, `Corrected Rand` <dbl>
    
    $Other
    # A tibble: 4 x 14
      Class `Sensitivity/Re… `Specificity/TN… `PPV/Precision`   NPV `F1/Dice`
      <chr>            <dbl>            <dbl>           <dbl> <dbl>     <dbl>
    1 a               0.0909            0.931           0.167 0.871     0.118
    2 b               0.130             0.814           0.136 0.806     0.133
    3 c               0.321             0.674           0.309 0.686     0.314
    4 d               0.452             0.586           0.393 0.643     0.420
    # … with 8 more variables: Prevalence <dbl>, `Detection Rate` <dbl>,
    #   `Detection Prevalence` <dbl>, `Balanced Accuracy` <dbl>, FDR <dbl>,
    #   FOR <dbl>, `FPR/Fallout` <dbl>, FNR <dbl>
    
    $`Frequency Table`
             Observed
    Predicted  a  b  c  d
            a  3  5  5  5
            b  4  6 16 18
            c 13 15 25 28
            d 13 20 32 42
