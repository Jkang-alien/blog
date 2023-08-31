## @knitr library
library(tidyverse)
library(tidymodels)

## @knitr load
load('./RData/dataset_all_test.RData')

## @knitr tidymodel

library(glmnet)
library(themis)

set.seed(930093)
cv_splits <- rsample::vfold_cv(trainset_ahDiff, strata = PIK3CA_T)
mod <- logistic_reg(penalty = tune(),
                    mixture = tune()) %>%
  set_engine("glmnet")

rec <- recipe(PIK3CA_T ~ ., data = trainset_ahDiff) %>%
  step_BoxCox(all_numeric()) %>%
  step_dummy(HISTOLOGICAL_DIAGNOSIS) %>%
  step_center(all_numeric()) %>%
  step_scale(all_numeric()) %>%
  step_smote(PIK3CA_T)

## @knitr workflow

wfl <- workflow() %>%
  add_recipe(rec) %>%
  add_model(mod)

glmn_set <- parameters(penalty(range = c(-5,1), trans = log10_trans()),
                       mixture())

glmn_grid <- 
  grid_regular(glmn_set, levels = c(7, 5))
ctrl <- control_grid(save_pred = TRUE, verbose = TRUE)

## @knitr fitting

glmn_tune <- 
  tune_grid(wfl,
            resamples = cv_splits,
            grid = glmn_grid,
            metrics = metric_set(roc_auc),
            control = ctrl)


best_glmn <- select_best(glmn_tune, metric = "roc_auc")

## @knitr Finalize_model

wfl_final <- 
  wfl %>%
  finalize_workflow(best_glmn) %>%
  fit(data = trainset_ahDiff)


## @knitr trainset_prediction

train_predict <- stats::predict(wfl_final, type = "prob", new_data = trainset_ahDiff, penalty = 1)
train_probs <- 
  predict(wfl_final, type = "prob", new_data = trainset_ahDiff) %>%
  bind_cols(obs = trainset_ahDiff$PIK3CA_T) %>%
  bind_cols(predict(wfl_final, new_data = trainset_ahDiff))

## @knitr performance  

conf_mat(train_probs, obs, .pred_class)

autoplot(roc_curve(train_probs, obs, .pred_Mutant, event_level = "second"))

roc_auc(train_probs, obs, .pred_Mutant, event_level = "second")

## @knitr coefficiency

tidy(extract_model(wfl_final)) %>%
  filter(lambda > 0.98 & lambda < 1.01)
