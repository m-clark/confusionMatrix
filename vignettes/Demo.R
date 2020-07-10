## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  fig.path = "man/figures/",
  comment = NA
)

## ----data-setup---------------------------------------------------------------
set.seed(1234)

N = 2500
x = rnorm(N)
lp = 0 + .5*x
y = rbinom(N, size = 1, prob = plogis(lp))

model = glm(y ~ x, family = binomial)
predict_class = predict(model) > 0

## ----basic--------------------------------------------------------------------
library(confusionMatrix)
confusion_matrix(predict_class, y)

## ----multi-class--------------------------------------------------------------
p_multi = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)
o_multi = sample(letters[1:4], 250, replace = TRUE, prob = 1:4)

confusion_matrix(p_multi, o_multi)

## ----wide---------------------------------------------------------------------
cm = confusion_matrix(predict_class, y)

cm[['Other']][['N']]
cm[['Association and Agreement']][['Yule']]

## ----longer-------------------------------------------------------------------
confusion_matrix(predict_class, y, longer = TRUE)

