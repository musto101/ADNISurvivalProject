dat <- read.csv('data/mci_preprocessed.csv')
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")

dat$X <- NULL
dat$last_DX <- ifelse(dat$last_DX == 'CN_MCI', 0, 1)
table(dat$last_DX)
grid <- list(nrounds = 1:10,
                   max_bin = 11,
                   max_depth	= 3,
                   min_child_weight = seq(0.1, 0.2, 0.01))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, modType = 'surv.xgboost', clinGroup = 'MCI',
                     grid = grid, mcRep = 1)


row.names(results) <- c('train_c_index', 'test_c_index')
