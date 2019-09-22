context('test calc_agreement')

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


test_that("calc_agreement works", {
  expect_s3_class(calc_agreement(cm_simple), 'data.frame')
})

test_that("calc_agreement works", {
  expect_s3_class(suppressWarnings(calc_agreement(cm_multi)), 'data.frame')
})


# Check stat results ------------------------------------------------------


