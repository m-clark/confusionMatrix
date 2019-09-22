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

# predictions from glm see helper file
tab = calc_agreement(table(predict_class, y))

test_that("calc_agreement returns correct results for additional stats", {
  expect_lt(abs(tab$Kappa - psych_kappa_2class[['kappa']]), 1e-3)
  expect_lt(abs(tab$Kappa - e1071_rand_2class$kappa), 1e-3)
  expect_lt(abs(tab$Kappa - caret_stats$overall['Kappa']), 1e-3)

  expect_lt(abs(tab$Phi - psych_phi_2class), 1e-3)

  expect_lt(abs(tab$Yule - psych_yule_2class), 1e-3)

  expect_lt(abs(tab$`Corrected Rand` - e1071_rand_2class$crand), 1e-3)
})
