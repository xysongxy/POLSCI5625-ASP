# Lab 11: Bayesian Ideal Points from Roll-Call Votes

## Overview

Use `Rvoteview` to download House roll-call votes for Congress 119, estimate
one-dimensional ideal points with `pscl::ideal()`, and add the posterior means
to a legislator table. The R script uses the code supplied for this lab.

This lab follows Lecture 11: roll-call data and latent ideology (slides 2-5),
the probit item-response model (slides 11-15), joint estimation (slides 19-20),
identification and normalization (slides 21-23), and Bayesian estimation
(slide 25).

## Learning objectives

1. Explain how observed roll-call votes inform unobserved ideal points.
2. Download a `rollcall` object and identify its legislator metadata.
3. Construct party-based starting values for a one-dimensional model.
4. Explain the arguments in the supplied `ideal()` call.
5. Inspect posterior means and add them to a `data.table`.

## Project structure

```text
Lab11/
|-- R/
|   |-- lab11.r       # supplied in-class code
|-- README.md
```

## Requirements and setup

Use R with `Rvoteview`, `data.table`, and `pscl`, plus internet access for the
Voteview search and download. Install packages once if needed:

```r
install.packages(c("data.table", "pscl", "remotes"))
remotes::install_github("voteview/Rvoteview")
```

From the course repository root in R:

```r
setwd("Lab11")
```

## In-class exercise

Open `R/lab11.r` and run the supplied code section by section. Use the
questions below to connect the commands to Lecture 11.

### Task 1: Search for and download roll-call votes

```r
library("Rvoteview")
library('data.table')
library(pscl)

res <- voteview_search(chamber = "House", congress = 119)
rc <- voteview_download(res$id)
```

`res` contains the search results. `res$id` supplies the roll-call identifiers
for the download. `rc` is a `rollcall` object: rows of its voting matrix
represent legislators, and columns represent roll calls. `rc$legis.data`
contains legislator metadata.

1. What is the difference between `res` and `rc`?
2. What does one entry of the voting matrix represent?
3. Why does the lecture use voting patterns rather than just total Yea votes
   to learn about ideology?

### Task 2: Construct starting values

```r
n <- dim(rc$legis.data)[1]
x0 <- rep(0,n)
x0[rc$legis.data$party_code=="100"] <- -1
x0[rc$legis.data$party_code=="200"] <- 1
```

`n` is the number of rows in the legislator metadata. `x0` starts as a
length-`n` vector of zeros. Party code 100 identifies Democrats, whose
starting values become -1; code 200 identifies Republicans, whose starting
values become 1. Other party codes retain zero.

These values initialize estimation. They do not fix legislators' positions
or specify party-specific priors.

1. Why does `x0` need one value per legislator?
2. What does each logical expression inside `[]` select?
3. Must a Democrat's estimated ideal point equal -1? Explain.

### Task 3: Estimate ideal points

```r
id1 <- ideal(rc,
             d=1,
             startvals=list(x=x0),
             normalize=TRUE,
             maxiter=10000,
             burnin=100,
             thin=100)
```

The model links a legislator's ideal point to the probability of voting Yea:

```math
P(Y_{ij}=1\mid\theta_i,\alpha_j,\beta_j)
=\Phi(\alpha_j\theta_i-\beta_j).
```

The ideal point is $\theta_i$. Each roll call has a discrimination/direction
parameter $\alpha_j$ and a location parameter $\beta_j$. `ideal()` estimates
legislator and roll-call parameters jointly using MCMC.

| Argument | Meaning |
|---|---|
| `d=1` | Estimate one latent dimension |
| `startvals=list(x=x0)` | Supply initial legislator positions |
| `normalize=TRUE` | Normalize the location and scale of the estimated axis |
| `maxiter=10000` | Run through MCMC iteration 10,000 |
| `burnin=100` | Set the burn-in boundary at iteration 100 |
| `thin=100` | Record draws at intervals of 100 iterations |

1. How does `d=1` relate to the lecture's policy space?
2. Why does the latent axis need normalization?
3. Does normalization determine which end is liberal or conservative?
4. Why are starting values different from fixed identification constraints?

### Task 4: Inspect and attach posterior means

```r
id1$n
id1$m

id1$xbar
id1$codes

legis119 <- data.table(rc$legis.data)
legis119$ideal <- id1$xbar
```

`id1$n` and `id1$m` report the numbers of legislators and roll calls used in
the analysis. `id1$xbar` contains posterior mean ideal points, and
`id1$codes` records the vote-coding definitions. The final two commands
convert the legislator metadata to a `data.table` and add the estimated
positions as `ideal`.

This assignment assumes the metadata rows and fitted estimates correspond
in the same order. Inspect the reported dimensions when interpreting the
output.

1. What is the difference between `x0` and `id1$xbar`?
2. Are `id1$codes` vote codes or party codes?
3. What information does `legis119` combine?
4. Why does a posterior mean summarize uncertainty rather than eliminate it?

## How to run

From the course repository root in R:

```r
setwd("Lab11")
source(file.path("R", "lab11.r"), echo = TRUE)
```

For in-class work, run each section interactively so students can inspect
the objects before continuing. The download and model fit may take time.

## Reproducibility and interpretation

The script queries the live Voteview database and uses stochastic MCMC
estimation. Downloaded data and estimates can differ across runs. The
supplied code does not set a random seed or save files.

The MCMC settings are for the in-class demonstration. Completing the run
does not by itself establish convergence. Interpret the estimated dimension
in relation to the analyzed votes and the lecture's identification discussion.

## Author

Xiangyu Song

## Date

2026-11-10
