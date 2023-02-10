# install.packages('../AdniDeterioration/', repos = NULL, type="source")
# install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")

library(AdniDeterioration)
library(RSurvivalML)
library(caret)
library(tidyverse)
library(doParallel)

adni_slim2 <- read.csv('data/adni2_slim_wo_csf_wo_adni1_full_missing.csv')

dat <- preprocessing(dat = adni_slim2, perc = 0.9, clinGroup = 'MCI')

dat$PTRACCATHawaiian.Other.PI <- NULL
dat$PTRACCATUnknown<- NULL
dat$ADAS11_na<- NULL

write.csv(dat, 'data/mci_preprocessed_wo_csf_wo_adni1_full_missing.csv')

dat <- preprocessing(dat = adni_slim2, perc = 0.9, clinGroup = 'CN')

dat$PTRACCATHawaiian.Other.PI <- NULL
dat$PTRACCATUnknown<- NULL
dat$ADAS11_na<- NULL

write.csv(dat, 'data/cn_preprocessed_wo_csf_wo_adni1_full_missing.csv')
