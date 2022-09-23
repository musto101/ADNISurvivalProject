
#install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)

dat <- read.csv('data/mci_preprocessed.csv')

dat$X <- NULL
dat$last_DX <- ifelse(dat$last_DX == 'CN_MCI', 0, 1)
table(dat$last_DX)
grid <- list(mtry = 1:12, #seq(1, ncol(dat)/2, 1),
                   min.node.size = c(1, 3, 5, 10, 11, 13), #c(1, 3, 5, 10, 15, 20, 25, 30),
                   num.trees = c(100, 200, 500, 600, 800)) #c(100, 200, 500, 1000, 1500))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, modType = 'surv.ranger', clinGroup = 'MCI',
                     grid = grid, mcRep = 1)

names(results) <- 'test_c_index'

learner$model$mtry
