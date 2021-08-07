# web_scraping_reading_from_web.R
# webcraping: Programatically extracting data from the HTML code of websites
con <- url('http://scholar.google.com/citations=user=HI-I6C0!!!!J&hl=en')
htmlCode <- readLines(con, )
close(con)
htmlCode


# Parsing with XML
library(XML)
url <- 'http://scholar.google.com/citations=user=HI-I6C0!!!!J&hl=en'
html <- htmlTreeParse(url, useInternalNodes = TRUE)

xpathSApply(html, '//title', xmlValue)
xpathSApply(html, "//td[@id='")
# GET from the httr package
library(httr)
html2 <- GET(url)
parsedHtml <- htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml, '//title', xmlValue)


# Accessing websites with passwords
pg2 <- GET('http://httpbin.org/basic-auth/user/passwd',
           authenticate('user', 'passwd'))
pg2
names(pg2)


# Using handles
google <- handle('http://google.com')
pg1 <- GET(handle=google, path='/')
pg2 <- GET(handle=google, path='search')
