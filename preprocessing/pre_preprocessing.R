install.packages("../adnimerge_package/ADNIMERGE_0.0.1.tar.gz",
                 repos = NULL, type = "source")

library(tidyverse)
library(ADNIMERGE)
library(ggthemes)
library(naniar)
library(GGally)

adni <- ADNIMERGE::adnimerge

adni_last <- adni %>%
  drop_na(DX) %>%
  filter(COLPROT == 'ADNI2') %>%
  group_by(PTID) %>%
  arrange(M) %>%
  summarise(M = last(M))

adni_essentials <- adni %>%
  filter(COLPROT == 'ADNI2') %>%
  drop_na(DX) %>%
  mutate(M = as.numeric(M)) %>%
  select(DX, PTID, M)

adni_last_measure <- adni_last %>%
  left_join(adni_essentials) %>%
  drop_na(DX) %>%
  mutate(last_DX = DX, last_visit = M, PTID = as.character(PTID)) %>%
  select(-DX, -M)

adni_bl <- read_csv('data/adni_bl.csv')

adni_long <- adni_last_measure %>%
  left_join(adni_bl) %>%
  filter(COLPROT == 'ADNI2')

#table(adni_long$DX.bl)
adni_long$X1 <- NULL
adni_long$...1 <- NULL

adni_wo_missing <- adni_long %>%
  purrr::discard(~ sum(is.na(.x))/length(.x) * 100 >=90)

adni_slim <- adni_wo_missing %>%
  select(-RID, -PTID, -VISCODE, -SITE, -COLPROT, -ORIGPROT, -EXAMDATE,
         -DX.bl, -FLDSTRENG, -FSVERSION, -IMAGEUID, -FLDSTRENG.bl, DX,
         -FSVERSION.bl, -Years.bl, -Month.bl, -Month, -M, ICV,
         -ends_with('.bl'))

adni_slim$last_DX <- as.character(adni_slim$last_DX)

adni_slim$ABETA <- as.numeric(gsub("[^0-9.]", "", adni_slim$ABETA))
adni_slim$TAU <- as.numeric(gsub("[^0-9.]", "", adni_slim$TAU))
adni_slim$PTAU <- as.numeric(gsub("[^0-9.]", "", adni_slim$PTAU))

write.csv(adni_slim, 'data/adni2_slim.csv')

