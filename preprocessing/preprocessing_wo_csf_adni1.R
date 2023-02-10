install.packages('../AdniDeterioration/', repos = NULL, type="source")
install.packages('../RSurvivalML/RSurvivalML/', repos = NULL, type="source")

library(AdniDeterioration)
library(RSurvivalML)
library(caret)
library(tidyverse)
library(doParallel)

adni_slim1 <- read.csv('data/adni1_slim_wo_csf.csv')

# missing.perc <- as.data.frame(apply(adni_slim1, 2, function(x) sum(is.na(x))) / nrow(adni_slim1))
#
# adni_slim1 <- adni_slim1[, which(missing.perc < 1)]
#
# write.csv(adni_slim1, 'data/adni1_slim_wo_csf_wo_full_missing.csv')
# write.csv(adni, 'data/mci_preprocessed_wo_csf_adni1.csv')

dat1 <- preprocessing(dat = adni_slim1, perc = 0.9, clinGroup = 'CN')

write.csv(dat1, 'data/cn_preprocessed_wo_csf_adni1.csv')
