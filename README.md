
<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/m-clark/confusionMatrix.svg?branch=master)](https://travis-ci.org/m-clark/confusionMatrix)

[![Codecov test
coverage](https://codecov.io/gh/m-clark/confusionMatrix/branch/master/graph/badge.svg)](https://codecov.io/gh/m-clark/confusionMatrix?branch=master)

<a href="https://github.com/m-clark/confusionMatrix" alt="Miscellaneous Shenanigans">
<img src="https://img.shields.io/badge/Status-Meh-ff5500.svg?colorA=00aaff&longCache=true&style=for-the-badge"  width=20.5%/></a>

<!-- badges: end -->

<br> <br>

A hopefully straightforward re-implementation of the function from the
`caret` package to simplify input and return ‘tidy’ results. The goal is
to provide a wealth of simple summary statistics that can be calculated
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

    ## $`Accuracy and Agreement`
    ## # A tibble: 1 x 7
    ##   Accuracy `Accuracy LL` `Accuracy UL` `Accuracy Guess… `Accuracy P-val…
    ##      <dbl>         <dbl>         <dbl>            <dbl>            <dbl>
    ## 1    0.304         0.248         0.365            0.364            0.980
    ## # … with 2 more variables: Kappa <dbl>, `Corrected Rand` <dbl>
    ## 
    ## $Other
    ## # A tibble: 4 x 10
    ##   Class `Sensitivity/Re… `Specificity/TN… `PPV/Precision`   NPV `F1/Dice`
    ##   <chr>            <dbl>            <dbl>           <dbl> <dbl>     <dbl>
    ## 1 a                0.133            0.918           0.182 0.886     0.154
    ## 2 b                0.216            0.824           0.239 0.804     0.227
    ## 3 c                0.359            0.692           0.346 0.704     0.352
    ## 4 d                0.363            0.572           0.327 0.611     0.344
    ## # … with 4 more variables: Prevalence <dbl>, `Detection Rate` <dbl>,
    ## #   `Detection Prevalence` <dbl>, `Balanced Accuracy` <dbl>
    ## 
    ## $`Frequency Table`
    ##          Observed
    ## Predicted  a  b  c  d
    ##         a  4  4  8  6
    ##         b  3 11  9 23
    ##         c  8 16 28 29
    ##         d 15 20 33 33
