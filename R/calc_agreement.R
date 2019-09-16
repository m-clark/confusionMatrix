#' Coefficients comparing classification agreement
#'
#' @description   Computes several coefficients of agreement between the columns
#'   and rows of a 2-way contingency table. Most of the documentation for this
#'   function is copied directly from the \code{matchClasses} function
#'   documentation.
#'
#' @param tabble A 2-dimensional contingency table created with \code{\link{table}}.
#' @param match.names Flag whether row and columns should be matched by name.
#'
#' @details  Suppose we want to compare two classifications summarized by the
#'   contingency table \eqn{T=[t_{ij}]} where \eqn{i,j=1,\ldots,K} and
#'   \eqn{t_{ij}} denotes the number of data points which are in class \eqn{i}
#'   in the first partition and in class \eqn{j} in the second partition. If
#'   both classifications use the same labels, then obviously the two
#'   classification agree completely if only elements in the main diagonal of
#'   the table are non-zero. On the other hand, large off-diagonal elements
#'   correspond to smaller agreement between the two classifications. If
#'   \code{match.names} is \code{TRUE}, the class labels as given by the row and
#'   column names are matched, i.e. only columns and rows with the same dimnames
#'   are used for the computation.
#'
#'   If the two classification do not use the same set of labels, or if
#'   identical labels can have different meaning (e.g., two outcomes of cluster
#'   analysis on the same data set), then the situation is a little  bit more
#'   complicated. Let \eqn{A} denote the number of all pairs of data  points
#'   which are either put into the same cluster by both partitions or put into
#'   different clusters by both partitions. Conversely, let \eqn{D}  denote the
#'   number of all pairs of data points that are put into one cluster in one
#'   partition, but into different clusters by the other partition.  Hence, the
#'   partitions disagree for all pairs \eqn{D} and agree for all pairs \eqn{A}.
#'   We can measure the agreement by the Rand index \eqn{A/(A+D)} which is
#'   invariant with respect to permutations of the columns or rows of \eqn{T}.
#'
#'   Both indices have to be corrected for agreement by chance if the sizes  of
#'   the classes are not uniform.
#'
#' @return A tibble with:
#' \item{kappa}{\code{diag} corrected for agreement by chance.}
#' \item{crand}{Rand index corrected for agreement by chance.}
#'
#' @references
#' Cohen. J. A coefficient of agreement for nominal scales. Educational and Psychological Measurement, 20, 37--46, 1960.
#'
#' Lawrence Hubert and Phipps Arabie. Comparing partitions. Journal of Classification, 2, 193--218, 1985.
#'
#' @seealso \code{\link[e1071]{matchClasses}}
#'
#' @author  Friedrich Leisch
#'
#'
#' @examples
#'  ## no class correlations: both kappa and crand almost zero
#'  g1 <- sample(1:5, size=1000, replace=TRUE)
#'  g2 <- sample(1:5, size=1000, replace=TRUE)
#'  tabble <- table(g1, g2)
#'  calc_agreement(tabble)
#'
#'  ## let pairs (g1=1,g2=1) and (g1=3,g2=3) agree better
#'  k <- sample(1:1000, size=200)
#'  g1[k] <- 1
#'  g2[k] <- 1
#'
#'  k <- sample(1:1000, size=200)
#'  g1[k] <- 3
#'  g2[k] <- 3
#'
#'  tabble <- table(g1, g2)
#'  ## both kappa and crand should be significantly larger than before
#'  calc_agreement(tabble)
#'
#' @importFrom dplyr tibble
#'
#' @export
calc_agreement <- function(tabble, match.names = FALSE) {
  # sum, rowsums, colsums
  n  <- sum(tabble)
  ni <- rowSums(tabble)
  nj <- colSums(tabble)


  # Calculate necessary quantities ------------------------------------------

  if (match.names && !is.null(dimnames(tabble))) {
    lev <- intersect(colnames(tabble), rownames(tabble))
    p0  <- sum(diag(tabble[lev, lev])) / n
    pc  <- sum(ni[lev] * nj[lev]) / n ^ 2
  }
  else {
    m  <- min(length(ni), length(nj))
    p0 <- sum(diag(tabble[1:m, 1:m])) / n
    pc <- sum((ni[1:m] / n) * (nj[1:m] / n))
  }


  # Calculate Rand ----------------------------------------------------------

  # rand index (not returned as not very useful)
  n2   <- choose(n, 2)

  rand <- 1 + (sum(tabble ^ 2) - (sum(ni ^ 2) + sum(nj ^ 2)) / 2) / n2

  # rand index corrected for chance
  nis2  <- sum(choose(ni[ni > 1], 2))
  njs2  <- sum(choose(nj[nj > 1], 2))

  crand <- (sum(choose(tabble[tabble > 1], 2)) - (nis2 * njs2) / n2) /
    ((nis2 + njs2) / 2 - (nis2 * njs2) / n2)


  # Return result -----------------------------------------------------------
  dplyr::tibble(
    # accuracy = p0,
    Kappa = (p0 - pc) / (1 - pc),
    # rand = rand,
    `Corrected Rand` = crand
  )
}
