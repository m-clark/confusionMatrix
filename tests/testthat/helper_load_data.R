# set.seed(1234)
#
# N = 10000
# x = rnorm(N)
# lp = 0 + .5*x
# y = factor(rbinom(N, size = 1, prob = plogis(lp)))
#
# predict_class = factor(as.integer(predict(glm(y ~ x, family = binomial)) > 0))
# predict_prob = predict(glm(y ~ x, family = binomial), type = 'response')
#
# ys_auc = yardstick::roc_auc(data.frame(estimate=predict_class, truth = y, prob=predict_prob), truth, prob)
# psych_auc = psych::AUC(table(y, predict_class)[2:1,2:1], plot = F) # note order change for psych
# save(
#   predict_class,
#   y,
#   ys_auc,
#   psych_auc,
#   file = 'tests/testthat/auc.RData'
# )

load('auc.RData')


