library(xml2)
library(tidyverse)
library(data.table)

z = read_html("https://www.babynameguide.com/categories.html")

scrape.frame = data.frame(
  url = z %>% xml_find_all("//table[@class='NameCategories']//li/a") %>% xml_attr("href"),
  category = z %>% xml_find_all("//table[@class='NameCategories']//li/a") %>% xml_text()
)

scraper.frame = expand.grid(
  url = scrape.frame$url,
  Gender = c("M","F"),
  Letter = LETTERS
) %>%
  mutate(
    scrape.url = paste0("https://www.babynameguide.com/",
                        url,
                        "&strAlpha=",
                        Letter,
                        "&strGender=",
                        Gender)
  )


scrape.it = function(url) {
  z2 =read_html(url)
  retter = z2 %>% 
    xml_find_all("//table[@class='NameTable']//th[@class='NameColumnsName']") %>%
    xml_text()
  
  if(length(retter) == 0) retter = NA
  
  data.frame(url, Name = retter)
}


ken = lapply(scraper.frame$scrape.url,possibly(scrape.it,NA))

names = rbindlist(
  ken,
  use.names = TRUE,
  fill = TRUE
) %>% 
  rename(scrape.url = url)


zzzz = names %>% merge(scraper.frame)

zzzz %>%
  merge(scrape.frame,by="url") %>%
  fwrite("babynames.csv")
