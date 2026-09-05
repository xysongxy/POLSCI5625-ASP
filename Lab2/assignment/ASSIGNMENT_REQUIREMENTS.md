# Lab 2 Assignment Requirements

## Objective

Calculate pairwise Euclidean distances between two vectors using nested loops,
vectorization, and sparse-matrix storage. Compare the computational time of
the loop and vectorized implementations and compare the stored-memory use of
the dense and sparse results.

For one-dimensional values, the Euclidean distance between `x[i]` and `y[j]`
is:

```r
abs(x[i] - y[j])
```

## Setup

Use R with the `Matrix` package installed. Begin with the assignment folder as
the working directory.

Generate the required vectors by running:

```r
source(file.path("R", "gendata.r"))
```

The generated data contain:

- `x`, with 3,000 values drawn from `Uniform(0, 1)`;
- `y`, with 5,000 values drawn from `Uniform(0, 1)`; and
- seed `123` for reproducibility.

Use:

```r
threshold <- 0.5
```

The output must have 3,000 rows, 5,000 columns, and 15,000,000 pairwise
distances. Row `i` must correspond to `x[i]`, and column `j` must correspond to
`y[j]`.

For every pair:

- record `0` if the distance is strictly less than `0.5`; and
- preserve the distance if it is greater than or equal to `0.5`.

A distance exactly equal to `0.5` must be preserved.

## Task 3: Nested loops

Write:

```r
thresholded_distance_loop(x, y, threshold = 0.5)
```

Requirements:

1. Return a regular dense R matrix.
2. Preallocate a `length(x)` by `length(y)` matrix before beginning the loops.
3. Use two nested loops, with one loop over `x` and one loop over `y`.
4. Calculate `abs(x[i] - y[j])` once for each pair.
5. Store `0` when the distance is strictly less than `threshold`.
6. Otherwise, store the original distance.
7. Do not grow or repeatedly append to the result inside the loops.

## Task 4: Vectorized dense matrix

Write:

```r
thresholded_distance_vectorized(x, y, threshold = 0.5)
```

Requirements:

1. Return a regular dense R matrix.
2. Do not use nested loops.
3. Calculate all pairwise distances with vectorized operations. Using
   `outer()` is allowed.
4. Replace distances strictly below `threshold` with `0`.
5. Preserve distances greater than or equal to `threshold`.
6. Return the same values and dimensions as Task 3.

## Task 5: Vectorized sparse matrix

Write:

```r
thresholded_distance_sparse(x, y, threshold = 0.5)
```

Requirements:

1. Reuse the vectorized thresholded calculation from Task 4.
2. Convert the result to a sparse matrix using the `Matrix` package.
3. Return a sparse matrix object, such as a `dgCMatrix`.
4. Preserve the same values and dimensions as Tasks 3 and 4.
5. Do not store explicit zero entries unnecessarily.

## Required correctness checks

Complete the correctness checks before benchmarking. Use this small example:

```r
x_test <- c(0, 1)
y_test <- c(0, 0.5, 2)

expected <- matrix(
  c(0, 0.5, 2,
    1, 0.5, 1),
  nrow = 2,
  byrow = TRUE
)
```

Verify that:

1. the Task 3 result equals `expected`;
2. the Task 4 result equals `expected`;
3. `as.matrix()` of the Task 5 result equals `expected`;
4. the large results have dimensions `3000 x 5000`;
5. every dense output entry is either `0` or at least `0.5`;
6. distances exactly equal to `0.5` are preserved; and
7. Task 5 has the same number of nonzero entries as Task 4.

Use a numerical tolerance when comparing matrices.

## Required performance comparison

Benchmark only after all correctness checks pass. Use the same vectors,
threshold, computer, and timing procedure for each implementation.

Report the following table:

```text
method | elapsed seconds | stored result bytes | nonzero entries
```

At minimum:

- measure elapsed time with `system.time()`;
- measure final-object size with `object.size()`; and
- count sparse nonzero entries with `Matrix::nnzero()`.

Calculate the Task 3-to-Task 4 time gain:

```r
time_gain <- time_loop / time_vectorized
```

Calculate the percentage reduction in elapsed time:

```r
time_reduction_percent <-
  100 * (1 - time_vectorized / time_loop)
```

Calculate the Task 4-to-Task 5 final-object memory reduction:

```r
memory_reduction_percent <-
  100 * (1 - as.numeric(object.size(d_sparse)) /
           as.numeric(object.size(d_dense)))
```

Exact timing results will vary across computers.

## Required written responses

Answer the following questions:

1. If `m = length(x)` and `n = length(y)`, how many pairwise distances must be
   calculated?
2. What is the time complexity of Tasks 3 and 4? State the result using Big-O
   or Big-Theta notation.
3. Does vectorization change the asymptotic complexity, or does it reduce
   implementation costs and constant factors?
4. What speedup and percentage time reduction did you observe from Task 3 to
   Task 4? Was the refactoring useful?
5. Let `k` be the number of nonzero entries after thresholding. Compare the
   storage complexity of the dense and sparse results.
6. What percentage of final-object memory did Task 5 save relative to Task 4?
7. Why can Task 5 produce a smaller final object while still using substantial
   peak memory during conversion from dense to sparse form?

## Submission requirements

Submit:

1. your completed R implementation of Tasks 3-5;
2. all required correctness checks;
3. the timing and memory comparison table;
4. the calculated time gain, time reduction, and memory reduction; and
5. your written responses to the seven questions.

All submitted code must:

- use project-relative paths;
- run with the assignment folder as the working directory;
- use the supplied seed and data dimensions;
- preserve the required strict-threshold rule; and
- run without modifying files in `data-raw/` manually.
