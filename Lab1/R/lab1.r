######################################################
#                                                    #
# Lab1: Basic function and project directory         #
#                                                    #
# R/lab1.r                                           #
#                                                    #
# A simple sampling script                           #
#   1. Draw a random sample of 500 observations      #
#   2. Write a function that computes the sample mean#
#   3. Replace hard-coded input and output paths with#
#      project-relative paths                        #
#                                                    #
######################################################

# 1. Draw a random sample without replacement

# Arguments:
#   pop:  A data frame containing the full population.
#   n:    A positive whole number no larger than the population.
#   seed: A non-negative whole number used for reproducibility.
#
# Returns:
#   A data frame containing the selected rows of the population.

draw_sample <- function(pop, n, seed) {
  if (!is.data.frame(pop)) {
    stop("`population` must be a data frame.", call. = FALSE)
  }

  if (nrow(pop) == 0L) {
    stop("`population` must not be empty.", call. = FALSE)
  }

  validsample <-
    length(n) == 1L &&
    is.numeric(n) &&
    !is.na(n) &&
    is.finite(n) &&
    n > 0L &&
    n == floor(n)

  if (!validsample) {
    stop("`n` must be a positive whole number.", call. = FALSE)
  }

  if (n > nrow(pop)) {
    stop(
      sprintf(
        "Requested sample size (%d) cannot exceed population size (%d).",
        n,
        nrow(pop)
      ),
      call. = FALSE
    )
  }

  validseed <-
    length(seed) == 1L &&
    is.numeric(seed) &&
    !is.na(seed) &&
    is.finite(seed) &&
    seed >= 0L &&
    seed <= .Machine$integer.max &&
    seed == floor(seed)

  if (!validseed) {
    stop("`seed` must be a non-negative whole number.", call. = FALSE)
  }

  set.seed(as.integer(seed))

  samplerows <- sample.int(
    n = nrow(pop),
    size = as.integer(n),
    replace = FALSE
  )

  pop[samplerows, , drop = FALSE]
}


# 2. Compute a sample mean

# Arguments:
#   sample:   A data frame returned by the sampling function.
#   variable: The name of the numeric variable.
#
# Returns:
#   One numeric value: the sample mean. Missing values are excluded.

compute_sample_mean <- function(sample, variable) {
  if (!is.data.frame(sample)) {
    stop("`sample` must be a data frame.", call. = FALSE)
  }

  if (nrow(sample) == 0L) {
    stop("`sample` must not be empty.", call. = FALSE)
  }

  if (length(variable) != 1L || !is.character(variable)) {
    stop("`variable` must be a single string.", call. = FALSE)
  }

  if (!(variable %in% names(sample))) {
    stop(
      sprintf("Variable '%s' was not found in `sample`.", variable),
      call. = FALSE
    )
  }

  values <- sample[[variable]]

  if (!is.numeric(values)) {
    stop(
      sprintf("Variable '%s' must be numeric.", variable),
      call. = FALSE
    )
  }

  if (all(is.na(values))) {
    stop(
      sprintf("Variable '%s' contains only missing values.", variable),
      call. = FALSE
    )
  }

  mean(values, na.rm = TRUE)
}
