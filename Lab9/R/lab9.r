######################################################
#                                                    #
# Lab 9: Getting started with Rcpp                   #
#                                                    #
# R/lab9.r                                           #
#                                                    #
# In-class reference implementations for:            #
#   Task 1. scalar arithmetic and vote difference    #
#   Task 2. numeric vectors and element access       #
#   Task 3. comparisons and age eligibility          #
#                                                    #
######################################################

# Try R/lab9_exercises.r before consulting these solutions.

if (!requireNamespace("Rcpp", quietly = TRUE)) {
  stop("Install Rcpp with install.packages('Rcpp') before starting Lab 9.",
       call. = FALSE)
}
library(Rcpp)


# Task 1. Scalar inputs and a scalar return value.
# Use finite, nonmissing scalars in these teaching functions.

cppFunction('
  double addNumbers(double x, double y) {
    return x + y;
  }
')

# Example: combine vote totals from two precincts.
precinct_one <- 120
precinct_two <- 80
addNumbers(precinct_one, precinct_two)  # 200

# Vote totals are nonnegative; totalVotes must be positive.
cppFunction('
  double votePercentage(double votes, double totalVotes) {

    double proportion = votes / totalVotes;

    return proportion * 100.0;
  }
')

# Example: calculate a candidate's percentage of all votes.
candidate_votes <- 450
total_votes <- 600
votePercentage(candidate_votes, total_votes)  # 75

# Exercise 1. Signed difference: first total minus second total.
cppFunction('
  double voteDifference(double votesA, double votesB) {
    return votesA - votesB;
  }
')

# Example: calculate the signed margin between two candidates.
candidate_a <- 620
candidate_b <- 580
voteDifference(candidate_a, candidate_b)  # 40
voteDifference(candidate_b, candidate_a)  # -40


# Task 2. NumericVector input; return either a vector or one element.

cppFunction('
  NumericVector addTen(NumericVector x) {
    return x + 10.0;
  }
')

# Example: add ten to every value in a numeric vector.
values <- c(1, 2, 3)
addTen(values)  # 11 12 13

# Add a guard to the supplied demonstration before reading x[0].
cppFunction('
  double firstValue(NumericVector x) {
    if (x.size() < 1) {
      stop("x must contain at least one value.");
    }
    return x[0];
  }
')

# Example: retrieve the first recorded vote total.
vote_totals <- c(12, 18, 21, 30)
firstValue(vote_totals)  # 12

# Exercise 2. The second element has C++ index 1.
cppFunction('
  double secondValue(NumericVector x) {
    if (x.size() < 2) {
      stop("x must contain at least two values.");
    }
    return x[1];
  }
')

# Example: retrieve the second recorded vote total.
vote_totals <- c(12, 18, 21, 30)
secondValue(vote_totals)  # 18


# Task 3. A C++ bool returns TRUE or FALSE in R.
# Inputs must be nonmissing; bool cannot represent NA.

cppFunction('
  bool isGreater(double x, double y) {
    return x > y;
  }
')

# Example: check whether candidate A received more votes.
candidate_a <- 620
candidate_b <- 580
isGreater(candidate_a, candidate_b)  # TRUE
isGreater(580, 580)                 # FALSE

# Exercise 3. Include the boundary age of 18.
cppFunction('
  bool isEligible(double age) {
    return age >= 18.0;
  }
')

# Example: check the minimum age and an age just below it.
age <- 18
isEligible(age)  # TRUE
isEligible(17)   # FALSE
