#' Calculate Accuracy
#'
#' @description Calculates accuracy and related metrics.
#'
#' @param tabble A frequency table created with \code{\link{table}}
#'
#' @details Calculates accuracy, lower and upper bounds, the guessing rate and
#'   p-value of the accuracy vs. the guessing rate. This function is called by
#'   \code{confusion_matrix}, but if this is all you want, you can simply supply
#'   the table to this function.
#'
#' @return A tibble with the corresponding statistics
#'
#' @seealso \code{\link{binom.test}}
#'
#' @examples
#' p = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#' o = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
#' calc_accuracy(table(p, o))
#'
#' @importFrom stats binom.test
#'
#' @export
calc_accuracy <- function(tabble) {

  acc <- sum(diag(tabble))/sum(tabble)

  acc_ci <-
    try(
      stats::binom.test(sum(diag(tabble)), sum(tabble))$conf.int,
      silent = TRUE
    )

  if(inherits(acc_ci, "try-error"))
    acc_ci <- rep(NA, 2)

  acc_p <- try(
    stats::binom.test(
      sum(diag(tabble)),
      sum(tabble),
      p = max(colSums(tabble)/sum(tabble)),
      alternative = "greater"
    ),
    silent = TRUE)

  if (inherits(acc_p, "try-error"))
    acc_p <- c("null.value.probability of success" = NA, p.value = NA)
  else
    acc_p <- unlist(acc_p[c("null.value", "p.value")])

  tibble(
    Accuracy = acc,
    `Accuracy LL` = acc_ci[1],
    `Accuracy UL` = acc_ci[2],
    `Accuracy Guessing` = acc_p[1],
    `Accuracy P-value` = acc_p[2]
  )
}
