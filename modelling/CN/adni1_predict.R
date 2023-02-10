library(mlr3)
library(mlr3learners)
library(mlr3extralearners)
library(mlr3tuning)
library(mlr3proba)
library(caret)
library(tidyverse)
library(RSurvivalML)

load("modelling/cn_adni1_aligned_survdeephit.RData")

cn_adni1 <- read.csv('data/cn_preprocessed_wo_csf_adni1.csv')

dummies <- dummyVars(last_DX ~., data = cn_adni1)
data_numeric <- predict(dummies, newdata= cn_adni1)
data_numeric <- as.data.frame(data_numeric)
data_numeric <-data.frame(cn_adni1$last_DX, data_numeric)
names(data_numeric)[1] <- 'last_DX'
data_numeric$X <- NULL

dat <- data_numeric

dat_part <- createDataPartition(y = dat$last_DX, times = 1,
                                p = 0.9, list = F)

training <- dat[dat_part,]
test <- dat[-dat_part,]

exp_dat1 <- list(training, test)
exp_dat_imp1 <- surv_imputation(exp_dat = exp_dat1, time_var = 'last_visit',
                               target_var = 'last_DX')
dat_train_imp <- as.data.frame(exp_dat_imp[1])
# train_stime <- data_numeric %>%
#   select(last_DX, last_visit)
#
# train_wo_time <- data_numeric %>%
#   select(-last_DX, -last_visit)
#
# train_na <- preProcess(as.data.frame(train_wo_time[, -1]),
#                        method = "knnImpute")
#
# dat_train <- predict(train_na, train_wo_time)
# dat_train <- cbind(dat_train, train_stime)
#
dat_train_imp$last_DX <- ifelse(dat_train_imp$last_DX == 'CN', 0, 1)
dat_train_imp[,"last_DX"] <- as.integer(dat_train_imp[,"last_DX"])

dat_testing <- dat_train_imp %>%
  select(-last_DX, -last_visit)


test_mlr3 <- as_task_surv(na.omit(dat_train_imp), id = 'adni1',
                           time = 'last_visit', event = 'last_DX')

learner$param_set$values
learner$predict(test_mlr3)

reticulate::py_discover_config(required_module = 'fuzzywuzzy')

measure <- msr("surv.cindex")

cn_adni1_predict <- measure$score(learner$predict(train_mlr3))
