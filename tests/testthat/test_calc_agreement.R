context('test calc_agreement')

p = c(0, 1, 1, 0)
o = c(0, 1, 1, 1)

ca_simple = table(p, o)

ca_multi = table(
  sample(letters[1:4], 250, replace = TRUE, prob = 1:4),
  sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
)


test_that("calc_agreement works", {
  expect_s3_class(calc_agreement(ca_simple), 'data.frame')
})

test_that("calc_agreement works", {
  expect_s3_class(calc_agreement(ca_multi), 'data.frame')
})

test_that("match names works", {
  expect_s3_class(calc_agreement(ca_multi, match.names = TRUE), 'data.frame')
})
