# Lab 5: K-means by Hand and with a Function

## Overview

In this lab, implement K-means in two ways: write the assignment and center
updates yourself, then use R's `stats::kmeans()` function. Compare the results
using the same data, starting centers, and Lloyd algorithm.

The lab follows the K-means material in Week 5 (slides 4-11). 
Both implementations are in `R/lab5.r`: the
hand-coded assignment/update functions and `kmeans_function()`, which calls
`stats::kmeans()`. One figure shows the main stages.

## Learning objectives

1. Calculate squared distances and assign observations to their nearest center.
2. Update each center to the mean of its assigned observations.
3. Repeat these steps until assignments stop changing.
4. Compare a hand-coded implementation with `stats::kmeans()`.
5. Explain the effects of initialization, multiple starts, and feature scaling.

## Project structure

```text
Lab5/
|-- data-raw/
|   |-- demonstration.csv
|-- R/
|   |-- lab5.r
|   |-- run_lab5.r
|-- results/
|   |-- method_comparison.csv
|   |-- objective_history.csv
|   |-- cluster_assignments.csv
|   |-- kmeans_steps.pdf
|   |-- kmeans_iterations.pdf
|-- tests/
|   |-- lab5_test.r
|-- README.md
```

## Requirements

R only. The `stats` package is included with R; no packages need to be installed.

## Data and objective

The supplied CSV contains 500 observations:

- `love`: first numeric feature;
- `hapiness`: second numeric feature; keep the original column spelling;
- `cluster`: source labels (`Head`, `Ear_left`, `Ear_right`, and `Noise`).

Use only `love` and `hapiness` as clustering inputs. Keep all 500 rows,
including the 10 labeled `Noise`. Source labels can help describe the final
result, but they are not inputs or targets. K-means assigns every observation
to a cluster. Set K = 3 as in the demonstration; the source labels do not
determine K.

K-means seeks a small within-cluster sum of squares (WCSS):

```text
J = sum over observations i of:
    (love[i] - center[cluster[i], 1])^2 +
    (hapiness[i] - center[cluster[i], 2])^2
```

The assignment step chooses the closest center. The update step replaces each
center with the mean of its members. Neither step increases J.

## In-class exercise

Write your own functions before consulting the complete reference implementations
in `R/lab5.r`. Both methods belong in that file. The runner in
`R/run_lab5.r` calls them, compares their results, and saves the outputs.

### Setup: Read and inspect the data

```r
data <- read.csv(file.path("data-raw", "demonstration.csv"))
x <- as.matrix(data[, c("love", "hapiness")])
initial_centers <- rbind(c(0.39, 0.39), c(0.40, 0.40), c(0.41, 0.41))
colnames(initial_centers) <- colnames(x)
```

Check the dimensions and plot the two features. Add the three initial centers
with a different plotting symbol. These are the supplied starting positions,
before any assignment or update.

### Task 1: Hand-code one iteration

Write `kmeans_step(x, centers)`:

1. Preallocate an N by K distance matrix.
2. Loop over centers. For each center, calculate squared distances from all
   observations using the two columns of `x`.
3. Use `apply(distances, 1, which.min)` to assign each row to its nearest center.
4. Loop over clusters and use `colMeans()` to update each center.
5. Return the assignments, updated centers, and WCSS.

Use `x[cluster == j, , drop = FALSE]` to keep a matrix even if a cluster has
one member. If a cluster is empty, stop with an informative message and choose
different starting centers; this teaching implementation does not relocate it
automatically. `which.min()` resolves a distance tie in favor of the first center.

Run the function once. Plot the assignments with the old centers, then plot the
same assignments with the updated centers. The assignments change again only
at the next assignment step.

Discuss: Why can we omit the square root when choosing a center? Why is the
updated center a mean rather than a median?

### Task 2: Repeat until convergence

Write `kmeans_hand(x, centers, iter.max = 100L)`. Repeatedly call the one-step
function and pass its updated centers to the next iteration.

Store WCSS after each complete assignment/update cycle. Stop when assignments
are unchanged from the previous cycle. Include an iteration limit and report
whether convergence was reached.

Run with `initial_centers`. Plot WCSS against iteration. Check that it never
increases and that each final center equals the mean of its cluster.

The two hand-coded functions are intentionally specific to two numeric
features. They use no calls to `kmeans()`.

### Task 3: Use R's K-means function

Add `kmeans_function()` alongside the hand-coded functions in `R/lab5.r`.
It calls `stats::kmeans()` with `algorithm = "Lloyd"` and passes through
`centers`, `nstart`, and `iter.max`. Use it to fit the same data:

```r
hand <- kmeans_hand(x, initial_centers, iter.max = 100L)
builtin <- kmeans_function(x, initial_centers, iter.max = 100L)

table(hand$cluster, builtin$cluster)
hand$centers
builtin$centers
c(hand = hand$tot.withinss, builtin = builtin$tot.withinss)
```

Inspect `cluster`, `centers`, `size`, and `tot.withinss`. Check that the
two methods agree on the partition and objective.

R uses **Hartigan-Wong** by default. Specify `algorithm = "Lloyd"` to match
the hand-coded algorithm; this makes the algorithm explicit in the slide 9
example too. Cluster numbers are arbitrary: a one-to-one correspondence in the
cross-tabulation represents the same partition even if labels are permuted.
Iteration counts can differ because implementations count convergence checks
differently.

### Task 4: Multiple starts and scaling

First run `kmeans(x, centers = 3, nstart = 25, iter.max = 100,
algorithm = "Lloyd")` after `set.seed(123)`. A numeric `centers = 3` asks R
to choose starting centers from the data. `nstart = 25` tries 25 initializations
and keeps the result with the smallest WCSS among those runs.

Then standardize the features:

```r
x_scaled <- scale(x)
set.seed(123)
scaled_fit <- stats::kmeans(
  x_scaled, centers = 3L, nstart = 25L, iter.max = 100L, algorithm = "Lloyd"
)
```

We first use the original scale to reproduce the demonstration. Although both
variables lie roughly between 0 and 1, their standard deviations differ.
Standardization changes their relative weights in the distance calculation.
Use the same transformation for both methods when comparing implementations.

Compare the original-scale fixed-start and multiple-start results. They may
agree; more starts do not necessarily improve this particular fit. Inspect
`table(hand$cluster, scaled_fit$cluster)` to see how scaling affects membership.
Do not compare original-scale and standardized WCSS directly: their units differ.
Centers from `scaled_fit` are in standardized units.

## Discuss the results

1. Why does each assignment and update step avoid increasing WCSS?
2. Does convergence establish that the global minimum was found?
3. What does `nstart` change, and what does `iter.max` change?
4. How can changing measurement units change the clusters?
5. Why might the fitted clusters differ from the supplied source labels,
   especially for noise observations?

Multiple starts reduce sensitivity to initialization but do not guarantee a
global optimum. K-means favors compact groups under squared Euclidean distance;
it does not learn the source labels.

## How to run

Set `Lab5` as the working directory. From the course repository root:

```r
setwd("Lab5")
source(file.path("tests", "lab5_test.r"))
source(file.path("R", "run_lab5.r"))
```

The runner saves three CSV files and `results/kmeans_steps.pdf`. The figure
shows initial centers, the first assignment, the first update, the two final
fits, and the objective history. Crosses mark centers and colors mark fitted
clusters.

The CSV files contain the method comparison, the hand-coded objective history,
and observation-level assignments. In `cluster_assignments.csv`, the original
`cluster` column contains source labels; the other cluster columns contain
fitted memberships.

## Illustration of every iteration

Open `results/kmeans_iterations.pdf` after running the runner. The first page
shows the raw data and initial centers. Each following page shows one iteration:

- **A: Assignment.** Point colors show the new memberships; crosses stay at
  the previous centers.
- **B: Center update.** Point colors stay unchanged; crosses move to the means
  of those clusters.

The panels report WCSS after each step. Follow the pages to see assignments and
centers stabilize. With the supplied starts, there are 19 iterations; the last
iteration confirms that assignments no longer change.

The hand-coded function stores each iteration in `hand$steps`. The runner plots
those saved states in one short loop, so the original demonstration's repeated
plotting blocks are unnecessary. Both K-means implementations remain together
in `R/lab5.r`.

## Reproducibility

The input CSV is copied unchanged from the supplied demonstration. Fixed-center
fits are deterministic; random-start fits use seed `123`. Paths are relative
to `Lab5`. The tests check an example with known answers, ties, empty clusters,
the iteration limit, convergence, agreement with R, and seeded reproducibility.

## Author

Xiangyu Song

## Date

2026-09-22
