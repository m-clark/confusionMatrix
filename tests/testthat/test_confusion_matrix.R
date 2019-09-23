context('test confusion_matrix')

set.seed(1234)

p_simple = c(0, 1, 1, 0)
o_simple = c(0, 1, 1, 1)

p_2class = sample(letters[1:2], 250, replace = TRUE, prob = 1:2)
o_2class = sample(letters[1:2], 250, replace = TRUE, prob = 1:2)

p_multi = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
o_multi = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)

# TODO: add check for prediction missing a class


# basic output ------------------------------------------------------------

test_that("confusion_matrix works", {
  cm = confusion_matrix(p_2class, o_2class)
  expect_is(cm, 'list')
  expect_s3_class(cm[[1]], 'data.frame')
})

test_that("confusion_matrix works", {
  cm = confusion_matrix(p_2class, o_2class)
  expect_is(cm, 'list')
  expect_s3_class(cm[[1]], 'data.frame')
})


# dealing with positive argument ------------------------------------------

test_that("confusion_matrix takes positive argument", {
  cm = suppressWarnings(confusion_matrix(p_simple, o_simple, positive = '0'))
  expect_identical(cm$Other$`Sensitivity/Recall/TPR`, 1)
})

test_that("confusion_matrix errors with wrong input: positive", {
  expect_error(confusion_matrix(p_2class, o_2class, positive = 1))
})


# test class levels -------------------------------------------------------


test_that("confusion_matrix warns with prediction/target mismatched levels", {
  p = c(1, 1, 1, 1)
  o = c(0, 1, 1, 1)
  expect_warning(confusion_matrix(p, o))
})




test_that("confusion_matrix can handle different level pred/obs", {
  p_multi_relevel = factor(p_multi, levels = letters[4:1])
  p_multi_relevel2 = factor(p_multi, levels = letters[1:4])
  cm_relevel = suppressWarnings(
    confusion_matrix(p_multi_relevel, o_multi, return_table = TRUE)
    )
  cm = suppressWarnings(
    confusion_matrix(p_multi_relevel2, o_multi, return_table = TRUE)
  )

  expect_identical(cm_relevel$`Frequency Table`, cm$`Frequency Table`)
})

# test numeric classes ----------------------------------------------------

test_that("confusion_matrix can handle logical/numeric mix", {
  o_logical = c(FALSE, TRUE, TRUE, TRUE)
  expect_is(suppressWarnings(confusion_matrix(p_simple, o_logical)), 'list')
})


# return table ------------------------------------------------------------

test_that("confusion_matrix returns table", {
  tab = confusion_matrix(p_2class, o_2class, return_table = TRUE)
  tab = tab$`Accuracy`$`Frequency Table`

  expect_is(tab[[1]], 'table')
})


# Will error on incorrect input -------------------------------------------

test_that("confusion_matrix errors if only one target class", {
  p = c(0, 1, 1, 1)
  o = c(1, 1, 1, 1)
  expect_error(suppressWarnings(confusion_matrix(p, o)))
})

test_that("confusion_matrix errors if positive class doesn't exist", {
  expect_error(confusion_matrix(p_2class, o_2class, positive = 'C'))
})




# Test longer -------------------------------------------------------------

# Need to update if statistics are added

test_that("confusion_matrix returns longer tibble", {
  cm <- confusion_matrix(p_2class, o_2class, positive = 'a', longer = TRUE)
  expect_equal(
    nrow(cm$Accuracy),
    5
  )
  expect_equal(
    nrow(cm$Other),
    18
  )
  expect_equal(
    nrow(cm$`Association and Agreement`),
    6
  )
})

test_that("confusion_matrix returns longer tibble", {
  cm <- suppressWarnings(confusion_matrix(p_multi, o_multi, positive = 'a', longer = TRUE))

  expect_equal(
    nrow(cm$Other),
    80
  )
  expect_equal(
    dplyr::n_distinct(cm$Other$Class),
    5
  )
})

test_that("confusion_matrix warns if longer and return_table both TRUE", {

  expect_warning(
    confusion_matrix(
      p_2class,
      o_2class,
      positive = 'a',
      return_table = TRUE,
      longer = TRUE
    )
  )
})


# # test_that("confusion_matrix can handle logical/character mix", {
#   o_logical = c(FALSE, TRUE, TRUE, TRUE)
#   p_char = c('a', 'a', 'b', 'b')
#   expect_is(confusion_matrix(p_char, o_logical), 'list')
# # })

# TODO: Add error for char/fac vs. numeric/logical (better) or add fancy relabeling of predictor (asking for trouble)


