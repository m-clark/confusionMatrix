library(tidyverse)

# debugonce(confusion_matrix)

library(dplyr)
confusion_matrix(
  c(0,1,1,0),
  c(0,1,1,1),
  dnn = c('pred', 'obs'),
  verbose = T,
  return_table = T
)
confusion_matrix(
  prediction = c(1,1,1,1),
  observed = c(0,1,1,1),
  dnn = c('pred', 'obs'),
  verbose = T,
  return_table = T
)

out

set.seed(1234)
# p = sample(letters[1:3], 250, replace = T, prob = 1:3)
p = sample(letters[1:4], 250, replace = T, prob = 1:4)
o = sample(letters[1:4], 250, replace = T, prob = 1:4)

out = confusion_matrix(
  p,
  o,
  verbose = T,
  return_table = T
)


out
out$Other
out$Other %>% select(Prevalence:`Balanced Accuracy`)
caret::confusionMatrix(factor(p), factor(o), mode='everything')
