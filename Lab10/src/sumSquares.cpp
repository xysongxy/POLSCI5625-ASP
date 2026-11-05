//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/sumSquares.cpp                               //
//                                                  //
// Task 2. accumulate squared values.               //
// Lecture 10, slides 5-7.                          //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double sumSquares(NumericVector x) {
  double total = 0.0;

  for (R_xlen_t i = 0; i < x.size(); ++i) {
    total += x[i] * x[i]; // Square and add
  }

  return total; // Return a single number
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "sumSquares.cpp"))
// sumSquares(c(2, 3))  # 13
