pre <-Sys.time()

dat <- read.csv('data/mci_preprocessed.csv')
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)
ext_dat <- NULL

dat$X <- NULL
#dat$last_DX <- ifelse(dat$last_DX == 'CN_MCI', 0, 1)
table(dat$last_DX)
grid <- list(nrounds = seq(100, 500, 50), max_bin = c(20, 25, 30),
             max_depth	= 1:5, min_child_weight = 1,
             eta = seq(0.01, 0.05, 0.01))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, modType = 'surv.xgboost', clinGroup = 'MCI',
                     grid = grid, mcRep = 1, perc = 0.8, ext_dat = ext_dat)


row.names(results) <- c('train_c_index', 'test_c_index')

post <- Sys.time()
