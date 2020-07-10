
<!-- badges: start -->

[![R build
status](https://github.com/m-clark/confusionMatrix/workflows/R-CMD-check/badge.svg)](https://github.com/m-clark/confusionMatrix/actions)
[![Codecov test
coverage](https://codecov.io/gh/m-clark/confusionMatrix/branch/master/graph/badge.svg)](https://codecov.io/gh/m-clark/confusionMatrix?branch=master)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-experimental-blue.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<!-- badges: end -->

# confusionMatrix

<br>

Given predictions and a target variable, provide numerous statistics
from the resulting confusion matrix. The goal is to provide a wealth of
summary statistics that can be calculated from a single confusion
matrix, and return <span class="emph" style="">**tidy**</span> results
with as few dependencies as possible.

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
      Accuracy `Accuracy LL` `Accuracy UL` `Accuracy Guess… `Accuracy P-val…
         <dbl>         <dbl>         <dbl>            <dbl>            <dbl>
    1    0.596         0.532         0.657            0.692            0.999
    # … with 1 more variable: `Frequency Table` <list>
    
    $Other
    # A tibble: 1 x 19
      Positive     N `N Positive` `N Negative` `Sensitivity/Re… `Specificity/TN…
      <chr>    <int>        <int>        <int>            <dbl>            <dbl>
    1 a          250           77          173            0.338            0.711
    # … with 13 more variables: `PPV/Precision` <dbl>, NPV <dbl>, `F1/Dice` <dbl>,
    #   Prevalence <dbl>, `Detection Rate` <dbl>, `Detection Prevalence` <dbl>,
    #   `Balanced Accuracy` <dbl>, FDR <dbl>, FOR <dbl>, `FPR/Fallout` <dbl>,
    #   FNR <dbl>, `D Prime` <dbl>, AUC <dbl>
    
    $`Association and Agreement`
    # A tibble: 1 x 6
       Kappa `Adjusted Rand`  Yule    Phi Peirce Jaccard
       <dbl>           <dbl> <dbl>  <dbl>  <dbl>   <dbl>
    1 0.0488          0.0116 0.113 0.0488 0.0486   0.549

``` r
result$Accuracy$`Frequency Table`
```

    [[1]]
             Target
    Predicted   a   b
            a  26  50
            b  51 123

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
    1 Accuracy          0.596
    2 Accuracy LL       0.532
    3 Accuracy UL       0.657
    4 Accuracy Guessing 0.692
    5 Accuracy P-value  0.999
    
    $Other
    # A tibble: 18 x 3
       Positive Statistic                Value
       <chr>    <chr>                    <dbl>
     1 a        N                      250    
     2 a        N Positive              77    
     3 a        N Negative             173    
     4 a        Sensitivity/Recall/TPR   0.338
     5 a        Specificity/TNR          0.711
     6 a        PPV/Precision            0.342
     7 a        NPV                      0.707
     8 a        F1/Dice                  0.340
     9 a        Prevalence               0.308
    10 a        Detection Rate           0.104
    11 a        Detection Prevalence     0.304
    12 a        Balanced Accuracy        0.524
    13 a        FDR                      0.658
    14 a        FOR                      0.293
    15 a        FPR/Fallout              0.289
    16 a        FNR                      0.662
    17 a        D Prime                  0.137
    18 a        AUC                      0.538
    
    $`Association and Agreement`
    # A tibble: 6 x 2
      Statistic      Value
      <chr>          <dbl>
    1 Kappa         0.0488
    2 Adjusted Rand 0.0116
    3 Yule          0.113 
    4 Phi           0.0488
    5 Peirce        0.0486
    6 Jaccard       0.549 

### Installation

To install from GitHub the <span class="pack">devtools</span> package is
required.

``` r
devtools::install_github('m-clark/confusionMatrix')
```
