# install.packages("../adnimerge_package/ADNIMERGE_0.0.1.tar.gz",
#                  repos = NULL, type = "source")

library(tidyverse)
library(ADNIMERGE)
library(ggthemes)
library(naniar)
library(GGally)

adni1 <- ADNIMERGE::adnimerge

adni_last1 <- adni1 %>%
  drop_na(DX) %>%
  filter(COLPROT == 'ADNI1') %>%
  group_by(PTID) %>%
  arrange(M) %>%
  summarise(M = last(M))

adni_essentials1 <- adni1 %>%
  filter(COLPROT == 'ADNI1') %>%
  drop_na(DX) %>%
  mutate(M = as.numeric(M)) %>%
  select(DX, PTID, M)

adni_last_measure1 <- adni_last1 %>%
  left_join(adni_essentials1) %>%
  drop_na(DX) %>%
  mutate(last_DX = DX, last_visit = M, PTID = as.character(PTID)) %>%
  select(-DX, -M)

adni_bl <- read_csv('data/adni_bl.csv')

adni_long1 <- adni_last_measure1 %>%
  left_join(adni_bl) %>%
  filter(COLPROT == 'ADNI1')

#table(adni_long$DX.bl)
adni_long1$X1 <- NULL
adni_long1$...1 <- NULL

# adni_wo_missing1 <- adni_long1 %>%
#   purrr::discard(~ sum(is.na(.x))/length(.x) * 100 >=90)

adni_slim1 <- adni_long1 %>%
  select(-RID, -PTID, -VISCODE, -SITE, -COLPROT, -ORIGPROT, -EXAMDATE,
         -DX.bl, -FLDSTRENG, -FSVERSION, -IMAGEUID, -FLDSTRENG.bl, DX,
         -FSVERSION.bl, -Years.bl, -Month.bl, -Month, -M, ICV,
         -ends_with('.bl'))

adni_slim1$last_DX <- as.character(adni_slim1$last_DX)

adni_slim1$PIB <- NULL
adni_slim1$FBB <- NULL
adni_slim1$DIGITSCOR <- NULL
adni_slim1$ABETA <- NULL
adni_slim1$TAU <- NULL
adni_slim1$PTAU <- NULL

write.csv(adni_slim1, 'data/adni1_slim_wo_csf.csv')

