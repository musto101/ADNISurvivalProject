
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)

pre <- Sys.time()

dat <- read.csv('data/cn_preprocessed_wo_csf.csv')
ext_dat <- NULL

dat$X <- NULL
dat$last_DX <- ifelse(dat$last_DX == 'CN', 0, 1)
table(dat$last_DX)
grid <- list(num_nodes = c(10, 15, 16, 20),
             activation = c('relu'),
             epochs        = c(10, 50, 100),
             batch_size = 1:100) #c(100, 200, 500, 1000, 1500))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, modType = 'surv.deephit', clinGroup = 'CN',
                     grid = grid, mcRep = 1, perc = 0.8, ext_dat = ext_dat)

names(results) <- 'test_c_index'

post <- Sys.time()

post - pre

