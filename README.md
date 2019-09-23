
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
      Accuracy `Accuracy LL` `Accuracy UL` `Accuracy Guess… `Accuracy P-val…
         <dbl>         <dbl>         <dbl>            <dbl>            <dbl>
    1    0.524         0.460         0.587            0.684            1.000
    # … with 1 more variable: `Frequency Table` <list>
    
    $Other
    # A tibble: 1 x 19
      Positive     N `N Positive` `N Negative` `Sensitivity/Re…
      <chr>    <int>        <int>        <int>            <dbl>
    1 a          250           79          171            0.228
    # … with 14 more variables: `Specificity/TNR` <dbl>,
    #   `PPV/Precision` <dbl>, NPV <dbl>, `F1/Dice` <dbl>, Prevalence <dbl>,
    #   `Detection Rate` <dbl>, `Detection Prevalence` <dbl>, `Balanced
    #   Accuracy` <dbl>, FDR <dbl>, FOR <dbl>, `FPR/Fallout` <dbl>, FNR <dbl>,
    #   `D Prime` <dbl>, AUC <dbl>
    
    $`Association and Agreement`
    # A tibble: 1 x 6
       Kappa `Adjusted Rand`   Yule    Phi Peirce Jaccard
       <dbl>           <dbl>  <dbl>  <dbl>  <dbl>   <dbl>
    1 -0.112         -0.0220 -0.270 -0.113  0.305   0.487

``` r
dplyr::glimpse(result$Accuracy)
```

    Observations: 1
    Variables: 6
    $ Accuracy            <dbl> 0.524
    $ `Accuracy LL`       <dbl> 0.4601255
    $ `Accuracy UL`       <dbl> 0.5872988
    $ `Accuracy Guessing` <dbl> 0.684
    $ `Accuracy P-value`  <dbl> 1
    $ `Frequency Table`   <list> [<table[2 x 2]>]

``` r
dplyr::glimpse(result$Other)
```

    Observations: 1
    Variables: 19
    $ Positive                 <chr> "a"
    $ N                        <int> 250
    $ `N Positive`             <int> 79
    $ `N Negative`             <int> 171
    $ `Sensitivity/Recall/TPR` <dbl> 0.2278481
    $ `Specificity/TNR`        <dbl> 0.6608187
    $ `PPV/Precision`          <dbl> 0.2368421
    $ NPV                      <dbl> 0.6494253
    $ `F1/Dice`                <dbl> 0.2322581
    $ Prevalence               <dbl> 0.316
    $ `Detection Rate`         <dbl> 0.072
    $ `Detection Prevalence`   <dbl> 0.304
    $ `Balanced Accuracy`      <dbl> 0.4443334
    $ FDR                      <dbl> 0.7631579
    $ FOR                      <dbl> 0.3505747
    $ `FPR/Fallout`            <dbl> 0.3391813
    $ FNR                      <dbl> 0.7721519
    $ `D Prime`                <dbl> -0.3312538
    $ AUC                      <dbl> 0.5927469

``` r
dplyr::glimpse(result$`Association and Agreement`)
```

    Observations: 1
    Variables: 6
    $ Kappa           <dbl> -0.1124822
    $ `Adjusted Rand` <dbl> -0.0219661
    $ Yule            <dbl> -0.269921
    $ Phi             <dbl> -0.1125265
    $ Peirce          <dbl> 0.3052022
    $ Jaccard         <dbl> 0.487069

### Installation

To install from GitHub the <span class="pack">devtools</span> package is
required.

``` r
devtools::install_github('m-clark/confusionMatrix')
```
