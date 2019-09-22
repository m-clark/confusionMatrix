context('test calc_accuracy')

p = c(0, 1, 1, 0)
o = c(0, 1, 1, 1)

cm_1 = calc_accuracy(table(p, o))

p = c(0, 0, 0, 0)
o = c(1, 0, 1, 1)

cm_2 = calc_accuracy(table(p, o))

# note to add test for completely missing. probably okay for confusion_matrix,
# which will create table correctly, even if not correct output for
# calc_accuracy here

# currently not clear when try-error should pop up. Perhaps remove check doesn't
# hurt anything. Perhaps ignore those lines for covr.

cm_3 = as.table(matrix(c(0,5,2,0), 2, 2))

test_that("calc_accuracy works", {
  expect_s3_class(cm_1, 'data.frame')
})

test_that("calc_accuracy is correct", {
  expect_equal(cm_1$Accuracy, .75)
})

test_that("calc_accuracy can handle unusual situation", {
  expect_s3_class(cm_1, 'data.frame')
})



# test ridiculous result -----------------------------------

test_that("calc_accuracy perfectly wrong prediction", {
  p = c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1)
  o = c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0)
  expect_s3_class(suppressWarnings(confusion_matrix(p, o))[[1]], 'data.frame')
})

test_that("calc_accuracy perfect prediction", {
  p = c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1)
  o = p
  expect_s3_class(suppressWarnings(confusion_matrix(p, o))[[1]], 'data.frame')
})

# Check stat results ------------------------------------------------------

# predictions from glm see helper file
tab = calc_accuracy(table(predict_class, y))

test_that("calc_agreement returns correct results for additional stats", {
  expect_lt(abs(tab$Accuracy - caret_stats$overall['Accuracy']), 1e-3)
  expect_lt(abs(tab$`Accuracy LL` - caret_stats$overall['AccuracyLower']), 1e-3)
  expect_lt(abs(tab$`Accuracy UL` - caret_stats$overall['AccuracyUpper']), 1e-3)
  expect_lt(abs(tab$`Accuracy Guessing` - caret_stats$overall['AccuracyNull']), 1e-3)
  expect_lt(abs(tab$`Accuracy P-value` - caret_stats$overall['AccuracyPValue']), 1e-3)
})
