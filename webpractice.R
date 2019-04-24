# 다음 실시간 검색어
library(tidyverse)
library(httr)
library(rvest)

'https://www.daum.net/'
res <- GET(url = 'https://www.daum.net/')
print(x = res)
searchWords <- res %>% 
  read_html() %>% 
  html_nodes(css = 'div.realtime_part > ol > li > div > div:nth-child(1) > span.txt_issue > a') %>% 
  html_text(trim = TRUE)

# 네이버 과제 

library(httr)
print(x = searchWords)

library(urltools)
library(rvest)
library(tidyverse)

'https://land.naver.com/article/articleList.nhn?rletTypeCd=A01&tradeTypeCd=&hscpTypeCd=A01%3AA03%3AA04&rletNo=12826'


res <- GET(url = 'https://land.naver.com/article/articleList.nhn', 
           query = list(rletTypeCd = 'A01', 
                        tradeTypeCd = 'A1',
                        hscpTypeCd = 'A01',
                        cortarNo = '1168010500',
                        rletNo = '12826', 
                        page = '1'))

print(x = res)

print(x = res$request)

print(x = res$request$options$useragent)


myUA <- 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'

res <- GET(url = 'https://land.naver.com/article/articleList.nhn', 
           query = list(rletTypeCd = 'A01', 
                        tradeTypeCd = 'A1',
                        hscpTypeCd = 'A01',
                        cortarNo = '1168010500',
                        rletNo = '12826', 
                        page = '1'), 
           user_agent(agent = myUA))

print(x = res)

print(x = res$request)


res %>% 
  read_html() %>% 
  html_node(css = '#depth4Content > fieldset > div > div:nth-child(3) > table')

Sys.setlocale(category = 'LC_ALL', locale = 'C')

tbl <- res %>% 
  read_html() %>% 
  html_node(css = 'table.sale_list') %>% 
  html_table(fill = TRUE)

Sys.setlocale(category = 'LC_ALL', locale = 'korean')

glimpse(x = tbl)


print(x = tbl)

idx <- seq(from = 1, to = 60, by = 1)

print(x = idx)

idx %% 2

tbl1 <- tbl[idx %% 2 == 1, ]
tbl2 <- tbl[idx %% 2 == 0, ]

str(object = tbl1)

tbl1 <- tbl1[, -3]

str(object = tbl2)


tbl2 <- tbl2[, 4]

tbl <- cbind(tbl1, tbl2)


colnames(x = tbl)[c(4:5, 7, 9)] <- c('면적', '동', '매물가', '매물정보')

glimpse(x = tbl)


rownames(x = tbl) <- NULL


tbl$매물명 %>% str_remove_all(pattern = '현장확인|네이버부동산에서 보기')

tbl$매물명 %>% str_remove_all(pattern = '현장확인|네이버부동산에서 보기|\n|\t')

tbl$매물명 <- tbl$매물명 %>% 
  str_remove_all(pattern = '현장확인|네이버부동산에서 보기|\n|\t')


tbl$면적 %>% str_extract(pattern = '\\d+\\/\\d+')

tbl$면적 <- tbl$면적 %>% 
  str_extract(pattern = '\\d+\\/\\d+')


tbl$연락처 %>% str_extract(pattern = '\\d{2,4}-\\d{3,4}-\\d{4}')

tbl$전화번호 <- tbl$연락처 %>% 
  str_extract(pattern = '\\d{2,4}-\\d{3,4}-\\d{4}')


tbl$연락처 %>% str_remove(pattern = '\\d{2,4}-\\d{3,4}-\\d{4}')

tbl$연락처 %>% str_remove_all(pattern = '\\d{2,4}-\\d{3,4}-\\d{4}|\n|\t')

tbl$연락처 <- tbl$연락처 %>% 
  str_remove_all(pattern = '\\d{2,4}-\\d{3,4}-\\d{4}|\n|\t')

colnames(x = tbl)[8] <- '중개사무소'

tbl$매물정보 %>% str_remove_all(pattern = '(매경|한경)*부동산(뱅크)*')

tbl$매물정보 %>% str_remove_all(pattern = '(매경|한경)*부동산(뱅크)*|\n|\t')

tbl$매물정보 <- tbl$매물정보 %>% 
  str_remove_all(pattern = '(매경|한경)*부동산(뱅크)*|\n|\t')


View(x = tbl)
