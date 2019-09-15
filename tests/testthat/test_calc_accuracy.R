context('test calc_accuracy')

p = c(0, 1, 1, 0)
o = c(0, 1, 1, 1)

ca_1 = calc_accuracy(table(p, o))

p = c(0, 0, 0, 0)
o = c(1, 0, 1, 1)

ca_2 = calc_accuracy(table(p, o))

# note to add test for completely missing. probably okay for confusion_matrix,
# which will create table correctly, even if not correct output for
# calc_accuracy here

# currently not clear when try-error should pop up. Perhaps remove check doesn't
# hurt anything. Perhaps ignore those lines for covr.

ca_3 = as.table(matrix(c(0,5,2,0), 2, 2))

test_that("calc_accuracy works", {
  expect_s3_class(ca_1, 'data.frame')
})

test_that("calc_accuracy is correct", {
  expect_equal(ca_1$Accuracy, .75)
})

test_that("calc_accuracy can handle unusual situation", {
  expect_s3_class(ca_1, 'data.frame')
})
