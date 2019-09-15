# from sensitivity.table, specificity.table
calc_stats <- function(tabble, prevalence = NULL, positive, ...) {
  # checks
  if (!all.equal(nrow(tabble), ncol(tabble)))
    stop("the table must have nrow = ncol")

  if (!all.equal(rownames(tabble), colnames(tabble)))
    stop("the table must the same groups in the same order")

  tabble_init = tabble
  # positive = rownames(tabble)[1]
  negative = rownames(tabble)[rownames(tabble) != positive]

  prev <- ifelse (
    is.null(prevalence),
    sum(tabble_init[, positive]) / sum(tabble_init),
    prevalence
    )


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
  }

  numer <- sum(tabble[pos, pos])
  denom <- sum(tabble[, pos])
  sens <- ifelse(denom > 0, numer/denom, NA)
  detection_rate = sum(tabble[pos, pos])/sum(tabble)
  detection_prevalence = sum(tabble[pos, ])/sum(tabble)

  # Calculate Specificity ---------------------------------------------------

  # if (nrow(tabble_init) > 2) {
  #   tmp <- tabble_init
  #   tabble <- matrix(NA, 2, 2)
  #   colnames(tabble) <- rownames(tabble) <- c("pos", "neg")
  #   negCol <- which(colnames(tmp) %in% negative)
  #   posCol <- which(!(colnames(tmp) %in% negative))
  #   tabble[1, 1] <- sum(tmp[posCol, posCol])
  #   tabble[1, 2] <- sum(tmp[posCol, negCol])
  #   tabble[2, 1] <- sum(tmp[negCol, posCol])
  #   tabble[2, 2] <- sum(tmp[negCol, negCol])
  #   tabble <- as.table(tabble)
  #   neg <- "neg"
  #   rm(tmp)
  # }

  numer <- sum(tabble[neg, neg])
  denom <- sum(tabble[, neg])
  spec <- ifelse(denom > 0, numer/denom, NA)

  if (is.null(prevalence))
    prevalence <- sum(tabble_init[, positive]) / sum(tabble_init)

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
    `F1/Dice` = f1,
    `Prevalence` = prev,
    `Detection Rate` = detection_rate,
    `Detection Prevalence` = detection_prevalence,
    `Balanced Accuracy` = (sens + spec)/2
  )
}
