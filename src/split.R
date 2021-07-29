# split.R
# `split` takes a vector or other objectds and splits it into groups
# determined by a factor or list of factors.
# `split` returns a list
#  - x is a vector (or list) or data frame
#  - f is a vector (or coerced to one) or a list of factors
#  - drop indicated whether empty factors levels should be dropped
# 
# > split
# function (x, f, drop = FALSE, ...) 
#     UseMethod("split")

x <- c(rnorm(10), runif(10), rnorm(10, 1))
f <- gl(3, 10)
split(x, f)

# a common idios is split followd by an lapply
split(x, f) |>
    lapply(mean)


# splitting a data frame
library(datasets)
head(airquality)

s <- split(airquality, airquality$Month)
lapply(s, function(x) { colMeans(x[, c('Ozone', 'Solar.R', 'Wind')]) })   # returned a list
sapply(s, function(x) { colMeans(x[, c('Ozone', 'Solar.R', 'Wind')]) })   # returns simplified
sapply(s, function(x) { colMeans(x[, c('Ozone', 'Solar.R', 'Wind')], na.rm=TRUE) })  # simplified and removing nas


# splitting on mor than one level
x <- rnorm(10)
f1 <- gl(2, 5)
f2 <- gl(5, 2)
f1
f2
interaction(f1, f2)

# interactions can create empty levels
str(split(x, list(f1, f2)))

# drop empty levels
str(split(x, list(f1, f2), drop=TRUE))
