calc_ppv_npv <- function (
  sens,
  spec,
  prevalence = NULL,
  ...
  ) {
  if (is.null(prevalence))
    prevalence <- sum(data[, positive]) / sum(data)

  ppv =
    (sens * prevalence) /
    ((sens * prevalence) + ((1 - spec) *(1 - prevalence)))

  npv =
    (spec * (1 - prevalence)) /
    (((1 - sens) * prevalence) + ((spec) * (1 - prevalence)))

  data.frame(ppv, npv)
}
