dat <- read.csv('data/mci_preprocessed.csv')
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type = "source")

dat$X <- NULL
dat$last_DX <- ifelse(dat$last_DX == 'CN_MCI', 0, 1)
table(dat$last_DX)
grid <- list(kernel = c('rbf_kernel'),
             maxiter	= 1:50,
             margin = c(0.1, 1, 10, 100),
             gamma.mu = c(1, 0.1, 0.01, 0.001))

source('modelling/MCI/survModel.R')

results <- survModel(dat = dat, modType = 'surv.svm', clinGroup = 'MCI',
                     grid = grid, mcRep = 1)
