# sapply.R
# `sapply` will try to simplify the result of `lapply` if possible
#   - if the result is a list where every elementh is length 1, then a vector is returned
#   - if the result is a list where evey element is a vector of the
#     same length (> 1), a matrix is returned
#   - if it can't figure things out, a list is returned

# > sapply
# function (X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE) 
# {
#     FUN <- match.fun(FUN)
#     answer <- lapply(X = X, FUN = FUN, ...)
#     if (USE.NAMES && is.character(X) && is.null(names(answer))) 
#         names(answer) <- X
#     if (!isFALSE(simplify)) 
#         simplify2array(answer, higher = (simplify == "array"))
#     else answer
# }


# `lapply` returns list
x <- list(a=1:4, b=rnorm(10), c=rnorm(20, 1), d=rnorm(100, 5))
lapply(x, mean)

# `sapply` returns vector
sapply(x, mean)
