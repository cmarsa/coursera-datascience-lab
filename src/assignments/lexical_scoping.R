# lexical_scoping.R

# makeVector creates a special "vector", which is really a list containing a function to
#  - set the value of the vector
#  - get the value of the vector
#  - set the value of the mean
#  - get the value of the mean
makeVector <- function(x = numeric()) {
    m <- NULL
    set <- function(y) {
        x <<- y
        m <<- NULL
    }
    get <- function() x
    setmean <- function(mean) m <<- mean
    getmean <- function() m
    list(set = set, get = get,
         setmean = setmean,
         getmean = getmean)
}


# The following function calculates the mean of the special "vector" created with
# the above function. However, it first checks to see if the mean has already been
# calculated. If so, it gets the mean from the cache and skips the computation.
# Otherwise, it calculates the mean of the data and sets the value of the mean in
# the cache via the setmean function.
cachemean <- function(x, ...) {
    m <- x$getmean()
    if(!is.null(m)) {
        message("getting cached data")
        return(m)
    }
    data <- x$get()
    m <- mean(data, ...)
    x$setmean(m)
    m
}



# Assignment: Caching the Inverse of a Matrix

# Matrix inversion is usually a costly computation and there may be
# some benefit to caching the inverse of a matrix rather than compute it
# repeatedly (there are also alternatives to matrix inversion that we will
# not discuss here). Your assignment is to write a pair of functions that cache
# the inverse of a matrix.

# Write the following functions:
    
# * makeCacheMatrix: This function creates a special "matrix" object
#       that can cache its inverse.
#
# * cacheSolve: This function computes the inverse of the special "matrix"
#       returned by makeCacheMatrix above. If the inverse has already been
#       calculated (and the matrix has not changed), then the cachesolve should
#       retrieve the inverse from the cache.
# 
# Computing the inverse of a square matrix can be done with the solve function in R.
# For example, if X is a square invertible matrix, then solve(X) returns its inverse.

## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function
# The first function, makeCacheMatrix creates a special "matrix",
# which is really a list containing a function to
# 
#  - set the value of the matrix
#  - get the value of the matrix
#  - set the value of the inverse
#  - get the value of the inverse
#     (Adapted from the coursera description of cachemean for this excercise)
makeCacheMatrix <- function(x = matrix()) {
    # initialize the matrix to NULL
    inverse  <- NULL
    set <- function(y) {
        x <<- y
        inverse <<- NULL
    }
    get <- function() {
        x
    }
    
    setinverse <- function(inv) { 
        inverse <<- inv
    }
    getinverse <- function() {
        inverse
    } 
    list(set = set, get = get,
         setinverse = setinverse,
         getinverse = getinverse)
}


## Write a short comment describing this function
# The following function calculates the inverse of the matrix created with the above function.
# However, it first checks to see if the inverse has already been calculated.
# If so, it gets the mean from the cache and skips the computation.
# Otherwise, it calculates the inverse of the matrix and sets the value of the inverse in
# the cache via the setinverse function.
#     (Adapted from the coursera description of cachemean for this excercise)
cacheSolve <- function(x, ...) {
    inverse <- x$getinverse()
    
    if(!is.null(inverse)) {
        message("getting cached data")
        return(inverse)
    }
    
    data <- x$get()
    inverse <- solve(data, ...)
    x$setinverse(inverse)
    inverse
}

