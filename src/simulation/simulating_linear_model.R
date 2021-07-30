# simulating_linear_model.r
# suppose we want to simulate from the following linear model
#
# y = b_o + b_x * x + e

set.seed(20)
x <- rnorm(100)
e <- rnorm(100, 0, 2)
y <- 0.5 + 2 * x + e
summary(y)
plot(x, y)


# what if x is binary?
set.seed(10)
x <- rbinom(100, 1, 0.5)
e <- rnorm(100, 0, 2)
y <- 0.5 + 2 * x + e
summary(y)
plot(x, y)


# generating random numbers from a generilzied linear model
# supposse we want to simulate from a Poisson model where
#  Y ~ Poisson(mu)
# log(mu) = b_o + b_1 * x
# and b_p = 0.5, b_1 = 0.3
# we need to use the rpois function for this
set.seed(1)
x <- rnorm(100)
log.mu <- 0.5 + 0.3 * x
y <- rpois(100 ,exp(log.mu))
summary(y)
plot(x, y)
