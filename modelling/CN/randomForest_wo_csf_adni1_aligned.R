install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)

pre <- Sys.time()

dat <- read.csv('data/cn_preprocessed_wo_csf_wo_adni1_full_missing.csv')
ext_dat <- read.csv('data/cn_preprocessed_wo_csf_adni1.csv')

dat$X <- NULL
ext_dat$X <- NULL

#dat$last_DX <- ifelse(dat$last_DX == 'CN', 0, 1)
#ext_dat$last_DX <- ifelse(ext_dat$last_DX == 'CN', 0, 1)

table(dat$last_DX)
table(ext_dat$last_DX)

grid <- list(mtry = 1:round(ncol(dat)/2,0),  min.node.size = c(10, 20, 30),
             num.trees = 1000) #c(100, 200, 500, 1000, 1500))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, ext_dat = ext_dat, modType = 'surv.ranger',
                     clinGroup = 'CN', grid = grid, mcRep = 25, perc = 0.8)

#names(results) <- c('train_c_index', 'test_c_index', 'ext_c_index')

post <- Sys.time()

post - pre
