######################################################
#                                                    #
# Lab 10: Loops, matrices, and lists with Rcpp       #
#                                                    #
# R/lab10.r                                          #
#                                                    #
# In-class implementations from Lecture 10:          #
#   Task 1. scalar and vector operations             #
#   Task 2. sum of squares and timing                #
#   Task 3. special values and conditionals          #
#   Task 4. while loops, means, and minima           #
#   Task 5. matrix row totals                        #
#   Task 6. lists and Rcpp sugar                     #
#   Task 7. vector addition and dot products         #
#                                                    #
######################################################

# Work from Lab10. Open each src file before compiling its function.
library(Rcpp)


# Task 1. Scalar and vector operations (slides 2-4)
# The for loop starts at index 0 and continues while i < x.size().

sourceCpp(file.path("src", "squareOne.cpp"))
squareOne(3)  # 9

sourceCpp(file.path("src", "squareAll.cpp"))
squareAll(c(2, 3, 4))  # 4 9 16

# squareOne() returns one double; squareAll() returns a NumericVector.
# squareAll() allocates out, then fills out[i] inside the loop.


# Task 2. Sum of squares and timing (slides 5-7)

sourceCpp(file.path("src", "sumSquares.cpp"))
sumSquares(c(2, 3))     # 13
sumSquares(c(2, 3, 4))  # 29

# The running total is 4, then 13, then 29 for c(2, 3, 4).
# Compile first, then compare repeated calls with the R expression.
x <- seq(-1, 1, length.out = 100000)

microbenchmark::microbenchmark(
  R = sum(x * x),
  Rcpp = sumSquares(x),
  times = 30
)


# Task 3. Special values and conditionals (slides 8-10)
# NA_REAL, R_NaN, R_PosInf, and R_NegInf are C++ constants for R values.
# NumericVector::is_na() detects both NA and NaN.

sourceCpp(file.path("src", "positivePart.cpp"))
positivePart(c(-2, 0, 3, NA))  # 0 0 3 NA

# The first branch keeps a missing result; the next branches use x[i] or 0.
sourceCpp(file.path("src", "countAbove.cpp"))
countAbove(c(0.2, NA, 0.8, 0.9), 0.5)  # 2

# && combines two scalar conditions; ++count increases the count by one.


# Task 4. While loops, means, and minima (slides 11-13)

sourceCpp(file.path("src", "stepsToTotal.cpp"))
stepsToTotal(6)
# Rcout prints the index and running total:
# 1 1
# 2 3
# 3 6
# The function returns 3.

sourceCpp(file.path("src", "meanLoop.cpp"))
meanLoop(c(2, 4, 6))  # 4

# Accumulate the values, then divide by the vector length.
sourceCpp(file.path("src", "minLoop.cpp"))
minLoop(c(4, 2, 7))  # 2

# Start best at R_PosInf and update it whenever x[i] is smaller.


# Task 5. Matrix row totals (slides 14-15)
# Access a C++ matrix element with A(row, column), starting from zero.

sourceCpp(file.path("src", "rowTotals.cpp"))
A <- matrix(1:6, nrow = 2)
A
#      [,1] [,2] [,3]
# [1,]    1    3    5
# [2,]    2    4    6

rowTotals(A)  # 9 12
rowSums(A)    # 9 12
colTotals(A)
# The outer loop visits columns; the inner loop adds to each row's total.


# Task 6. Lists and Rcpp sugar (slides 16-18)

sourceCpp(file.path("src", "describe.cpp"))
ans <- describe(c(10, 20), matrix(0, 3, 2))
ans$length  # 2
ans$nrow    # 3
ans$ncol    # 2
ans$first   # 10

# List::create() returns several results; Named() gives each one a name.
sourceCpp(file.path("src", "sugarExamples.cpp"))
sugarExamples(c(-2, 0, 2))$cube  # -8 0 8

# The list also contains absolute, exponential, positive, and negative.
sourceCpp(file.path("src", "firstValue.cpp"))
firstValue(list(x = c(7, 9)))  # 7

# Here firstValue() takes a List and extracts its element named "x".


# Task 7. Vector addition and dot products (slides 19-20)

sourceCpp(file.path("src", "addVectors.cpp"))
addVectors(c(1, 2, 3), c(1, 2, 3))  # 2 4 6

sourceCpp(file.path("src", "dotProduct.cpp"))
x <- c(1, 2, 3)
y <- c(4, 5, 6)
x * y             # 4 10 18
sum(x * y)        # 32
dotProduct(x, y)  # 32
