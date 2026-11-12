######################################################
#                                                    #
# Lab 11: Bayesian ideal points from roll-call votes #
#                                                    #
# R/lab11.r                                          #
#                                                    #
# In-class implementation from Lecture 11:           #
#   Task 1. search and download roll-call votes      #
#   Task 2. construct party-based starting values    #
#   Task 3. estimate a one-dimensional ideal model   #
#   Task 4. inspect and attach posterior means       #
#                                                    #
######################################################

# Rvoteview searches/downloads votes; data.table creates the legislator table;
# pscl provides ideal() for Bayesian ideal-point estimation.
library("Rvoteview")
library('data.table')
library(pscl)


# Task 1. Search for and download roll-call votes.
# Search for House roll calls from Congress 119. res contains vote metadata.
res <- voteview_search(chamber = "House", congress = 119)
# Use the returned vote IDs to download a rollcall object.
# In rc$votes, rows are legislators and columns are roll-call votes.
# rc$legis.data contains information about those legislators.
rc <- voteview_download(res$id)
# Check: how are the search results different from the downloaded object?


# Task 2. Construct party-based starting values.
# Count the legislators, then create one initial position per legislator.
n <- dim(rc$legis.data)[1]
x0 <- rep(0,n)
# Party code 100 = Democrat; party code 200 = Republican.
# Start Democrats at -1 and Republicans at 1; other party codes retain zero.
x0[rc$legis.data$party_code=="100"] <- -1
x0[rc$legis.data$party_code=="200"] <- 1
# These are initial values, not fixed positions or party-specific priors.
# Check: why must x0 have one entry for each legislator?


# Task 3. Estimate a one-dimensional ideal-point model.
# ideal() uses observed voting patterns to estimate latent positions with MCMC.
# d=1: estimate one latent dimension.
# startvals: supply x0 as the initial legislator positions.
# normalize=TRUE: recenter/rescale the output to identify location and scale;
# this does not by itself determine which end is liberal or conservative.
# maxiter=10000: run through iteration 10,000, including burn-in.
# burnin=100: set the burn-in boundary at iteration 100.
# thin=100: record draws at intervals of 100 iterations.
id1 <- ideal(rc,
             d=1,
             startvals=list(x=x0),
             normalize=TRUE,
             maxiter=10000,
             burnin=100,
             thin=100)
# Check: why can estimated positions differ from the starting values?


# Task 4. Inspect the output and attach posterior means.
# Report the numbers of legislators (n) and roll calls (m) used in the fit.
id1$n
id1$m

# Posterior mean ideal points: one row per fitted legislator, one dimension.
id1$xbar
# Definitions of the voting codes used by the model, not party codes.
id1$codes

# Convert legislator metadata to a data.table and add the estimated positions.
# This assignment assumes metadata and estimates refer to the same legislators
# in the same order. Compare their dimensions when inspecting the output.
legis119 <- data.table(rc$legis.data)
legis119$ideal <- id1$xbar
# Inspect legis119 to see legislator information alongside estimated positions.
