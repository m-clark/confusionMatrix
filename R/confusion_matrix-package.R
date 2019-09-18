#' @name confusionMatrix

#' @description  The goal of this package is primarily to provide an easy
#'   way to obtain common confusion table metrics in a tidy fashion.  The
#'   inspiration and a good chunk of the code borrows heavily from Max Kuhn's
#'   \code{caret} package and associated function \code{confusionMatrix}, and
#'   his current work being done via the \code{yardstick} package.  Here,
#'   practically all dependencies have been removed except for dplyr, and
#'   results are tibbles making for easier document presentation, as well as the
#'   ability to peel off the statistics desired.
#'
#'   All that is required is a vector of predicted classes and a vector of
#'   observed classes, as that is typically what we're dealing with in such
#'   scenarios.  These can be logical, integer/numeric, character, or factor,
#'   but the predictions should match the observations in an obvious way.
#'
#'   Statistics provided include:
#'
#'   Accuracy and Agreement
#'     - Accuracy, bounds, and related
#'     - Cohen's Kappa
#'     - Corrected Rand
#'
#'   Other Statistics:
#'     - Sensitivity
#'     - Specificity
#'     - Prevalence
#'     - Positive Predictive Value
#'     - Negative Predictive Value
#'     - Detection prevalence
#'     - Balanced Accuracy
#'     - F1
#'
#'   Measures of Association:
#'     - Phi
#'     - Yule's
#'     - Peirce's science of the method (Youden's J)
#'

#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end

NULL
