# Lab 10: Loops, Matrices, and Lists with Rcpp

## Overview

Compile and call the C++ functions from Lecture 10. Work through scalar and
vector operations, running totals, conditionals, while loops, matrices, lists,
and vector expressions. Each function is stored in its own C++ file, followed
by an example showing how to call it from R.

This lab follows Lecture 10: loops and scalar versus vector operations
(slides 2-7), special values and conditionals (slides 8-10), while loops and
summary statistics (slides 11-13), matrices (slides 14-15), lists (slides 16-18),
and vector operations (slides 19-20).

## Learning objectives

1. Read a C++ `for` loop and follow its index and running total.
2. Allocate an output vector and fill it one element at a time.
3. Use conditionals and the special-value checks shown in the slides.
4. Follow a `while` loop and distinguish printed output from a return value.
5. Use nested loops to calculate matrix row totals.
6. Return named lists and extract a numeric vector from a list.
7. Compare vector addition and a dot product with their R expressions.

## Project structure

```text
Lab10/
|-- R/
|   |-- lab10.r              # compile functions and run the slide examples
|-- src/
|   |-- squareOne.cpp        # Task 1: scalar square
|   |-- squareAll.cpp        # Task 1: vector of squares
|   |-- sumSquares.cpp       # Task 2: running total
|   |-- positivePart.cpp     # Task 3: conditionals
|   |-- countAbove.cpp       # Task 3: threshold count
|   |-- stepsToTotal.cpp     # Task 4: while loop
|   |-- meanLoop.cpp         # Task 4: sample mean
|   |-- minLoop.cpp          # Task 4: minimum
|   |-- rowTotals.cpp        # Task 5: matrix row totals
|   |-- describe.cpp         # Task 6: named list output
|   |-- sugarExamples.cpp    # Task 6: vector expressions
|   |-- firstValue.cpp       # Task 6: list input
|   |-- addVectors.cpp       # Task 7: vector addition
|   |-- dotProduct.cpp       # Task 7: dot product
|-- tests/
|   |-- lab10_test.r         # compile and check the examples
|-- README.md
```

No external data are needed. Inputs are defined directly in the R script.
As in earlier labs, paths are relative to the lab folder.

## Requirements and setup

Use R, **Rcpp**, **microbenchmark**, and the C++ compiler used in Lab 9.
Install the packages once if needed:

```r
install.packages(c("Rcpp", "microbenchmark"))
```

From the course repository root in R:

```r
setwd("Lab10")
library(Rcpp)
```

Each C++ file starts with `#include <Rcpp.h>` and `using namespace Rcpp;`.
The `// [[Rcpp::export]]` line makes its function callable from R after
compilation with `sourceCpp()`.

## In-class exercise

Open `R/lab10.r` and work through it from top to bottom. Each section compiles
the supplied C++ functions and calls them with small inputs. Read the matching
files in `src/`, follow the implementation, and compare the results with the
expected output shown below.

### Task 1: Scalar and vector operations (slides 2-4)

Read `src/squareOne.cpp` and `src/squareAll.cpp`, then run:

```r
sourceCpp(file.path("src", "squareOne.cpp"))
squareOne(3)  # 9

sourceCpp(file.path("src", "squareAll.cpp"))
squareAll(c(2, 3, 4))  # 4 9 16
```

`squareOne()` accepts and returns a `double`. `squareAll()` accepts a
`NumericVector`, allocates `out` with the same length, and fills each position
inside a loop. Its return value is the entire vector.

The loop pattern from slide 2 is:

```cpp
double total = 0.0;

for (R_xlen_t i = 0; i < x.size(); ++i) {
  total += x[i];
}
```

`R_xlen_t` is an integer type for R vector indexes. The loop starts at zero,
checks `i < x.size()`, runs the body, and increments `i`. The last index is
`x.size() - 1`. `total += x[i]` adds the current element to the running total.

### Task 2: Sum of squares and timing (slides 5-7)

Read `src/sumSquares.cpp`. It uses the same loop, adding `x[i] * x[i]` to a
single running total:

```r
sourceCpp(file.path("src", "sumSquares.cpp"))
sumSquares(c(2, 3))     # 13
sumSquares(c(2, 3, 4))  # 29
```

For `c(2, 3, 4)`, follow `total` through 4, 13, and 29. Compare the scalar
return value with the vector returned by `squareAll()`.

After compilation, run the timing example from the slides:

```r
x <- seq(-1, 1, length.out = 100000)

microbenchmark::microbenchmark(
  R = sum(x * x),
  Rcpp = sumSquares(x),
  times = 30
)
```

Compare the measured running times. A speed gain is an empirical question.

### Task 3: Special values and conditionals (slides 8-10)

Slide 8 introduces these C++ constants and checks:

```cpp
double missing = NA_REAL;
double invalid = R_NaN;
double high = R_PosInf;
double low = R_NegInf;
bool a = R_IsNA(missing);    // true: R's NA
bool b = R_IsNaN(invalid);   // true: NaN excluding NA
bool c = R_FINITE(high);    // false
bool d = NumericVector::is_na(missing); // true
```

`NumericVector::is_na()` detects both NA and NaN. `R_FINITE()` excludes NA,
NaN, and both infinities. Use the missingness checks rather than `== NA_REAL`.

Read `src/positivePart.cpp` and `src/countAbove.cpp`, then run:

```r
sourceCpp(file.path("src", "positivePart.cpp"))
positivePart(c(-2, 0, 3, NA))  # 0 0 3 NA

sourceCpp(file.path("src", "countAbove.cpp"))
countAbove(c(0.2, NA, 0.8, 0.9), 0.5)  # 2
```

`positivePart()` assigns one output per input: a missing value, the positive
value itself, or zero. `countAbove()` increments its count when the value is
nonmissing and strictly above `cutoff`. Each `if` uses a scalar condition;
`&&` joins the two conditions in `countAbove()`.

### Task 4: While loops, means, and minima (slides 11-13)

Read `src/stepsToTotal.cpp` and trace `stepsToTotal(6)`:

```r
sourceCpp(file.path("src", "stepsToTotal.cpp"))
stepsToTotal(6)
# Prints:
# 1 1
# 2 3
# 3 6
# Returns 3.
```

The loop continues while `total < target`. `++i` increments the index before
adding it to `total`. `Rcout` prints each index and total; `return i` supplies
the function's result.

Read `src/meanLoop.cpp` and `src/minLoop.cpp`, then run:

```r
sourceCpp(file.path("src", "meanLoop.cpp"))
meanLoop(c(2, 4, 6))  # 4

sourceCpp(file.path("src", "minLoop.cpp"))
minLoop(c(4, 2, 7))  # 2
```

`meanLoop()` adds the values and divides by the length converted to a
`double`. `minLoop()` starts `best` at positive infinity and replaces it when
a smaller value is found. Both return `NA_REAL` when their loop encounters
NA or NaN. The empty-vector results in the slides are `R_NaN` for
`meanLoop()` and `R_PosInf` for `minLoop()`.

### Task 5: Matrix row totals (slides 14-15)

Slide 14 extends allocation and indexing to matrices:

```cpp
NumericMatrix A(3, 2); // 3 rows, 2 columns

A(0, 0) = 1.0;
A(1, 0) = 2.0;
A(2, 1) = 7.0;

int n = A.nrow(); // 3
int p = A.ncol(); // 2
```

`NumericMatrix` initializes its entries to zero. Access an element with
`A(row, column)`, using zero-based indexes for both dimensions.

Read `src/rowTotals.cpp`, then run:

```r
sourceCpp(file.path("src", "rowTotals.cpp"))
A <- matrix(1:6, nrow = 2)

rowTotals(A)  # 9 12
rowSums(A)    # 9 12
```

The output has one entry per row. The outer loop visits columns and the inner
loop adds each matrix element to its row total.

### Task 6: Lists and Rcpp sugar (slides 16-18)

Read `src/describe.cpp`. `List::create()` bundles results, and `Named()`
assigns their names:

```r
sourceCpp(file.path("src", "describe.cpp"))
ans <- describe(c(10, 20), matrix(0, 3, 2))
ans$length  # 2
ans$nrow    # 3
ans$ncol    # 2
ans$first   # 10
```

Read `src/sugarExamples.cpp`. Rcpp sugar uses vector expressions for absolute
values, exponentials, cubes, positive-value comparisons, and negation:

```r
sourceCpp(file.path("src", "sugarExamples.cpp"))
sugarExamples(c(-2, 0, 2))$cube  # -8 0 8
```

Read `src/firstValue.cpp`. A list can also be an input. Here the function
extracts the element named `x` with `as<NumericVector>()` and returns its
first value:

```r
sourceCpp(file.path("src", "firstValue.cpp"))
firstValue(list(x = c(7, 9)))  # 7
```

### Task 7: Vector addition and dot products (slides 19-20)

Read `src/addVectors.cpp`. The vector expression returns the sum at each
position:

```r
sourceCpp(file.path("src", "addVectors.cpp"))
addVectors(c(1, 2, 3), c(1, 2, 3))  # 2 4 6
```

Read `src/dotProduct.cpp`. Its loop multiplies corresponding elements and
accumulates one total:

```r
sourceCpp(file.path("src", "dotProduct.cpp"))
x <- c(1, 2, 3)
y <- c(4, 5, 6)
x * y             # 4 10 18
sum(x * y)        # 32
dotProduct(x, y)  # 32
```

Both functions use the length check from the slides before combining their
inputs. Compare the vector returned by `addVectors()` with the scalar
returned by `dotProduct()`.

## How to run

From the course repository root in R:

```r
setwd("Lab10")
source(file.path("R", "lab10.r"), echo = TRUE)
```

Use `echo = TRUE` to show the calls and results when running the complete
walkthrough. For in-class work, run each section interactively after reading
its C++ files.

## What the test script does

`tests/lab10_test.r` checks the supplied `.cpp` implementations:

1. Compile all 14 files with `Rcpp::sourceCpp()` in a fresh environment.
2. Check that each function is exported and callable from R.
3. Compare function outputs with the slide examples and expected values.
4. Print `PASS` messages when checks succeed; stop with an error if a check fails.

The checks cover scalar and vector squares, sum of squares, conditionals,
threshold counts, while-loop output, means, minima, matrix row totals, named
list elements, list extraction, vector addition, and dot products. The test
script compiles the files in `src/` directly.

## How to run the tests

With `Lab10` as the R working directory:

```r
source(file.path("tests", "lab10_test.r"))
```

Or, with `Lab10` as the shell working directory:

```sh
Rscript tests/lab10_test.r
```

## Reproducibility and checks

The examples are deterministic and use the functions from the slides. Timing
results depend on the computer. Compilation happens before the benchmark.

## Author

Xiangyu Song

## Date

2026-11-03
