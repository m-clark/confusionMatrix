#' Calculate various statistics from a confusion matrix
#'
#' @description Given a vector of predictions and observed values, calculate
#'   numerous statistics of interest.
#' @param prediction A vector of predictions
#' @param observed A vector of observed values
#' @param return_table Logical. Whether to return the table of \code{prediction}
#'   vs. \code{observed.} Default is \code{FALSE}.
#' @param dnn The row and column headers for the table returned by
#'   \code{return_table}.
#' @param positive The positive class for a 2-class setting. Default is
#'   \code{NULL}, which will result in using the first level of \code{observed}.
#' @param prevalence Prevalance rate.  Default is \code{NULL}.
#' @param ... Other parameters, not currently used.
#'
#' @details This returns accuracy, agreement, and other statistics. See the
#'   functions below to find out more. Originally inspired and based on the
#'   \code{confusionMatrix} function from the \code{caret} package.
#'
#' @seealso \code{\link[caret]{confusionMatrix}}  \code{\link{calc_accuracy}}
#'   \code{\link{calc_agreement}} \code{\link{calc_stats}}
#'
#' @return A list of tibble(s) with the associated statistics and possibly the
#'   frequency table as list column of the first element.
#'
#' @references Kuhn, M., & Johnson, K. (2013). Applied predictive modeling. New
#'   York: Springer.
#'
#' @importFrom dplyr mutate everything %>%
#'
#' @examples
#' library(confusionMatrix)
#'
#' p = c(0,1,1,0)
#' o = c(0,1,1,1)
#'
#' confusion_matrix(p, o, return_table = TRUE)
#'
#' p = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#' o = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#'
#' confusion_matrix(p, o, return_table = TRUE)
#'
#' @export
confusion_matrix <- function(
  prediction,
  observed,
  return_table = FALSE,
  dnn = c('Predicted', 'Observed'),
  positive = NULL,
  prevalence = NULL,
  ...
) {

  # Initial Checks ----------------------------------------------------------

  class_pred = class(prediction)
  class_obs = class(observed)

  if (class_pred != class_obs) {
    # put trycatch here to see if coercible?
  }

  init = data.frame(prediction, observed) %>%
    dplyr::mutate_if(is.logical, as.numeric) %>%
    dplyr::mutate_all(as.factor)

  if (!is.character(positive) & !is.null(positive))
    stop("positive argument must be character")

  if (any(levels(init$observed) != levels(init$prediction))) {
    warning(
      "Levels are not the same for observed and prediction.
    \nRefactoring prediction to match. Some statistics may not be available."
    )

    init <- init %>%
      dplyr::mutate(prediction = factor(prediction, levels = levels(observed)))
  }

  prediction = init$prediction
  observed   = init$observed

  # changed focus to be on observed levels; prediction can have a single class
  # without failure.
  classLevels <- levels(observed)
  numLevels <- length(classLevels)

  if(numLevels < 2)
    stop("There must be at least 2 factors levels in the observed")

  if(!is.null(positive) && !positive %in% classLevels)
    stop("Positive is not among the class levels of the observed")

  if(numLevels == 2 & is.null(positive))  positive <- levels(observed)[1]

  # create confusion matrix

  conf_mat = table(prediction, observed, dnn = dnn)


  # Calculate stats ---------------------------------------------------------

  result_accuracy   = calc_accuracy(conf_mat)
  result_agreement  = calc_agreement(conf_mat)
  # acc_agg = dplyr::bind_cols(
  #   result_accuracy,
  #   result_agreement
  # )

  if (numLevels == 2) {
    result_statistics = calc_stats(
      conf_mat,
      prevalence = prevalence,
      positive = positive
    )

    result_statistics = result_statistics %>%
      dplyr::mutate(
        N = sum(conf_mat),
        Positive = positive,
        `N Positive` = sum(conf_mat[, positive]),
        `N Negative` = N-`N Positive`)

    result_statistics = result_statistics %>%
      dplyr::select(Positive, N, `N Positive`, `N Negative`, everything())

    result = list(
      `Accuracy and Agreement` = result_accuracy,
      Other = result_statistics,
      `Association and Agreement` = result_agreement
    )
  } else {
    result_statistics = lapply(
      classLevels,
      function(i) calc_stats(
        conf_mat,
        prevalence = prevalence,
        positive = i
      )
    )

    result_statistics = dplyr::bind_rows(result_statistics) %>%
      mutate(N = colSums(conf_mat))

    # add averages
    avg = data.frame(t(colMeans(result_statistics)))

    colnames(avg) = colnames(result_statistics)

    result_statistics <- result_statistics %>%
      dplyr::bind_rows(avg)

    result_statistics = result_statistics %>%
      dplyr::mutate(Class = c(classLevels, 'Average')) %>%
      dplyr::select(Class, N, everything())

    result = list(
      `Accuracy and Agreement` = result_accuracy,
      Other = result_statistics,
      `Association and Agreement` = result_agreement
    )
  }

  # if (return_table) result$`Frequency Table` = conf_mat
  if (return_table)
    result$`Accuracy and Agreement`$`Frequency Table` <- list(conf_mat)

  result
}
