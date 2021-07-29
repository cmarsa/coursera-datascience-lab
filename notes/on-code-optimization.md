# On code optimization
---


Getting biggest impact on speeding up code depends on knowing where the code
spends most of its time

This cannot be done without performance analysis or profiling

"We should forget about small efficiencies, say about 97% of the time:
premature optimization is the root of all evil
-- Donal Knuth"


## General Principles of Optimization
- Design first, then optimize
- Remember: Premature optimization is the root of all evil
- Measure (collect data), don't guess
- If you're going to be scientist, you need to apply the same principles here


### Using `system.time()`
- Takes an arbitrary R expression as input (can be wrapped in curly braces)
    and returns the amount of time taken to evaluate the expression
- Computes time (in seconds) needed to execute an expression
    - if there's an error, fives time unitl the error occurred
- Returns an object of class `proc_time`
    - user time: time chardged to the CPU(s) for this expression
    - elapsed time: "wall clock" time
- Usually the user time and elapsed time are relatively close, for straight computing tasks
- Elapsed time may be *greater than* user time if the CPU spends a lot of time
    waiting around
- Elapsed time may be *smaller than* the user time if your machine has multiple
    cores/procesors (and is capable of using them)
    - Multi-threaded BLAS libraries (vecLib/Accelerate, ATLAS, ACML, MKL)
    - Parallel processing via the parallel package
    
    
Timing Expressions:
```
system.time({
    n <- 1000
    r <- numeric(n)
    for (i in 1:n) {
        x <- rnorm(n)
        r[i] <- mean(x)
    }
})
```

```
   user  system elapsed 
  0.201   0.003   0.204
```


### Beyond `system.time()`
- Using `system.time()` allows you to test certain functions or code blocks
    if there are taking excessive amounts of time
- Assumes you already know where the problem is and can call `systme.time()` on it
- What if you don't know where to start?


## The R Profiler
- The `Rprof()` function starts the profiles in R
    - R must be compiled with profiler support
- The `summaryRprof()` function summarized the output from `Rpof()
- DO NOT use `system.time` and `Rprof()` together, or you will be sad
- `Rprof()` keeps track of the function call stack at regularly intervals
    and tabulates how much time is spend in each function
- Default sampling inverval is 0.02 seconds
- NOTE: If your code runs very quickly, the profiler is not useful


### Using `summaryRprof()`
- The `summaryRprof` function tabulates the R profiler putput and
    calculates how much time is spend in which function
- There are two methods for normalizing the data
- `by.total` divides the time spend in each function by the total run time
- `by.self` does the same but first subtracts out time spent in functions
    above in the call stack