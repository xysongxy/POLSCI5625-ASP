######################################################
#                                                    #
# Lab 2 in-class exercise: Tasks 1-2 tests           #
#                                                    #
# tests/lab2_test.r                                  #
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

x <- c(0, 1)
y <- c(0, 0.5, 2)

expected <- matrix(
  c(0, 0.5, 2, 1, 0.5, 1),
  nrow = 2L,
  byrow = TRUE
)

d_loop <- pairwise_distance_loop(x, y)
d_outer <- pairwise_distance_vectorized(x, y)
d_handcoded <- pairwise_distance_vectorized_handcoded(x, y)

stopifnot(
  identical(dim(d_loop), c(2L, 3L)),
  isTRUE(all.equal(d_loop, expected, tolerance = 1e-12)),
  isTRUE(all.equal(d_loop, d_outer, tolerance = 1e-12)),
  isTRUE(all.equal(d_loop, d_handcoded, tolerance = 1e-12))
)

cat("PASS: loop, outer(), and hand-coded vectorized distances agree.\n")

invalid_vector_error <- tryCatch(
  {
    pairwise_distance_vectorized(c(0, NA_real_), y)
    NA_character_
  },
  error = function(e) conditionMessage(e)
)

stopifnot(
  !is.na(invalid_vector_error),
  grepl("non-empty numeric vector", invalid_vector_error, fixed = TRUE)
)

cat("PASS: invalid vector inputs return an informative error.\n")
cat("All Tasks 1-2 tests passed.\n")
