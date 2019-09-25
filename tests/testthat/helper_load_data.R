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
# caret_stats = caret::confusionMatrix(predict_class, y, positive = '1')
# psych_auc = psych::AUC(table(y, predict_class)[2:1,2:1], plot = F) # note order change for psych
# psych_kappa_2class = psych::wkappa(table(y, predict_class)[2:1,2:1])
# psych_phi_2class = psych::phi(table(y, predict_class)[2:1,2:1])
# psych_yule_2class = psych::Yule(table(y, predict_class)[2:1,2:1])
# e1071_rand_2class = e1071::classAgreement(table(predict_class, y))
#
# # multiclass
#
# caret_multiclass = caret::confusionMatrix(
#   factor(sample(letters[1:4], 250, replace = TRUE, prob = 1:4)),
#   factor(sample(letters[1:4], 250, replace = TRUE, prob = 1:4))
# )
#
#
#
# save(
#   predict_class,
#   y,
#   caret_stats,
#   caret_multiclass,
#   ys_auc,
#   psych_auc,
#   psych_kappa_2class,
#   psych_phi_2class,
#   psych_yule_2class,
#   e1071_rand_2class,
#   file = 'tests/testthat/auc.RData'
# )

load('auc.RData')


