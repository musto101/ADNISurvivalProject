
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)

pre <- Sys.time()

dat <- read.csv('data/mci_preprocessed_wo_csf_wo_adni1_full_missing.csv')
ext_dat <- read.csv('data/mci_preprocessed_wo_csf_adni1.csv')

dat$X <- NULL
ext_dat$X <- NULL

# dat$last_DX <- ifelse(dat$last_DX == 'CN_MCI', 0, 1)
# ext_dat$last_DX <- ifelse(ext_dat$last_DX == 'CN_MCI', 0, 1)

table(dat$last_DX)
grid <- list(mtry = 1:round(ncol(dat)/2,0),
             min.node.size = c(40, 50, 60),
             num.trees = 1000) #c(100, 200, 500, 1000, 1500))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, ext_dat  = ext_dat, modType = 'surv.ranger',
                     clinGroup = 'MCI', grid = grid, mcRep = 100, perc = 0.8)

#names(results) <- 'test_c_index'

post <- Sys.time()

post - pre

