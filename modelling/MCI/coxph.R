library(RSurvivalML)
library(survival)

pre <- Sys.time()

dat <- read.csv('data/mci_preprocessed.csv')

dat$X <- NULL
dat$last_DX <- ifelse(dat$last_DX == 'CN_MCI', 0, 1)
table(dat$last_DX)

dat_list <- dat_splitter(dat = dat, perc = 0.8, ext_dat = NULL, target = 'last_DX')

dat_train <- data.frame(dat_list[1])

dat_train$last_DX <- as.numeric(dat_train$last_DX)

fit <- coxph(Surv(time = last_visit, event = last_DX) ~ .,
             data = dat_train, model = TRUE, x = TRUE) # fit cox proportional hazard model to train#

concordance(fit) # find cindex for train

test_dat <- data.frame(dat_list[2])
test_dat$last_DX <- as.numeric(test_dat$last_DX)

concordance(object = fit, newdata = na.omit(test_dat)) #find cindex for test#

# cph_exp <- explain(fit)
#
# mp <- model_parts(cph_exp, loss = loss_one_minus_c_index,
#                   output_type = "risk")
# plot(mp)
#
# p_parts_shap <- predict_parts(cph_exp, dat_train[1, -c(1,2)], type = "survshap")
# plot(p_parts_shap)
