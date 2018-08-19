library(tidyverse)
library(data.table)

babynames = fread("babynames.csv") %>%
  select(-url,-scrape.url, -Letter) %>%
  filter(Name != "") %>% unique()


directories = babynames %>%
  select(category,
         Gender) %>%
  unique()


lapply(1:nrow(directories),
       function(x) {
         get.dir = directories[x,]
         
         retter = babynames %>%
           filter(category == get.dir$category,
                  Gender == get.dir$Gender) %>%
             select(Name)
         
         
         fwrite(retter,
                     paste("data",
                            get.dir$Gender,
                            paste0(get.dir$category,".txt")
                           ,sep="/"),
                quote=FALSE,
                col.names = FALSE)
         
         1
       })



