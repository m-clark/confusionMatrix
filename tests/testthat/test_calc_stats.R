context('test calc_stats')

p = c(0, 1, 1, 0)
o = c(0, 1, 1, 1)

ca_simple = table(p, o)

ca_multi = table(
  sample(letters[1:4], 250, replace = TRUE, prob = 1:4),
  sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
)


test_that("calc_stats works", {
  expect_s3_class(calc_stats(ca_simple, positive = '1'), 'data.frame')
})

test_that("calc_stats works", {
  expect_s3_class(calc_stats(ca_multi, positive = 'a'), 'data.frame')
})

test_that("calc_stats errors on bad table", {
  expect_error(calc_stats(ca_multi[1, , drop = FALSE], positive = 'a'))
})

# not sure this should ever happen as predicted is forced to have same levels as
# observed
test_that("calc_stats errors on misordered table", {
  rownames(ca_simple) = c('1', '0')
  expect_error(calc_stats(ca_simple, positive = '1'))
})

# test_that("calc_stats errors on misordered table", {
#   expect_error(calc_stats(ca_simple, positive = '1'))
# })
