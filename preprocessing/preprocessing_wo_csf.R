install.packages('../AdniDeterioration/', repos = NULL, type="source")
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")

library(AdniDeterioration)
library(RSurvivalML)
library(caret)
library(tidyverse)
library(doParallel)

adni_slim2 <- read.csv('data/adni2_slim_wo_csf.csv')

dat <- preprocessing(dat = adni_slim2, perc = 0.9, clinGroup = 'MCI')

write.csv(dat, 'data/mci_preprocessed_wo_csf.csv')

dat <- preprocessing(dat = adni_slim, perc = 0.9, clinGroup = 'CN')

write.csv(dat, 'data/cn_preprocessed_wo_csf.csv')
