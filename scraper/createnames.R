library(tidyverse)
library(data.table)

babynames = fread("babynames.csv") %>%
  select(-url, -scrape.url,-Letter) %>%
  filter(Name != "")



chainer = matrix(0, nrow = 26, ncol = max(nchar(babynames$Name)))
