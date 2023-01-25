install.packages('../AdniDeterioration/', repos = NULL, type="source")
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")

library(AdniDeterioration)
library(RSurvivalML)
library(caret)
library(tidyverse)
library(doParallel)

adni_mci <- read.csv('data/adni2_clean.csv')
dat <- preprocessing(dat = adni_mci, perc = 0.9, clinGroup = 'MCI')

write.csv(dat, 'data/mci_preprocessed.csv')
