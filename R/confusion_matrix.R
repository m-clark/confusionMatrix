#' Calculate various statistics from a confusion matrix
#'
#' @description Given a vector of predictions and target values, calculate
#'   numerous statistics of interest.
#' @param prediction A vector of predictions
#' @param target A vector of target values
#' @param positive The positive class for a 2-class setting. Default is
#'   \code{NULL}, which will result in using the first level of \code{target}.
#' @param prevalence Prevalence rate.  Default is \code{NULL}.
#' @param return_table Logical. Whether to return the table of \code{prediction}
#'   vs. \code{target.} Default is \code{FALSE}. Cannot have both
#'   \code{return_table} and \code{longer} TRUE.
#' @param dnn The row and column headers for the table returned by
#' \code{return_table}.  Default is 'Predicted' for rows and 'Target' for
#' columns.
#' @param longer Transpose the output to long form.  Default is FALSE (requires
#'   \code{tidyr 1.0}).  Cannot have both \code{return_table} and \code{longer}
#'   TRUE.
#' @param ... Other parameters, not currently used.
#'
#' @details This returns accuracy, agreement, and other statistics. See the
#'   functions below to find out more. Originally inspired by the
#'   \code{confusionMatrix} function from the \code{caret} package.
#'
#' @seealso \code{\link[caret]{confusionMatrix}}  \code{\link{calc_accuracy}}
#'   \code{\link{calc_agreement}} \code{\link{calc_stats}}
#'
#' @return A list of tibble(s) with the associated statistics and possibly the
#'   frequency table as list column of the first element.
#'
#' @references Kuhn, M., & Johnson, K. (2013). Applied predictive modeling.
#'
#' @importFrom dplyr mutate everything %>%
#' @importFrom utils packageVersion
#'
#' @examples
#' library(confusionMatrix)
#'
#' p = c(0,1,1,0,0,1,0,1,1,1)
#' o = c(0,1,1,1,0,1,0,1,0,1)
#'
#' confusion_matrix(p, o, return_table = TRUE, positive = '1')
#'
#' p = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#' o = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#'
#' confusion_matrix(p, o, return_table = TRUE)
#'
#' @export
confusion_matrix <- function(
  prediction,
  target,
  positive = NULL,
  prevalence = NULL,
  return_table = FALSE,
  dnn = c('Predicted', 'Target'),
  longer = FALSE,
  ...
) {

  # Initial Checks ----------------------------------------------------------


  # input checks
  if (!is.character(positive) & !is.null(positive))
    stop("Positive argument must be character")

  if (!is.null(prevalence) &&
      (prevalence < 0 | prevalence > 1 | !is.numeric(prevalence)))
    stop('Prevalence should be a value between 0 and 1')

  if (!is.character(dnn) | length(dnn) != 2)
    stop('dnn should be a character vector of length 2')

  if (!is.logical(return_table))
    stop('return_table should be TRUE or FALSE')

  if (!is.logical(longer))
    stop('longer should be TRUE or FALSE')


  # other checks

  class_pred <- class(prediction)
  class_obs  <- class(target)

  init <- data.frame(prediction, target) %>%
    dplyr::mutate_if(is.logical, as.numeric) %>%
    dplyr::mutate_all(as.factor)

  if (class_pred != class_obs) {
    # put trycatch here to see if coercible?
  }

  if (any(levels(init$target) != levels(init$prediction))) {
    warning(
      "Levels are not the same for target and prediction.
    \nRefactoring prediction to match. Some statistics may not be available."
    )

    init <- init %>%
      dplyr::mutate(prediction = factor(prediction, levels = levels(target)))
  }

  prediction <- init$prediction
  target   <- init$target

  # changed focus to be on target levels; prediction can have a single class
  # without failure.
  classLevels <- levels(target)
  numLevels   <- length(classLevels)

  if(numLevels < 2)
    stop("There must be at least 2 factors levels in the target")

  if(!is.null(positive) && !positive %in% classLevels)
    stop("Positive is not among the class levels of the target")

  if(numLevels == 2 & is.null(positive))  positive <- levels(target)[1]

  # create confusion matrix

  conf_mat <- table(prediction, target, dnn = dnn)


  # Calculate stats ---------------------------------------------------------

  result_accuracy   <- calc_accuracy(conf_mat)
  result_agreement  <- calc_agreement(conf_mat)
  # acc_agg = dplyr::bind_cols(
  #   result_accuracy,
  #   result_agreement
  # )

  if (numLevels == 2) {
    result_statistics <- calc_stats(
      conf_mat,
      prevalence = prevalence,
      positive = positive
    )

    result_statistics <- result_statistics %>%
      dplyr::mutate(
        N = sum(conf_mat),
        Positive = positive,
        `N Positive` = sum(conf_mat[, positive]),
        `N Negative` = N-`N Positive`
      )

    result_statistics <- result_statistics %>%
      dplyr::select(Positive, N, `N Positive`, `N Negative`, everything())

    result <- list(
      Accuracy = result_accuracy,
      Other = result_statistics,
      `Association and Agreement` = result_agreement
    )
  } else {
    result_statistics <- lapply(
      classLevels,
      function(i) calc_stats(
        conf_mat,
        prevalence = prevalence,
        positive = i
      )
    )

    result_statistics <- dplyr::bind_rows(result_statistics) %>%
      mutate(N = colSums(conf_mat))

    # add averages
    avg <- data.frame(t(colMeans(result_statistics)))

    colnames(avg) <- colnames(result_statistics)

    result_statistics <- result_statistics %>%
      dplyr::bind_rows(avg)

    result_statistics <- result_statistics %>%
      dplyr::mutate(Class = c(classLevels, 'Average')) %>%
      dplyr::select(Class, N, everything())

    result <- list(
      Accuracy = result_accuracy,
      Other = result_statistics,
      `Association and Agreement` = result_agreement
    )
  }

  if (return_table)
    if (longer) {
      warning('Cannot have longer and return_table (table is not numeric). Removing table.')
    } else {
      result$Accuracy$`Frequency Table` <- list(conf_mat)
    }


  # Return result -----------------------------------------------------------

  # Note, can remove version check after a while
  test_tidyr <- tryCatch(utils::packageVersion("tidyr"), error = function(c) "error")

  test_tidyr_installed <- inherits(test_tidyr, 'error')

  if (!test_tidyr_installed)
    tidyr_version <- as.numeric(substr(test_tidyr, start = 1, stop = 1))

  if (longer & (test_tidyr_installed | tidyr_version < 1)) {
    message('Tidyr >= 1.0 not installed. longer argument ignored.')
    longer <- FALSE
  }

  if (longer) {
    result$Accuracy = tidyr::pivot_longer(
      result$Accuracy,
      cols = everything(),
      names_to = 'Statistic',
      values_to = 'Value',
    )

    if (numLevels == 2) {
      result$Other = tidyr::pivot_longer(
        result$Other,
        cols = -Positive,
        names_to = 'Statistic',
        values_to = 'Value',
      )
    }
    else {
      result$Other = tidyr::pivot_longer(
        result$Other,
        cols = -Class,
        names_to = 'Statistic',
        values_to = 'Value',
      )
    }


    result$`Association and Agreement` = tidyr::pivot_longer(
      result$`Association and Agreement`,
      cols = everything(),
      names_to = 'Statistic',
      values_to = 'Value',
    )
  }

  result
}
