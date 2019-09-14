# from specificity.table in care
 calc_specificity <- function(data, negative = rownames(data)[-1], ...) {
  # checks
  if (!all.equal(nrow(data), ncol(data)))
    stop("the table must have nrow = ncol")

  if (!all.equal(rownames(data), colnames(data)))
    stop("the table must the same groups in the same order")

  if (nrow(data) > 2) {
    tmp <- data
    data <- matrix(NA, 2, 2)
    colnames(data) <- rownames(data) <- c("pos", "neg")
    negCol <- which(colnames(tmp) %in% negative)
    posCol <- which(!(colnames(tmp) %in% negative))
    data[1, 1] <- sum(tmp[posCol, posCol])
    data[1, 2] <- sum(tmp[posCol, negCol])
    data[2, 1] <- sum(tmp[negCol, posCol])
    data[2, 2] <- sum(tmp[negCol, negCol])
    data <- as.table(data)
    negative <- "neg"
    rm(tmp)
  }
  numer <- sum(data[negative, negative])
  denom <- sum(data[, negative])
  spec <- ifelse(denom > 0, numer/denom, NA)
  spec
}
