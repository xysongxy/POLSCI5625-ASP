# Lab 2: Code Performance and Pairwise Distances

## Overview

Lab 2 follows the Week 2 discussion of problem size, asymptotic complexity,
implementation costs, vectorization, memory, sparse matrices, and refactoring.

The in-class exercise contains Tasks 1-2. The larger thresholded-distance
exercise is a separate assignment containing Tasks 3-5.

For one-dimensional values, the Euclidean distance between `x[i]` and `y[j]`
is

```r
abs(x[i] - y[j])
```

If `x` has length `m` and `y` has length `n`, the output has `m * n` entries.
Every implementation must therefore calculate all `m * n` pairwise distances.

## Learning objectives

After completing this lab, students should be able to:

1. preallocate and fill a matrix with nested loops;
2. vectorize a pairwise calculation;
3. compare two equivalent vectorized implementations;
4. distinguish asymptotic complexity from implementation costs;
5. verify correctness before benchmarking; and
6. evaluate dense and sparse matrix storage.

## Requirements

- R 4.0 or later.
- The recommended package `Matrix` for Tasks 3-5.

Install `Matrix` once if it is not available:

```r
install.packages("Matrix")
```

## Project structure

```text
Lab2/
|-- assignment/
|   ...
|-- R/
|   |-- lab2.r
|   |-- run_lab2.r
|-- results/
|   |-- small_timing.csv
|-- tests/
|   |-- lab2_test.r
|-- README.md
```

## In-class exercise: Tasks 1-2

Create two reproducible vectors:

```r
set.seed(123)
x <- runif(1000)
y <- runif(3000)
```

The output contains 3,000,000 pairwise distances.

### Task 1: Nested loops

Write `pairwise_distance_loop(x, y)`.

- Preallocate a `length(x)` by `length(y)` dense matrix.
- Use one loop over `x` and a nested loop over `y`.
- Store `abs(x[i] - y[j])` in row `i`, column `j`.
- Do not grow the matrix inside the loops.

### Task 2: Vectorization

Write `pairwise_distance_vectorized(x, y)` using `outer()`:

```r
abs(outer(x, y, FUN = "-"))
```

Immediately below it, write a second equivalent function,
`pairwise_distance_vectorized_handcoded(x, y)`, without `outer()`.

The hand-coded vectorized strategy is:

1. use `matrix()` to repeat `x` across `length(y)` columns;
2. use `sweep(..., MARGIN = 2, STATS = y, FUN = "-")` to subtract `y[j]`
   from column `j`; and
3. take the absolute value.

The complete reference implementations are in `R/lab2.r`.

## In-class checks and discussion

Before timing the functions, verify that the loop, `outer()`, and hand-coded
vectorized versions return the same dimensions and values.

Then compare their elapsed times with `system.time()` and answer:

1. What is the time complexity when the vector lengths are `m` and `n`?
2. Does vectorization change the asymptotic complexity?
3. Why can a vectorized implementation be faster even when its asymptotic
   complexity is unchanged?
4. Does the hand-coded vectorized version create larger intermediate objects
   than the `outer()` version?

All three methods have time complexity `Theta(mn)` because every pair must be
calculated. Vectorization changes implementation costs rather than the
asymptotic order.

## Separate assignment: Tasks 3-5

Tasks 3-5 form the graded lab assignment and are stored separately:

- [Assignment handout](assignment/README.md)
- [Student starter](assignment/R/lab2_assignment.r)
- [Instructor solution](assignment/R/lab2_assignment_solution.r)

The assignment scales the problem to vectors of lengths 30,00 and 50,00,
applies a `0.5` threshold, and compares:

- Task 3: nested loops;
- Task 4: a vectorized dense matrix; and
- Task 5: vectorization followed by sparse storage.

Students calculate the Task 3-to-Task 4 time gain and the Task 4-to-Task 5
stored-memory reduction.

## How to run the materials

```
Run the Tasks 1-2 correctness tests:

```r
source(file.path("tests", "lab2_test.r"))
```

Run the Tasks 1-2 benchmark:

```r
source(file.path("R", "run_lab2.r"))
```

Enter the self-contained assignment project, generate its vectors, run its
tests, and run its benchmark with:

```r
setwd("assignment")
source(file.path("R", "gendata.r"))
source(file.path("tests", "lab2_assignment_test.r"))
source(file.path("R", "run_assignment.r"))
```

The in-class benchmark writes to `results/`. All threshold-related data,
tests, benchmark code, and output remain under `assignment/`.

Commit the assignment project to your own GitHub repository with name `Lab2_assignment`.

## Reproducibility

The data-generation script uses seed `123`. All scripts use project-relative
paths and assume that `Lab2` is the working directory.

## Author

Xiangyu Song

## Date

2026-09-01
