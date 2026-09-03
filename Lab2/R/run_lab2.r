######################################################
#                                                    #
# Lab 2 in-class exercise: Tasks 1-2                 #
#                                                    #
# R/run_lab2.r                                       #
#                                                    #
# Check and benchmark the loop, outer(), and         #
# hand-coded vectorized implementations.             #
#                                                    #
######################################################

functions_path <- file.path("R", "lab2.r")

if (!file.exists(functions_path)) {
  stop(
    paste0(
      "Cannot find '", functions_path, "'. ",
      "Set the working directory to the Lab2 folder and try again."
    ),
    call. = FALSE
  )
}

source(functions_path)

set.seed(123)
x <- runif(1000L)
y <- runif(3000L)

d_loop <- pairwise_distance_loop(x, y)
d_outer <- pairwise_distance_vectorized(x, y)
d_handcoded <- pairwise_distance_vectorized_handcoded(x, y)

stopifnot(
  identical(dim(d_loop), c(1000L, 3000L)),
  isTRUE(all.equal(d_loop, d_outer, tolerance = 1e-12)),
  isTRUE(all.equal(d_loop, d_handcoded, tolerance = 1e-12))
)

timing <- data.frame(
  experiment = "1000 x 3000 absolute differences",
  method = c(
    "nested loop",
    "vectorized outer",
    "vectorized hand-coded"
  ),
  elapsed_seconds = c(
    elapsed_seconds(pairwise_distance_loop, x, y),
    elapsed_seconds(pairwise_distance_vectorized, x, y),
    elapsed_seconds(pairwise_distance_vectorized_handcoded, x, y)
  ),
  stringsAsFactors = FALSE
)

timing$time_gain_over_loop <-
  timing$elapsed_seconds[1] / timing$elapsed_seconds

timing$time_reduction_percent <-
  100 * (1 - timing$elapsed_seconds / timing$elapsed_seconds[1])

dir.create("results", showWarnings = FALSE)

write.csv(
  timing,
  file = file.path("results", "small_timing.csv"),
  row.names = FALSE
)

cat("Tasks 1-2 timing:\n")
print(timing)
