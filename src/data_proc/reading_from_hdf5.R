# reading_from_hdf5.R


# installing HDF5
source('http://bioconductor.org/biocLite.R')
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.13")
BiocManager::install('rhdf5')


# create h5 fil
library(rhdf5)
created <- h5createFile('out/example.h5')
created

# create groups withing the file
created <- h5createGroup('out/example.h5', 'foo')
created <- h5createGroup('out/example.h5', 'baa')
created <- h5createGroup('out/example.h5', 'foo/foobaa')
h5ls('out/example.h5')

# write to groups
A = matrix(1:10, nr=5, nc=2)
h5write(A, 'out/example.h5', 'foo/A')
B = array(seq(0.1, 2.0, by=0.1), dim=c(5, 2, 2))
attr(B, 'scale') <- 'liter'
h5write(B, 'out/example.h5', 'foo/foobaa/B')
h5ls('out/example.h5')

# write a dataset directly
df = data.frame(1L:5L, seq(0, 1, length.out=5),
                c('ab', 'cde', 'fghi', 'a', 's'), stringAsFactors=FALSE)
h5write(df, 'out/example.h5', 'df')
h5ls('out/example.h5')
    

# reading data
readA <- h5read('out/example.h5', 'foo/A')
readB <- h5read('out/example.h5', 'foo/foobaa/B')
readdf <- h5read('out/example.h5', 'df')
readA


# writing and reading chunks
h5write(c(12, 13, 14), 'out/example.h5', 'foo/A', index=list(1:3, 1))
h5read('out/example.h5', 'foo/A')
