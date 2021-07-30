# simulating_random_sampling.r
# the `sample` function draws randomly from a specified set of (scalar)
# objects allowing you to sample from arbitrary distributions
set.seed(1)
sample(1:10, 4)
sample(1:10, 4)
sample(letters, 5)
sample(1:10)  # permutation
sample(1:10)
sample(1:10, replace=TRUE)  # sample w/replacemenmt


# * drawing samples from specific probability distributions can be done with
#       r* functions
# * standard distributions are built in:
#       - Normal
#       - Binomial
#       - Poisson
#       - Exponential
#       - Gamma
# * The sample function can be sued to draw random samples from arbitrary vectors
# * Setting the random number generator seed via `set.seed` is critical
#       for reproducibility