######################################################
#                                                    #
# Lab 9: Getting started with Rcpp                   #
#                                                    #
# tests/lab9_test.r                                  #
#                                                    #
# Compile the three exercise C++ files with Rcpp.    #
# Call each function and check known answers.        #
# Stop if an answer or an export is missing.         #
#                                                    #
######################################################

# Run from Lab9 with source(file.path("tests", "lab9_test.r")),
# or from a terminal with Rscript tests/lab9_test.r.
if (!requireNamespace("Rcpp", quietly = TRUE)) {
  stop("Install Rcpp with install.packages('Rcpp') before running the tests.",
       call. = FALSE)
}

# Step 1. Compile the files and create their R-callable functions.
# A fresh environment prevents old functions in the workspace from being used.
exercise_functions <- new.env(parent = globalenv())
Rcpp::sourceCpp(file.path("src", "voteDifference.cpp"), env = exercise_functions)
Rcpp::sourceCpp(file.path("src", "secondValue.cpp"), env = exercise_functions)
Rcpp::sourceCpp(file.path("src", "isEligible.cpp"), env = exercise_functions)

# Check that all three functions were exported from the C++ files.
stopifnot(
  exists("voteDifference", envir = exercise_functions,
         mode = "function", inherits = FALSE),
  exists("secondValue", envir = exercise_functions,
         mode = "function", inherits = FALSE),
  exists("isEligible", envir = exercise_functions,
         mode = "function", inherits = FALSE)
)

# Step 2. Call the compiled functions and compare them with known answers.
# stopifnot() stops the script with an error if a check is FALSE.
with(exercise_functions, {
  # Exercise 1. Check a positive margin, a negative margin, and ties.
  cat("voteDifference(620, 580) =", voteDifference(620, 580), "(expected 40)\n")
  stopifnot(
    isTRUE(all.equal(voteDifference(620, 580), 40)),
    isTRUE(all.equal(voteDifference(580, 620), -40)),
    isTRUE(all.equal(voteDifference(600, 600), 0)),
    isTRUE(all.equal(voteDifference(0, 25), -25))
  )
  cat("PASS: voteDifference() returns the signed vote margin.\n\n")

  # Exercise 2. Distinct values reveal an incorrect C++ index.
  cat("secondValue(c(12, 18, 21, 30)) =",
      secondValue(c(12, 18, 21, 30)), "(expected 18)\n")
  stopifnot(
    isTRUE(all.equal(secondValue(c(12, 18, 21, 30)), 18)),
    isTRUE(all.equal(secondValue(c(7, 9)), 9)),
    isTRUE(all.equal(secondValue(c(-4.5, 2.25, 8)), 2.25))
  )
  # Too-short vectors must raise an R error instead of reading invalid memory.
  one_value <- try(secondValue(7), silent = TRUE)
  no_values <- try(secondValue(numeric(0)), silent = TRUE)
  stopifnot(inherits(one_value, "try-error"), inherits(no_values, "try-error"))
  cat("PASS: secondValue() returns the second value and rejects short vectors.\n\n")

  # Exercise 3. Check both sides of the boundary and age 18 itself.
  cat("isEligible(18) =", isEligible(18), "(expected TRUE)\n")
  stopifnot(
    identical(isEligible(16), FALSE),
    identical(isEligible(17.9), FALSE),
    identical(isEligible(18), TRUE),
    identical(isEligible(21), TRUE)
  )
  cat("PASS: isEligible() returns a logical result and includes age 18.\n\n")
})

cat("All Lab 9 C++ exercise tests passed.\n")
