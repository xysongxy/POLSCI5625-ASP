# Lab 1: Reproducible Simple Random Sampling

## Overview

This lab demonstrates how to make a sampling analysis reproducible using base R. The analysis draws a simple random sample from a simulated population and computes sample means for education level and income.

The population contains 10,000 observations:

- `educ` is generated from a Poisson distribution with `lambda = 12`.
- `income` is generated from a log-normal distribution with a median of approximately $50,000 and `sdlog = 0.5`.

The two variables are generated independently.

## Learning objectives

After completing this lab, students should be able to:

1. Write reusable functions with explicit inputs.
2. Draw a reproducible simple random sample without replacement.
3. Compute a sample mean from selected observations.
4. Use project-relative file paths.
5. Test reproducibility and invalid input handling.

## Project structure

```text
Lab1/
|-- data/
|   |-- lab1.csv
|   |-- sample_500.csv
|-- data-raw/
|   |-- lab1.csv
|-- R/
|   |-- gendata.r
|   |-- lab1.r
|-- tests/
|   |-- lab1_test.r
|-- README.md
```

`sample_500.csv` is created when the test script runs.

## Files

### `data-raw/lab1.csv`

This is the original simulated population produced by the data-generation script. Files in `data-raw` should not be edited manually.

### `data/sample_500.csv`

This is the sample of 500 observations created when `tests/lab1_test.r` runs.

### `R/gendata.r`

This script generates the population data. It uses a fixed seed so that the generated population is reproducible, then saves the population using project-relative paths.

### `R/lab1.r`

This script defines two functions:

- `draw_sample()` draws a simple random sample without replacement. The population, sample size, and random seed are explicit inputs.
- `compute_sample_mean()` calculates the mean of a selected numeric variable.

The functions check their inputs and return informative errors for invalid requests.

### `tests/lab1_test.r`

This script:

1. Loads the functions using a project-relative path.
2. Reads the simulated population from `data-raw/lab1.csv`.
3. Draws 500 observations using seed `123`.
4. Computes the sample means of education level and income.
5. Runs the two required tests.
6. Saves the selected sample as `data/sample_500.csv`.

## Requirements

- R
- No additional packages are required.

## How to run the analysis

Start R with `Lab1` as the working directory. Confirm the working directory with:

```r
getwd()
```

To generate the population data, run:

```r
source(file.path("R", "gendata.r"))
```

Run the tests and analysis with:

```r
source(file.path("tests", "lab1_test.r"))
```

Using `file.path()` keeps the paths project-relative and makes the project easier to run on another computer.

## Tests

### Test 1: Identity

The script draws the sample twice using the same population, sample size, and seed. The two samples must be identical.

Expected message:

```text
PASS: the same seed produces an identical sample.
```

### Test 2: Impossible sample size

The script requests more observations than exist in the population. The sampling function must stop with an informative error.

Expected message:

```text
PASS: an oversized sample returns an informative error.
```

If both tests succeed, the script finishes with:

```text
All tests passed.
```

## Reproducibility

The seed is passed directly to the sampling function. Running the function with the same population, sample size, and seed produces the same selected observations. Changing the seed produces a different random sample.

## Author

Xiangyu Song

## Date

2026-08-25
