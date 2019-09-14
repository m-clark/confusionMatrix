# from sensitivity.table, specificity.table
calc_stats <- function(tabble, prevalence = NULL, positive, ...) {
  # checks
  if (!all.equal(nrow(tabble), ncol(tabble)))
    stop("the table must have nrow = ncol")

  if (!all.equal(rownames(tabble), colnames(tabble)))
    stop("the table must the same groups in the same order")

  # positive = rownames(tabble)[1]
  negative = rownames(tabble)[rownames(tabble) != positive]

  if (nrow(tabble) > 2) {
    tmp <- tabble
    tabble <- matrix(NA, 2, 2)
    colnames(tabble) <- rownames(tabble) <- c("pos", "neg")
    posCol <- which(colnames(tmp) %in% positive)
    negCol <- which(!(colnames(tmp) %in% positive))
    tabble[1, 1] <- sum(tmp[posCol, posCol])
    tabble[1, 2] <- sum(tmp[posCol, negCol])
    tabble[2, 1] <- sum(tmp[negCol, posCol])
    tabble[2, 2] <- sum(tmp[negCol, negCol])
    tabble <- as.table(tabble)
    positive <- "pos"
    rm(tmp)
  }

  # calc sensitivity
  numer <- sum(tabble[positive, positive])
  denom <- sum(tabble[, positive])
  sens <- ifelse(denom > 0, numer/denom, NA)

  # calc specificity
  numer <- sum(tabble[negative, negative])
  denom <- sum(tabble[, negative])
  spec <- ifelse(denom > 0, numer/denom, NA)

  if (is.null(prevalence))
    prevalence <- sum(tabble[, positive]) / sum(tabble)

  ppv =
    (sens * prevalence) /
    ((sens * prevalence) + ((1 - spec) *(1 - prevalence)))

  npv =
    (spec * (1 - prevalence)) /
    (((1 - sens) * prevalence) + ((spec) * (1 - prevalence)))

  f1 = 2/(1/sens + 1/ppv)

  tibble::tibble(
    `Sensitivity/Recall/TPR` = sens,
    `Specificity/TNR` = spec,
    `PPV/Precision` = ppv,
    `NPV` = npv,
    `F1/Dice` = f1
  )
}
