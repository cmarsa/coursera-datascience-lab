# lapply.R
# > lapply applies a function to the elements of a list
# if input is not a list, it coerces to a list, if fail, raise error
#
# function (X, FUN, ...) 
# {
#     FUN <- match.fun(FUN)
#     if (!is.vector(X) || is.object(X)) 
#         X <- as.list(X)
#     .Internal(lapply(X, FUN))
# }

# `lapply` always returns a list, regardless of the class of the input
x <- list(a=1:5, b=rnorm(10))
lapply(x, mean)

v <- 1:100
lapply(v, mean)

v <- 1:4
lapply(v, runif)

v <- 1:4
lapply(x, runif, min=0, max=10)   # passing args through ... arg, the function passed to lapply
                                  # gets applied the named args

# `lapply` and friends make heavy use of anonymous functions
x <- list(a=matrix(1:4, 2, 2), b=matrix(1:6, 3, 2))
x
lapply(x, function(elt) elt[ , 1])  # getting first column of the passed matrices
