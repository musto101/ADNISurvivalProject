library(AdniDeterioration)
library(RSurvivalML)
library(caret)
library(tidyverse)
library(doParallel)
adni_slim <- read.csv('data/adni_slim.csv')
dat <- preprocessing(dat = adni_slim, perc = 0.5, clinGroup = 'MCI')

