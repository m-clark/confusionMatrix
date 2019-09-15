#' Calculate various statistics from a confusion matrix
#'
#' @description Given a vector of predictions and observed values, calculate
#'   numerous statistics of interest.
#' @param prediction A vector of predictions
#' @param observed A vector of observed values
#' @param return_table Logical. Whether to return the table of \code{prediction}
#'   vs. \code{observed.} Default is \code{FALSE}.
#' @param dnn The row and column headers for the table returned by \code{return_table}.
#' @param positive The positive class. Default is \code{NULL}.
#' @param prevalence Prevalance rate.  Default is \code{NULL}.
#' @param ... Other parameters, not currently used.
#'
#' @details This returns accuracy, agreement, and other statistics. See the functions below to find out more.
#'
#' @seealso \code{\link{calc_accuracy}} \code{\link{calc_agreement}} \code{\link{calc_stats}}
#'
#' @return A (list of) tibble(s) with the associated statistics and possibly the frequency table.
#' @importFrom dplyr mutate everything %>%
#' @examples
#' p = c(0,1,1,0)
#' o = c(0,1,1,1)
#' out = confusion_matrix(p, o, return_table = TRUE)
#'
#' set.seed(1234)
#' p = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#' o = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#' out = confusion_matrix(p, o, return_table = TRUE)
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
  class_pred = class(prediction)
  class_obs = class(observed)

  if (class_pred != class_obs) {
    # put trycatch here to see if coercible?
  }

  init = data.frame(prediction, observed) %>%
    dplyr::mutate_if(is.logical, as.numeric) %>%
    dplyr::mutate_all(as.factor)


  # if (!is.factor(prediction) | !is.factor(observed)) {
  #   stop("`prediction` and `observed` should be factors with the same levels.",
  #        call. = FALSE)
  # }

  if (!is.character(positive) & !is.null(positive))
    stop("positive argument must be character")

  # if (length(levels(prediction)) > length(levels(observed)))
  #   stop("the prediction cannot have more levels than the observed")
  #
  # if (!any(levels(prediction) %in% levels(observed)))
  #   stop("The prediction must contain some levels that overlap the observed.")


  # if(!all(levels(prediction) %in% levels(observed))){
  #   badLevel <- levels(prediction)[!levels(prediction) %in% levels(observed)]
  #   if(sum(table(prediction)[badLevel]) > 0){
  #     stop("The prediction contains levels not found in the prediction.")
  #   } else{
  #     warning("The prediction contains levels not found in the prediction, but they are empty and will be dropped.")
  #     prediction <- factor(as.character(prediction))
  #   }
  # }

  if(any(levels(init$observed) != levels(init$prediction))) {
    warning("Levels are not in the same order for observed and prediction.
    \nRefactoring prediction to match. Some statistics may not be available.")

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
    stop("there must be at least 2 factors levels in the observed")

  if(numLevels == 2 & is.null(positive))  positive <- levels(observed)[1]

  # create confusion matrix
  conf_mat = table(prediction, observed, dnn = dnn)


  # Calculate stats ---------------------------------------------------------
  result_accuracy   = calc_accuracy(conf_mat)
  result_agreement  = calc_agreement(conf_mat)
  acc_agg = dplyr::bind_cols(
    # dplyr::tibble(`Positive Class` = positive),
    result_accuracy,
    result_agreement
  )

  if (numLevels == 2) {
    result_statistics = calc_stats(
      conf_mat,
      prevalence = prevalence,
      positive = positive
    )
    result = list(
      `Accuracy and Agreement` = acc_agg,
      Other = result_statistics
    )
  } else {
    result_statistics = lapply(classLevels, function(i) calc_stats(
        conf_mat,
        prevalence = prevalence,
        positive = i
      ))
    result_statistics = do.call(rbind, result_statistics)
    result_statistics = result_statistics %>%
      dplyr::mutate(Class = classLevels) %>%
      dplyr::select(Class, everything())

    result = list(
      `Accuracy and Agreement` = acc_agg,
      Other = result_statistics
    )
  }

  if (return_table) result$`Frequency Table` = conf_mat

  result
}
