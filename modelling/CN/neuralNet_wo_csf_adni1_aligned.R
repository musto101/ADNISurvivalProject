
#install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)

pre <- Sys.time()

dat <- read.csv('data/cn_preprocessed_wo_csf_wo_adni1_full_missing.csv')

dat$X <- NULL
dat$last_DX <- ifelse(dat$last_DX == 'CN', 0, 1)
table(dat$last_DX)
grid <- list(num_nodes = c(16, 32, 48),
             activation = c('relu'),
             epochs	= 5:20,
             batch_size = c(300, 400, 500, 600, 800, 1000)) #c(100, 200, 500, 1000, 1500))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, modType = 'surv.deephit', clinGroup = 'CN',
                     grid = grid, mcRep = 1)

names(results) <- 'test_c_index'

post <- Sys.time()

post - pre

