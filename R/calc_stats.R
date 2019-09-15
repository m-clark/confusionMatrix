#' Calculate various statistics from a confusion matrix
#' @description Given a frequency table of predictions versus observed values,
#'   calculate numerous statistics of interest.
#' @param tabble  A frequency table created with \code{\link{table}}
#' @param prevalence Prevalance value. Default is \code{NULL}
#' @param positive Positive class
#' @param ... Other, not currently used
#' @details Used within confusion_matrix to calculate various confusion matrix
#'   metrics. Not really meant to be called directly by the user.
#'
#' Suppose a 2x2 table with notation
#'
#' \tabular{rcc}{ \tab Reference \tab \cr Predicted \tab Event \tab No Event
#' \cr Event \tab A \tab B \cr No Event \tab C \tab D \cr }
#'
#' The formulas used here are:
#' \deqn{Sensitivity = A/(A+C)}
#' \deqn{Specificity = D/(B+D)}
#' \deqn{Prevalence = (A+C)/(A+B+C+D)}
#' \deqn{PPV = (sensitivity * prevalence)/((sensitivity*prevalence) + ((1-specificity)*(1-prevalence)))}
#' \deqn{NPV = (specificity * (1-prevalence))/(((1-sensitivity)*prevalence) + ((specificity)*(1-prevalence)))} \deqn{Detection Rate = A/(A+B+C+D)}
#' \deqn{Detection Prevalence = (A+B)/(A+B+C+D)}
#' \deqn{Balanced Accuracy = (sensitivity+specificity)/2}
#'
#' \deqn{Precision = A/(A+B)} \deqn{Recall = A/(A+C)} \deqn{F1 = (1+beta^2)*precision*recall/((beta^2 * precision)+recall)}
#'
#' where \code{beta = 1} for this function.
#'
#' See the references for discussions of the first five formulas.
#'
#' @return A tibble with (at present) columns for sensitivity, specificity, positive
#'   predictive value (PPV), negative predictive value (NPV), F1 score (aka Dice
#'   coefficient), detection rate, detection prevalence, balanced accuracy.  For
#'   > 2 classes, these statistics are provided for each class.
#'
#' @references Kuhn, M. (2008), "Building predictive models in R using the
#' caret package, " \emph{Journal of Statistical Software},
#' (\url{http://www.jstatsoft.org/article/view/v028i05/v28i05.pdf}).
#'
#' Altman, D.G., Bland, J.M. (1994) "Diagnostic tests 1: sensitivity and
#' specificity", \emph{British Medical Journal}, vol 308, 1552.
#'
#' Altman, D.G., Bland, J.M. (1994) "Diagnostic tests 2: predictive values,"
#' \emph{British Medical Journal}, vol 309, 102.
#'
#' Velez, D.R., et. al. (2008) "A balanced accuracy function for epistasis
#' modeling in imbalanced datasets using multifactor dimensionality
#' reduction.," \emph{Genetic Epidemiology}, vol 4, 306.
#'
#' @importFrom dplyr tibble
#'
#' @examples
#' p = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#' o = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#' calc_stats(table(p, o), positive='a')

#' @export
calc_stats <- function(tabble, prevalence = NULL, positive, ...) {
  # checks
  if (!all.equal(nrow(tabble), ncol(tabble)))
    stop("the table must have nrow = ncol")

  if (!all.equal(rownames(tabble), colnames(tabble)))
    stop("the table must the same groups in the same order")

  tabble_init = tabble

  # Calculate Sensitivity ---------------------------------------------------

  if (nrow(tabble_init) > 2) {
    tmp <- tabble_init
    tabble <- matrix(NA, 2, 2)
    colnames(tabble) <- rownames(tabble) <- c("pos", "neg")
    posCol <- which(colnames(tmp) %in% positive)
    negCol <- which(!(colnames(tmp) %in% positive))
    tabble[1, 1] <- sum(tmp[posCol, posCol])
    tabble[1, 2] <- sum(tmp[posCol, negCol])
    tabble[2, 1] <- sum(tmp[negCol, posCol])
    tabble[2, 2] <- sum(tmp[negCol, negCol])
    tabble <- as.table(tabble)
    pos <- "pos"
    neg <- "neg"

    rm(tmp)
  } else {
    pos = positive
    neg = rownames(tabble_init)[rownames(tabble_init) != positive]
  }

  numer <- sum(tabble[pos, pos])
  denom <- sum(tabble[, pos])
  sens <- ifelse(denom > 0, numer/denom, NA)

  detection_rate = sum(tabble[pos, pos])/sum(tabble)
  detection_prevalence = sum(tabble[pos, ])/sum(tabble)


  # Calculate Specificity ---------------------------------------------------

  numer <- sum(tabble[neg, neg])
  denom <- sum(tabble[, neg])
  spec <- ifelse(denom > 0, numer/denom, NA)


  # Calculate Prevalence ----------------------------------------------------

  prev <- ifelse (
    is.null(prevalence),
    sum(tabble_init[, positive]) / sum(tabble_init),
    prevalence
  )

  if (is.null(prevalence))
    prevalence <- sum(tabble_init[, positive]) / sum(tabble_init)


  # Calculate PPV/NPV -------------------------------------------------------

  ppv =
    (sens * prevalence) /
    ((sens * prevalence) + ((1 - spec) *(1 - prevalence)))

  npv =
    (spec * (1 - prevalence)) /
    (((1 - sens) * prevalence) + ((spec) * (1 - prevalence)))


  # Calculate F1 ------------------------------------------------------------

  f1 = 2/(1/sens + 1/ppv)


  # Return result -----------------------------------------------------------

  dplyr::tibble(
    `Sensitivity/Recall/TPR` = sens,
    `Specificity/TNR` = spec,
    `PPV/Precision` = ppv,
    `NPV` = npv,
    `F1/Dice` = f1,
    `Prevalence` = prev,
    `Detection Rate` = detection_rate,
    `Detection Prevalence` = detection_prevalence,
    `Balanced Accuracy` = (sens + spec)/2
  )
}
