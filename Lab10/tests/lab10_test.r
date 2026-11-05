######################################################
#                                                    #
# Lab 10: Loops, matrices, and lists with Rcpp       #
#                                                    #
# tests/lab10_test.r                                 #
#                                                    #
# Compile the Lecture 10 C++ functions with Rcpp.    #
# Call each function and check the slide examples.   #
#                                                    #
######################################################

# Run from Lab10 with source(file.path("tests", "lab10_test.r")),
# or from a terminal with Rscript tests/lab10_test.r.
lecture_functions <- new.env(parent = globalenv())
cpp_files <- c(
  "squareOne", "squareAll", "sumSquares", "positivePart", "countAbove",
  "stepsToTotal", "meanLoop", "minLoop", "rowTotals", "describe",
  "sugarExamples", "firstValue", "addVectors", "dotProduct"
)
for (name in cpp_files) {
  Rcpp::sourceCpp(file.path("src", paste0(name, ".cpp")),
                  env = lecture_functions)
  stopifnot(exists(name, envir = lecture_functions,
                   mode = "function", inherits = FALSE))
}

with(lecture_functions, {
  # Tasks 1-2. Scalar and vector outputs; the accumulator example.
  stopifnot(
    isTRUE(all.equal(squareOne(3), 9)),
    isTRUE(all.equal(squareAll(c(2, 3, 4)), c(4, 9, 16))),
    isTRUE(all.equal(sumSquares(c(2, 3)), 13)),
    isTRUE(all.equal(sumSquares(c(2, 3, 4)), 29))
  )
  cat("PASS: scalar squares, vector squares, and sum of squares.\n")

  # Task 3. The supplied examples include positive, zero, and missing values.
  stopifnot(
    isTRUE(all.equal(positivePart(c(-2, 0, 3, NA)), c(0, 0, 3, NA))),
    identical(countAbove(c(0.2, NA, 0.8, 0.9), 0.5), 2L)
  )
  cat("PASS: conditionals and the threshold count.\n")

  # Task 4. Check both the printed diagnostics and returned step count.
  diagnostics <- capture.output(steps <- stepsToTotal(6))
  stopifnot(
    identical(diagnostics, c("1 1", "2 3", "3 6")),
    identical(steps, 3L),
    isTRUE(all.equal(meanLoop(c(2, 4, 6)), 4)),
    isTRUE(all.equal(minLoop(c(4, 2, 7)), 2))
  )
  cat("PASS: while-loop output, sample mean, and minimum.\n")

  # Task 5. A rectangular matrix makes the row and column roles visible.
  A <- matrix(1:6, nrow = 2)
  stopifnot(
    isTRUE(all.equal(rowTotals(A), c(9, 12))),
    isTRUE(all.equal(rowTotals(A), rowSums(A)))
  )
  cat("PASS: matrix row totals.\n")

  # Task 6. Check every named result and the list-input example.
  ans <- describe(c(10, 20), matrix(0, 3, 2))
  stopifnot(
    identical(names(ans), c("length", "nrow", "ncol", "first")),
    ans$length == 2, ans$nrow == 3, ans$ncol == 2, ans$first == 10
  )
  sugar <- sugarExamples(c(-2, 0, 2))
  stopifnot(
    identical(names(sugar),
              c("absolute", "exponential", "cube", "positive", "negative")),
    isTRUE(all.equal(sugar$absolute, c(2, 0, 2))),
    isTRUE(all.equal(sugar$exponential, exp(c(-2, 0, 2)))),
    isTRUE(all.equal(sugar$cube, c(-8, 0, 8))),
    identical(sugar$positive, c(FALSE, FALSE, TRUE)),
    isTRUE(all.equal(sugar$negative, c(2, 0, -2))),
    isTRUE(all.equal(firstValue(list(x = c(7, 9))), 7))
  )
  cat("PASS: named lists, vector expressions, and list extraction.\n")

  # Task 7. Addition returns a vector; the dot product returns one number.
  x <- c(1, 2, 3)
  y <- c(4, 5, 6)
  stopifnot(
    isTRUE(all.equal(addVectors(x, x), c(2, 4, 6))),
    isTRUE(all.equal(dotProduct(x, y), 32)),
    isTRUE(all.equal(dotProduct(x, y), sum(x * y)))
  )
  cat("PASS: vector addition and the dot product.\n")
})

cat("All Lab 10 C++ example tests passed.\n")
