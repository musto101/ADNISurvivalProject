
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)

dat <- read.csv('data/mci_preprocessed.csv')
ext_dat <- NULL

dat$X <- NULL
#dat$last_DX <- ifelse(dat$last_DX == 'CN_MCI', 0, 1)
table(dat$last_DX)
grid <- list(mtry = 1:round(ncol(dat)/2,0),
             min.node.size = c(40, 50, 60),
             num.trees = 1000) #c(100, 200, 500, 1000, 1500))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, modType = 'surv.ranger', clinGroup = 'MCI',
                     grid = grid, mcRep = 1, perc = 0.8, ext_dat = ext_dat)

row.names(results) <- c('train_c_index', 'test_c_index')

#learner$model$mtry
