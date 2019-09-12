confusion_matrix <- function(
  prediction,
  observed,
  return_table = FALSE,
  verbose = FALSE,
  ...
) {
  class_pred = class(prediction)
  class_obs = class(observed)

  if (class_pred != class_obs) {
    # put trycatch here to see if coercible
  }

  init = data.frame(prediction, observed) %>%
    dplyr::mutate_if(is.logical, as.numeric) %>%
    dplyr::mutate_all(as.factor)

  prediction = init$prediction
  observed = init$observed

  if (!is.factor(prediction) | !is.factor(observed)) {
    stop("`prediction` and `observed` should be factors with the same levels.",
         call. = FALSE)
  }

  result_0 = caret:::confusionMatrix.default(
    prediction,
    observed,
    mode = 'everything',
    ...
  )

  result_by_class = result_0$byClass
  result_overall = tibble::enframe(result_0$overall)

  # reorder so all accuracy stuff is together, at the beginning and dplyr::rename
  result_acc = result_overall %>%
    dplyr::filter(grepl(name, pattern = 'Accuracy')) %>%
    dplyr::mutate(name = dplyr::case_when(
      name == 'AccuracyLower' ~ 'Accuracy Lower',
      name == 'AccuracyUpper' ~ 'Accuracy Upper',
      name == 'AccuracyNull' ~ 'Accuracy Guessing',
      name == 'AccuracyPValue' ~ 'Accuracy P-value',
      TRUE ~ as.character(name)
    )
    )

  result_other = result_overall %>%
    dplyr::filter(!grepl(name, pattern = '^Accuracy')) %>%
    dplyr::mutate(name = dplyr::case_when(
      name == 'McnemarPValue' ~ 'Mcnemar P-value',
      TRUE ~ as.character(name)
    )
    )

  result_overall = dplyr::bind_rows(result_acc, result_other)

  if (nlevels(observed) == 2) {
    result_by_class = result_overall %>%
      dplyr::bind_rows(tibble::enframe(result_by_class)) %>%
      dplyr::rename(Statistic = name, Value = value)
    result = list(
      result = result_by_class,
      positive_class = result_0$positive
    )
  }
  else {
    result_by_class = result_by_class %>%
      as.data.frame() %>%
      tibble::rownames_to_column('class') %>%
      select(class, everything()) %>%
      as_tibble()

    result = list(
      result_by_class = result_by_class,
      result_overall = result_overall
    )
  }

  if (verbose) {
    print(result_by_class)
  }

  if (return_table) {
    result$table = result_0$table
    names(attr(result$table, 'dimnames'))[2] = 'Observed'
  }

  invisible(result)
}


library(tidyverse)

debugonce(confusion_matrix)

library(dplyr)
out = confusion_matrix(
  c(0,1,1,0),
  c(0,1,1,1),
  verbose = T,
  return_table = T
)

out

out = confusion_matrix(
  sample(letters[1:4], 250, replace = T, prob = 1:4),
  sample(letters[1:4], 250, replace = T, prob = 1:4),
  verbose = T,
  return_table = T
)

out
