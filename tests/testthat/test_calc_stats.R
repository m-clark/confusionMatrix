

#
tabble = table(
  sample(letters[1:2], 250, replace = T, prob = 1:2),
  sample(letters[1:2], 250, replace = T, prob = 1:2)
)

calc_stats(
  tabble,
  positive = 'a',
  verbose = T,
  return_table = T
)
