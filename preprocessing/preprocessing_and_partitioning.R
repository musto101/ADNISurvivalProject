library(RSurvivalML)
library(caret)
library(dplyr)
library(doParallel)
adni_slim <- read.csv('data/adni_slim.csv')

missing.perc <- as.data.frame(apply(adni_slim, 2, function(x) sum(is.na(x))) / nrow(adni_slim))

adni_slim <- adni_slim[, which(missing.perc < 0.5)]

dummies <- dummyVars(last_DX ~., data = adni_slim)
data_numeric <- predict(dummies, newdata= adni_slim)
data_numeric <- as.data.frame(data_numeric)
data_numeric <-data.frame(adni_slim$last_DX, data_numeric)

names(data_numeric)[1] <- 'last_DX'

data_numeric$X <- NULL
