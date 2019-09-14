calc_accuracy <- function(tabble) {
  sum(diag(tabble))/sum(tabble)
}


propCI <- function(tabble) {
  res <- try(binom.test(sum(diag(tabble)), sum(tabble))$conf.int, silent = TRUE)
  if(inherits(res, "try-error"))
    res <- rep(NA, 2)
  res
}

propTest <- function(tabble){
  res <- try(
    binom.test(
      sum(diag(tabble)),
      sum(tabble),
      p = matabble(colSums(tabble)/sum(tabble)),
      alternative = "greater"
    ),
    silent = TRUE)
  res <- if(inherits(res, "try-error"))
    c("null.value.probability of success" = NA, p.value = NA)
  else
    res <- unlist(res[c("null.value", "p.value")])
  res
}
