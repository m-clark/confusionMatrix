context('test confusion_matrix')

p_simple = c(0, 1, 1, 0)
o_simple = c(0, 1, 1, 1)

p_multi = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
o_multi = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)

# TODO: add check for prediction missing a class

test_that("confusion_matrix works", {
  ca = confusion_matrix(p_simple, o_simple)
  expect_is(ca, 'list')
  expect_s3_class(ca[[1]], 'data.frame')
})

test_that("confusion_matrix works", {
  ca = confusion_matrix(p_multi, o_multi)
  expect_is(ca, 'list')
  expect_s3_class(ca[[1]], 'data.frame')
})


test_that("confusion_matrix errors with wrong input: positive", {
  expect_error(confusion_matrix(p_multi, o_multi, positive = 1))
})

test_that("confusion_matrix warns with prediction/observed mismatched levels", {
  p = c(1, 1, 1, 1)
  o = c(0, 1, 1, 1)
  expect_warning(confusion_matrix(p, o))
})

test_that("confusion_matrix errors if only one observed class", {
  p = c(0, 1, 1, 1)
  o = c(1, 1, 1, 1)
  expect_error(confusion_matrix(p, o))
})


test_that("confusion_matrix returns table", {
  expect_is(
    confusion_matrix(p_simple, o_simple, return_table = TRUE)$`Frequency Table`,
    'table'
    )
})
