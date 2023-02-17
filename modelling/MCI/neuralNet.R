
#install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")
library(RSurvivalML)

pre <- Sys.time()

dat <- read.csv('data/mci_preprocessed.csv')
ext_dat <- NULL

dat$X <- NULL
grid <- list(num_nodes = c(16, 32, 48),
             activation = c('relu'),
             epochs	= 5:20,
             batch_size = c(300, 400, 500, 600, 800, 1000)) #c(100, 200, 500, 1000, 1500))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, modType = 'surv.deephit', clinGroup = 'MCI',
                     grid = grid, mcRep = 1, perc = 0.8, ext_dat = ext_dat)

#names(results) <- 'test_c_index'

post <- Sys.time()

post - pre

library(reticulate)
library(survivalmodels)

