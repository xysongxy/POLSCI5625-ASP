# POLSCI 5625: Applied Statistical Programming

## Overview

This repository contains lab materials for **POLSCI 5625: Applied Statistical Programming**.

Each lab is stored in its own folder and includes a separate README with lab-specific instructions.

## Repository structure

```text
POLSCI5625 Applied Statistical Programming/
|-- Lab1/
|   |-- ...
|-- Lab2/
|   |-- ...
|-- Lab3/
|   |-- ...
|-- Lab4/
|   |-- ...
|-- Lab5/
|   |-- ...
|-- Lab6/
|   |-- ...
|-- Lab8/
|   |-- ...
|-- Lab9/
|   |-- ...
|-- ...
|-- README.md
```

## Labs

### Lab 1: Reproducible simple random sampling

Lab 1 generates a simulated population, draws a reproducible simple random sample, calculates sample means, and tests the sampling function.

See [Lab 1 instructions](Lab1/README.md) for the complete workflow.

### Lab 2: Pairwise distances, vectorization, and sparse matrices

Lab 2 compares nested-loop and vectorized pairwise-distance calculations, then
uses thresholding and sparse matrices to study computational time and memory.

See [Lab 2 instructions](Lab2/README.md) for the complete assignment and
workflow.

### Lab 3: Bootstrap inference

Lab 3 bootstraps the sample mean of a simulated predictor and its OLS slope
using both an explicit loop and the `boot` package. It calculates bootstrap
standard errors, bias estimates, percentile intervals, and basic
(bias-corrected percentile) intervals.

See [Lab 3 instructions](Lab3/README.md) for the complete workflow.

### Lab 4: County distances and computational efficiency

Lab 4 compares nested loops, vectorized arithmetic, and serial and parallel
`foreach` on county coordinates in an in-class exercise. Students compare
running times, speedup, and parallel efficiency.

See [Lab 4 instructions](Lab4/README.md) for the in-class exercise.

### Lab 5: K-means by hand and with a function

Lab 5 implements Lloyd's K-means algorithm with an explicit assignment/update
loop and compares it with `stats::kmeans()`. Students inspect convergence,
multiple random starts, and the effects of feature scaling.

See [Lab 5 instructions](Lab5/README.md) for the in-class exercise.

### Lab 6: EM for Gaussian mixtures

Lab 6 estimates three class proportions, three means, and one shared variance
with a hand-coded EM algorithm. Students compare five starts at three sample
sizes and verify that the observed-data log-likelihood does not decrease.

See [Lab 6 instructions](Lab6/README.md) for the in-class exercise.

### Lab 8: Shingles, MinHash, and locality-sensitive hashing

Lab 8 compares 2-, 4-, and 10-character shingle sets for BBC News articles,
implements 4-shingle MinHash and LSH, and calculates average occupied-bucket
sizes and candidate counts for different band sizes.

See [Lab 8 instructions](Lab8/README.md) for the in-class exercise.

### Lab 9: Getting started with Rcpp

Lab 9 compiles small C++ functions from R and practices scalar arithmetic,
numeric vectors, zero-based indexing, and logical results. Students write
`voteDifference()`, `secondValue()`, and `isEligible()`, then compile and test
them from separate C++ files. A sum-of-squares loop from Lecture 9 is optional.

See [Lab 9 instructions](Lab9/README.md) for setup, exercises, and reference code.

## Folder conventions

Each lab follows the same general organization:

- `data-raw/` contains original or generated population data that should not be edited manually.
- `data/` contains analysis outputs, such as selected samples.
- `R/` contains data-generation scripts and reusable functions.
- `tests/` contains scripts that check whether the functions behave correctly.
- `README.md` explains the purpose of the lab and how to reproduce its results.

## Requirements

- R
- The `Matrix` package for Lab 2
- The `boot` package for Lab 3
- The `foreach`, `doParallel`, and `microbenchmark` packages for Lab 4
- Labs 5, 6, and 8 use base R and the included `stats` package; no additional packages
- The `Rcpp` package and a working C++ compiler for Lab 9; `microbenchmark` is optional

## Running a script

Scripts within a lab use paths relative to that lab's folder. Take Lab1 for example. Before running Lab 1, make `Lab1` the working directory.

If the current working directory is the course repository root, enter Lab 1 interactively with:

```r
setwd("Lab1")
```

Confirm the working directory:

```r
getwd()
```

Generate the Lab 1 population:

```r
source(file.path("R", "gendata.r"))
```

Run the Lab 1 tests:

```r
source(file.path("tests", "lab1_test.r"))
```

Do not place a computer-specific absolute path in the scripts. Using project-relative paths allows the repository to run on another computer after it is downloaded or cloned.

## Reproducibility

Random processes use explicit seeds. Given the same data, sample size, and seed, the analysis will select the same observations and produce the same results.

## Author

Xiangyu Song

## Course information

- Course: POLSCI 5625, Applied Statistical Programming
- Instructor: Ted Enamorado
- Assistant Instructor: Xiangyu Song
