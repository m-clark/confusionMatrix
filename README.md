
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

Given predictions and a target variable, provide numerous statistics
from the resulting confusion matrix. The goal is to provide a wealth of
summary statistics that can be calculated from a single confusion
matrix, and return **tidy** results with as few dependencies as
possible.

``` r
library(confusionMatrix)

p = sample(letters[1:2], 250, replace = T, prob = 1:2)
o = sample(letters[1:2], 250, replace = T, prob = 1:2)

result = confusion_matrix(
  prediction = p,
  target = o,
  return_table = TRUE
)

result
```

    $Accuracy
    # A tibble: 1 x 6
      Accuracy `Accuracy LL` `Accuracy UL` `Accuracy Guess~ `Accuracy P-val~
         <dbl>         <dbl>         <dbl>            <dbl>            <dbl>
    1    0.524         0.460         0.587            0.668            1.000
    # ... with 1 more variable: `Frequency Table` <list>
    
    $Other
    # A tibble: 1 x 19
      Positive     N `N Positive` `N Negative` `Sensitivity/Re~
      <chr>    <int>        <int>        <int>            <dbl>
    1 a          250           83          167            0.313
    # ... with 14 more variables: `Specificity/TNR` <dbl>,
    #   `PPV/Precision` <dbl>, NPV <dbl>, `F1/Dice` <dbl>, Prevalence <dbl>,
    #   `Detection Rate` <dbl>, `Detection Prevalence` <dbl>, `Balanced
    #   Accuracy` <dbl>, FDR <dbl>, FOR <dbl>, `FPR/Fallout` <dbl>, FNR <dbl>,
    #   `D Prime` <dbl>, AUC <dbl>
    
    $`Association and Agreement`
    # A tibble: 1 x 6
        Kappa `Adjusted Rand`   Yule     Phi Peirce Jaccard
        <dbl>           <dbl>  <dbl>   <dbl>  <dbl>   <dbl>
    1 -0.0571         -0.0110 -0.128 -0.0572  0.351   0.469

``` r
result$Accuracy$`Frequency Table`
```

    [[1]]
             Target
    Predicted   a   b
            a  26  62
            b  57 105

``` r
result = confusion_matrix(
  prediction = p,
  target = o,
  longer = TRUE
)

result
```

    $Accuracy
    # A tibble: 5 x 2
      Statistic         Value
      <chr>             <dbl>
    1 Accuracy          0.524
    2 Accuracy LL       0.460
    3 Accuracy UL       0.587
    4 Accuracy Guessing 0.668
    5 Accuracy P-value  1.000
    
    $Other
    # A tibble: 18 x 3
       Positive Statistic                Value
       <chr>    <chr>                    <dbl>
     1 a        N                      250    
     2 a        N Positive              83    
     3 a        N Negative             167    
     4 a        Sensitivity/Recall/TPR   0.313
     5 a        Specificity/TNR          0.629
     6 a        PPV/Precision            0.295
     7 a        NPV                      0.648
     8 a        F1/Dice                  0.304
     9 a        Prevalence               0.332
    10 a        Detection Rate           0.104
    11 a        Detection Prevalence     0.352
    12 a        Balanced Accuracy        0.471
    13 a        FDR                      0.705
    14 a        FOR                      0.352
    15 a        FPR/Fallout              0.371
    16 a        FNR                      0.687
    17 a        D Prime                 -0.158
    18 a        AUC                      0.545
    
    $`Association and Agreement`
    # A tibble: 6 x 2
      Statistic       Value
      <chr>           <dbl>
    1 Kappa         -0.0571
    2 Adjusted Rand -0.0110
    3 Yule          -0.128 
    4 Phi           -0.0572
    5 Peirce         0.351 
    6 Jaccard        0.469 

### Installation

To install from GitHub the <span class="pack">devtools</span> package is
required.

``` r
devtools::install_github('m-clark/confusionMatrix')
```
