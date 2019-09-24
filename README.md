
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

<span style="height: 3em"></span>

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
    1     0.54         0.476         0.603            0.592            0.958
    # … with 1 more variable: `Frequency Table` <list>
    
    $Other
    # A tibble: 1 x 19
      Positive     N `N Positive` `N Negative` `Sensitivity/Re…
      <chr>    <int>        <int>        <int>            <dbl>
    1 a          250          102          148            0.373
    # … with 14 more variables: `Specificity/TNR` <dbl>,
    #   `PPV/Precision` <dbl>, NPV <dbl>, `F1/Dice` <dbl>, Prevalence <dbl>,
    #   `Detection Rate` <dbl>, `Detection Prevalence` <dbl>, `Balanced
    #   Accuracy` <dbl>, FDR <dbl>, FOR <dbl>, `FPR/Fallout` <dbl>, FNR <dbl>,
    #   `D Prime` <dbl>, AUC <dbl>
    
    $`Association and Agreement`
    # A tibble: 1 x 6
       Kappa `Adjusted Rand`   Yule    Phi Peirce Jaccard
       <dbl>           <dbl>  <dbl>  <dbl>  <dbl>   <dbl>
    1 0.0285       0.0000338 0.0607 0.0287  0.355   0.458

``` r
result$Accuracy$`Frequency Table`
```

    [[1]]
             Target
    Predicted  a  b
            a 38 51
            b 64 97

``` r
result = confusion_matrix(
  prediction = p,
  target = o,
  longer = TRUE
)

result
```

``` 
$Accuracy
# A tibble: 5 x 2
  Statistic         Value
  <chr>             <dbl>
1 Accuracy          0.54 
2 Accuracy LL       0.476
3 Accuracy UL       0.603
4 Accuracy Guessing 0.592
5 Accuracy P-value  0.958

$Other
# A tibble: 18 x 3
   Positive Statistic                 Value
   <chr>    <chr>                     <dbl>
 1 a        N                      250     
 2 a        N Positive             102     
 3 a        N Negative             148     
 4 a        Sensitivity/Recall/TPR   0.373 
 5 a        Specificity/TNR          0.655 
 6 a        PPV/Precision            0.427 
 7 a        NPV                      0.602 
 8 a        F1/Dice                  0.398 
 9 a        Prevalence               0.408 
10 a        Detection Rate           0.152 
11 a        Detection Prevalence     0.356 
12 a        Balanced Accuracy        0.514 
13 a        FDR                      0.573 
14 a        FOR                      0.398 
15 a        FPR/Fallout              0.345 
16 a        FNR                      0.627 
17 a        D Prime                  0.0748
18 a        AUC                      0.521 

$`Association and Agreement`
# A tibble: 6 x 2
  Statistic         Value
  <chr>             <dbl>
1 Kappa         0.0285   
2 Adjusted Rand 0.0000338
3 Yule          0.0607   
4 Phi           0.0287   
5 Peirce        0.355    
6 Jaccard       0.458    
```

### Installation

To install from GitHub the <span class="pack">devtools</span> package is
required.

``` r
devtools::install_github('m-clark/confusionMatrix')
```
