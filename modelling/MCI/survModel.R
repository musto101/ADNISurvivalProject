library(caret)
library(parallel)
library(doParallel)
library(RSurvivalML)
library(DMwR)

survModel <- function(dat, ext_dat, modType, clinGroup, grid, mcRep, perc) {

  if (clinGroup == 'CN') {

    dat$last_DX <- ifelse(dat$last_DX == 'CN', 0, 1)
    ext_dat$last_DX <- ifelse(ext_dat$last_DX == 'CN', 0, 1)

  } else if (clinGroup == 'MCI') {

    dat$last_DX <- ifelse(dat$last_DX == 'CN_MCI', 0, 1)
    ext_dat$last_DX <- ifelse(ext_dat$last_DX == 'CN_MCI', 0, 1)

  } else {
      stop('clinGroup not recognised')
    }

  mcPerf <- data.frame(c_index_train = numeric(), c_index_test = numeric())

  train_id = paste0(modType, '_train')
  test_id = paste0(modType, '_test')
  ext_id = paste0(modType, '_ext')

  ids = c(train_id, test_id, ext_id)

  cl <- makeCluster(detectCores())
  # cl <- makeCluster(7)
  registerDoParallel(cl)

  for (j in 1:mcRep) {

    print(j)

    # dat_part <- createDataPartition(y = dat$last_DX, times = 1,
    #                                 p = 0.8, list = F)
    #
    # training <- dat[dat_part,]
    # test <- dat[-dat_part,]
    #
    # exp_dat <- list(training, test)

    exp_dat <- dat_splitter(dat, ext_dat, perc, target = 'last_DX')

    exp_dat_imp <- surv_imputation(exp_dat = exp_dat, time_var = 'last_visit',
                    target_var = 'last_DX')

    results <- surv_model(exp_dat = exp_dat_imp, modType = modType,
                          time = 'last_visit', target = 'last_DX',
                          ids = ids, grid = grid)



    mcPerf <- rbind(mcPerf, results[[1]], results[[2]])

    return(mcPerf)
  }
}
