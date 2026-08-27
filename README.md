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
|-- ...
|-- README.md
```

## Labs

### Lab 1: Reproducible simple random sampling

Lab 1 generates a simulated population, draws a reproducible simple random sample, calculates sample means, and tests the sampling function.

See [Lab 1 instructions](Lab1/README.md) for the complete workflow.

## Folder conventions

Each lab follows the same general organization:

- `data-raw/` contains original or generated population data that should not be edited manually.
- `data/` contains analysis outputs, such as selected samples.
- `R/` contains data-generation scripts and reusable functions.
- `tests/` contains scripts that check whether the functions behave correctly.
- `README.md` explains the purpose of the lab and how to reproduce its results.

## Requirements

- R

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
