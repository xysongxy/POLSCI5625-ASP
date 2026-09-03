######################################################
#                                                    #
# Lab 2: Pairwise distance performance               #
#                                                    #
# R/lab2.r                                           #
#                                                    #
# In-class reference implementations for:            #
#   Task 1. nested-loop pairwise distances           #
#   Task 2. vectorized pairwise distances            #
#                                                    #
######################################################

validate_pairwise_inputs <- function(x, y) {
  valid_x <-
    is.numeric(x) &&
    is.atomic(x) &&
    is.null(dim(x)) &&
    length(x) > 0L &&
    all(is.finite(x))

  valid_y <-
    is.numeric(y) &&
    is.atomic(y) &&
    is.null(dim(y)) &&
    length(y) > 0L &&
    all(is.finite(y))

  if (!valid_x) {
    stop("`x` must be a non-empty numeric vector of finite values.", call. = FALSE)
  }

  if (!valid_y) {
    stop("`y` must be a non-empty numeric vector of finite values.", call. = FALSE)
  }

  invisible(TRUE)
}

# Task 1. Pairwise distances with nested loops

# For one-dimensional points, Euclidean distance is abs(x[i] - y[j]).
# Rows correspond to x and columns correspond to y.

pairwise_distance_loop <- function(x, y) {
  validate_pairwise_inputs(x, y)

  distances <- matrix(
    0,
    nrow = length(x),
    ncol = length(y)
  )

  for (i in seq_along(x)) {
    for (j in seq_along(y)) {
      distances[i, j] <- abs(x[i] - y[j])
    }
  }

  distances
}


# Task 2. Pairwise distances with vectorized base R code using outer()

pairwise_distance_vectorized <- function(x, y) {
  validate_pairwise_inputs(x, y)

  abs(outer(x, y, FUN = "-"))
}


# Task 2. Hand-coded vectorized version without outer()

# Repeat x across the columns of a matrix, then use sweep() to subtract y[j]
# from column j. This is a second implementation of the same calculation.

pairwise_distance_vectorized_handcoded <- function(x, y) {
  validate_pairwise_inputs(x, y)

  x_matrix <- matrix(
    x,
    nrow = length(x),
    ncol = length(y)
  )

  abs(sweep(x_matrix, MARGIN = 2L, STATS = y, FUN = "-"))
}


# Small helpers used by the benchmark script

elapsed_seconds <- function(fun, ...) {
  timing <- system.time(fun(...))
  unname(timing[["elapsed"]])
}
