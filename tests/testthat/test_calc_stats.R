context('test calc_stats')



# Setup -------------------------------------------------------------------

p = c(0, 1, 1, 0)
o = c(0, 1, 1, 1)

cm_simple = table(p, o)

cm_2class = table(
  sample(0:1, 250, replace = TRUE, prob = 1:2),
  sample(0:1, 250, replace = TRUE, prob = 1:2)
)

cm_multi = table(
  sample(letters[1:4], 250, replace = TRUE, prob = 1:4),
  sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
)



# Tests -------------------------------------------------------------------


test_that("calc_stats works", {
  expect_s3_class(calc_stats(cm_2class, positive = '1'), 'data.frame')
})

test_that("calc_stats works", {
  expect_s3_class(calc_stats(cm_multi, positive = 'a'), 'data.frame')
})

test_that("calc_stats errors on bad table", {
  expect_error(calc_stats(cm_multi[1, , drop = FALSE], positive = 'a'))
})

# not sure this should ever happen as predicted is forced to have same levels as
# observed
test_that("calc_stats errors on misordered table", {
  rownames(cm_2class) = c('1', '0')
  expect_error(calc_stats(cm_2class, positive = '1'))
})

# the following will result in normal quantiles for probs of 0 and 1, resulting
# in Inf
test_that("check d_prime edge case", {
  expect_warning(calc_stats(cm_simple, positive = '1'))
})



# test_that("calc_stats errors on misordered table", {
#   expect_error(calc_stats(cm_simple, positive = '1'))
# })

# test results ------------------------------------------------------------

test_that("confusion_matrix returns correct results for descriptives", {
  p_2class = sample(0:1, 250, replace = TRUE, prob = 1:2)
  o_2class = sample(0:1, 250, replace = TRUE, prob = 1:2)
  ns = colSums(table(p_2class, o_2class))
  tab = confusion_matrix(p_2class, o_2class, return_table = TRUE)

  # Ns
  expect_equal(tab$Other$N, sum(ns))
  expect_equivalent(tab$Other$`N Positive`, ns[1])
  expect_equivalent(tab$Other$`N Negative`, ns[2])
})

test_that("confusion_matrix returns correct results for descriptives", {

  # predictions from glm see helper file
  tab = calc_stats(table(predict_class, y), positive = '1')

  # Ns
  expect_lt(abs(tab$AUC - ys_auc$.estimate), .02)
  expect_lt(tab$AUC, psych_auc$AUC, 1e-3)
})
