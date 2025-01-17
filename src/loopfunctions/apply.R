# apply.R
# `apply` is used to evaluate a function (often an anonymours one)
# over the margins of an array
#   - it is most often used to apply a funciton to the rows or columns of a matrix
#   - it can be used with general arrays, e.g., taking the average of an array of matrices
#   - it is not really faster than writing a loop, wut it works in one line!

# > apply
# function (X, MARGIN, FUN, ..., simplify = TRUE) 
# {
#     FUN <- match.fun(FUN)
#     simplify <- isTRUE(simplify)
#     dl <- length(dim(X))
#     if (!dl) 
#         stop("dim(X) must have a positive length")
#     if (is.object(X)) 
#         X <- if (dl == 2L) 
#             as.matrix(X)
#     else as.array(X)
#     d <- dim(X)
#     dn <- dimnames(X)
#     ds <- seq_len(dl)
#     if (is.character(MARGIN)) {
#         if (is.null(dnn <- names(dn))) 
#             stop("'X' must have named dimnames")
#         MARGIN <- match(MARGIN, dnn)
#         if (anyNA(MARGIN)) 
#             stop("not all elements of 'MARGIN' are names of dimensions")
#     }
#     d.call <- d[-MARGIN]
#     d.ans <- d[MARGIN]
#     if (anyNA(d.call) || anyNA(d.ans)) 
#         stop("'MARGIN' does not match dim(X)")
#     s.call <- ds[-MARGIN]
#     s.ans <- ds[MARGIN]
#     dn.call <- dn[-MARGIN]
#     dn.ans <- dn[MARGIN]
#     d2 <- prod(d.ans)
#     if (d2 == 0L) {
#         newX <- array(vector(typeof(X), 1L), dim = c(prod(d.call), 
#                                                      1L))
#         ans <- forceAndCall(1, FUN, if (length(d.call) < 2L) newX[, 
#                                                                   1] else array(newX[, 1L], d.call, dn.call), ...)
#         return(if (is.null(ans)) ans else if (length(d.ans) < 
#                                               2L) ans[1L][-1L] else array(ans, d.ans, dn.ans))
#     }
#     newX <- aperm(X, c(s.call, s.ans))
#     dim(newX) <- c(prod(d.call), d2)
#     ans <- vector("list", d2)
#     if (length(d.call) < 2L) {
#         if (length(dn.call)) 
#             dimnames(newX) <- c(dn.call, list(NULL))
#         for (i in 1L:d2) {
#             tmp <- forceAndCall(1, FUN, newX[, i], ...)
#             if (!is.null(tmp)) 
#                 ans[[i]] <- tmp
#         }
#     }
#     else for (i in 1L:d2) {
#         tmp <- forceAndCall(1, FUN, array(newX[, i], d.call, 
#                                           dn.call), ...)
#         if (!is.null(tmp)) 
#             ans[[i]] <- tmp
#     }
#     ans.list <- !simplify || is.recursive(ans[[1L]])
#     l.ans <- length(ans[[1L]])
#     ans.names <- names(ans[[1L]])
#     if (!ans.list) 
#         ans.list <- any(lengths(ans) != l.ans)
#     if (!ans.list && length(ans.names)) {
#         all.same <- vapply(ans, function(x) identical(names(x), 
#                                                       ans.names), NA)
#         if (!all(all.same)) 
#             ans.names <- NULL
#     }
#     len.a <- if (ans.list) 
#         d2
#     else length(ans <- unlist(ans, recursive = FALSE))
#     if (length(MARGIN) == 1L && len.a == d2) {
#         names(ans) <- if (length(dn.ans[[1L]])) 
#             dn.ans[[1L]]
#         ans
#     }
#     else if (len.a == d2) 
#         array(ans, d.ans, dn.ans)
#     else if (len.a && len.a%%d2 == 0L) {
#         if (is.null(dn.ans)) 
#             dn.ans <- vector(mode = "list", length(d.ans))
#         dn1 <- list(ans.names)
#         if (length(dn.call) && !is.null(n1 <- names(dn <- dn.call[1])) && 
#             nzchar(n1) && length(ans.names) == length(dn[[1]])) 
#             names(dn1) <- n1
#         dn.ans <- c(dn1, dn.ans)
#         array(ans, c(len.a%/%d2, d.ans), if (!is.null(names(dn.ans)) || 
#                                              !all(vapply(dn.ans, is.null, NA))) 
#             dn.ans)
#     }
#     else ans
# }


x <- matrix(rnorm(200), 20, 10)
x
apply(x, 2, mean)    # applying function mean to dimension 2: cols
apply(x, 1, sum)     # applying function sum to dimension 1: rows

# for sums and means of matrix dimensions, we have optimized shortcuts 
rowSums(x)    # same as apply(x, 1, sum)
rowMeans(x)   # same as apply(x, 1, mean)
colSums(x)    # same as apply(x, 2, sum)
colMeans(x)   # same as apply(x, 2, mean)


# quantiles of the rows of a matrix
x <- matrix(rnorm(200), 20, 10)
apply(x, 1, quantile, probs=c(0.25, 0.75))


# average matrix in an array
a <- array(rnorm(2 * 2 * 10), c(2, 2, 10))
apply(a, c(1, 2), mean)

rowMeans(a, dims=2)
