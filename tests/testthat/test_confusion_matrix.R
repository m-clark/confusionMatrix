library(tidyverse)

# debugonce(confusion_matrix)

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
