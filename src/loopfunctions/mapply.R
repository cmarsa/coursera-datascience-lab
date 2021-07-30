# mapply.R
# `mapply` is a multivariate apply of sorts which applies a function in
# parallel over a set of arguments
#
# > mapply
# function (FUN, ..., MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE) 
# {
#     FUN <- match.fun(FUN)
#     dots <- list(...)
#     answer <- .Internal(mapply(FUN, dots, MoreArgs))
#     if (USE.NAMES && length(dots)) {
#         if (is.null(names1 <- names(dots[[1L]])) && is.character(dots[[1L]])) 
#             names(answer) <- dots[[1L]]
#         else if (!is.null(names1)) 
#             names(answer) <- names1
#     }
#     if (!isFALSE(SIMPLIFY)) 
#         simplify2array(answer, higher = (SIMPLIFY == "array"))
#     else answer
# }

# the followin is tedious to type
list(rep(1, 4), rep(2, 3), rep(3, 2), rep(4, 1))
# instead we can do  [apply a function to multiple sets of arguments]
mapply(rep, 1:4, 4:1)


# vectorizing a function
noise <- function(n, mean, sd) {
    rnorm(n, mean, sd)
}
noise(5, 1, 2)
noise(1:5, 1:5, 2)
# not the same as
mapply(noise, 1:5, 1:5, 2)
