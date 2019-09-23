
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
    1    0.564         0.500         0.626            0.624            0.978
    # ... with 1 more variable: `Frequency Table` <list>
    
    $Other
    # A tibble: 1 x 19
      Positive     N `N Positive` `N Negative` `Sensitivity/Re~
      <chr>    <int>        <int>        <int>            <dbl>
    1 a          250           94          156            0.319
    # ... with 14 more variables: `Specificity/TNR` <dbl>,
    #   `PPV/Precision` <dbl>, NPV <dbl>, `F1/Dice` <dbl>, Prevalence <dbl>,
    #   `Detection Rate` <dbl>, `Detection Prevalence` <dbl>, `Balanced
    #   Accuracy` <dbl>, FDR <dbl>, FOR <dbl>, `FPR/Fallout` <dbl>, FNR <dbl>,
    #   `D Prime` <dbl>, AUC <dbl>
    
    $`Association and Agreement`
    # A tibble: 1 x 6
       Kappa `Adjusted Rand`   Yule    Phi Peirce Jaccard
       <dbl>           <dbl>  <dbl>  <dbl>  <dbl>   <dbl>
    1 0.0320         0.00342 0.0725 0.0324  0.298   0.505

``` r
dplyr::glimpse(result$Accuracy)
```

    Observations: 1
    Variables: 6
    $ Accuracy            <dbl> 0.564
    $ `Accuracy LL`       <dbl> 0.5000795
    $ `Accuracy UL`       <dbl> 0.6263848
    $ `Accuracy Guessing` <dbl> 0.624
    $ `Accuracy P-value`  <dbl> 0.9777636
    $ `Frequency Table`   <list> [<table[2 x 2]>]

``` r
dplyr::glimpse(result$Other)
```

    Observations: 1
    Variables: 19
    $ Positive                 <chr> "a"
    $ N                        <int> 250
    $ `N Positive`             <int> 94
    $ `N Negative`             <int> 156
    $ `Sensitivity/Recall/TPR` <dbl> 0.3191489
    $ `Specificity/TNR`        <dbl> 0.7115385
    $ `PPV/Precision`          <dbl> 0.4
    $ NPV                      <dbl> 0.6342857
    $ `F1/Dice`                <dbl> 0.3550296
    $ Prevalence               <dbl> 0.376
    $ `Detection Rate`         <dbl> 0.12
    $ `Detection Prevalence`   <dbl> 0.3
    $ `Balanced Accuracy`      <dbl> 0.5153437
    $ FDR                      <dbl> 0.6
    $ FOR                      <dbl> 0.3657143
    $ `FPR/Fallout`            <dbl> 0.2884615
    $ FNR                      <dbl> 0.6808511
    $ `D Prime`                <dbl> 0.08780478
    $ AUC                      <dbl> 0.5244596

``` r
dplyr::glimpse(result$`Association and Agreement`)
```

    Observations: 1
    Variables: 6
    $ Kappa           <dbl> 0.03197158
    $ `Adjusted Rand` <dbl> 0.003421856
    $ Yule            <dbl> 0.07246377
    $ Phi             <dbl> 0.0324367
    $ Peirce          <dbl> 0.2975939
    $ Jaccard         <dbl> 0.5045455

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
1 Accuracy          0.564
2 Accuracy LL       0.500
3 Accuracy UL       0.626
4 Accuracy Guessing 0.624
5 Accuracy P-value  0.978

$Other
# A tibble: 18 x 3
   Positive Statistic                 Value
   <chr>    <chr>                     <dbl>
 1 a        N                      250     
 2 a        N Positive              94     
 3 a        N Negative             156     
 4 a        Sensitivity/Recall/TPR   0.319 
 5 a        Specificity/TNR          0.712 
 6 a        PPV/Precision            0.4   
 7 a        NPV                      0.634 
 8 a        F1/Dice                  0.355 
 9 a        Prevalence               0.376 
10 a        Detection Rate           0.12  
11 a        Detection Prevalence     0.3   
12 a        Balanced Accuracy        0.515 
13 a        FDR                      0.6   
14 a        FOR                      0.366 
15 a        FPR/Fallout              0.288 
16 a        FNR                      0.681 
17 a        D Prime                  0.0878
18 a        AUC                      0.524 

$`Association and Agreement`
# A tibble: 6 x 2
  Statistic       Value
  <chr>           <dbl>
1 Kappa         0.0320 
2 Adjusted Rand 0.00342
3 Yule          0.0725 
4 Phi           0.0324 
5 Peirce        0.298  
6 Jaccard       0.505  
```

### Installation

To install from GitHub the <span class="pack">devtools</span> package is
required.

``` r
devtools::install_github('m-clark/confusionMatrix')
```
