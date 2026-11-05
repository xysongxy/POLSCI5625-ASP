//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/countAbove.cpp                               //
//                                                  //
// Task 3. count values above a threshold.          //
// Lecture 10, slides 10.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int countAbove(NumericVector x, double cutoff) {
  int count = 0;
  for (R_xlen_t i = 0; i < x.size(); ++i) {
    if (!NumericVector::is_na(x[i]) && x[i] > cutoff)
      ++count;
  }
  return count;
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "countAbove.cpp"))
// countAbove(c(0.2, NA, 0.8, 0.9), 0.5)  # 2
