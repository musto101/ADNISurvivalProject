library(RSurvivalML)
library(survival)

pre <- Sys.time()

dat <- read.csv('data/cn_preprocessed.csv')

dat$X <- NULL
dat$last_DX <- ifelse(dat$last_DX == 'CN', 0, 1)
table(dat$last_DX)

dat_list <- dat_splitter(dat = dat, perc = 0.8, 'last_DX')

dat_train <- data.frame(dat_list[1])

dat_train$last_DX <- as.numeric(dat_train$last_DX)

fit <- coxph(Surv(time = last_visit, event = last_DX) ~ .,
             data = dat_train) # fit cox proportional hazard model to train#

concordance(fit) # find cindex for train

test_dat <- data.frame(dat_list[2])
test_dat$last_DX <- as.numeric(test_dat$last_DX)

concordance(object = fit, newdata = na.omit(test_dat)) #find cindex for test#
