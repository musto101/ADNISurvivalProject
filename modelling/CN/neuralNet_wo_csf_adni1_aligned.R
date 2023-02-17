
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)

pre <- Sys.time()

dat <- read.csv('data/cn_preprocessed_wo_csf_wo_adni1_full_missing.csv')
ext_dat <- read.csv('data/cn_preprocessed_wo_csf_adni1.csv')

dat$X <- NULL
ext_dat$X <- NULL

dat$last_DX <- ifelse(dat$last_DX == 'CN', 0, 1)
ext_dat$last_DX <- ifelse(ext_dat$last_DX == 'CN', 0, 1)

table(dat$last_DX)
table(ext_dat$last_DX)

grid <- list(num_nodes = c(1:16),
             activation = c('relu'),
             epochs	= 20:150,
             batch_size = c(1000, 2000, 5000, 10000)) #c(100, 200, 500, 1000, 1500))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, ext_dat = ext_dat, modType = 'surv.deephit',
                     clinGroup = 'CN', grid = grid, mcRep = 1, perc = 0.8)

rownames(results) <- c('train_c_index', 'test_c_index', 'ext_c_index')

post <- Sys.time()

post - pre

