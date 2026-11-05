//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/meanLoop.cpp                                 //
//                                                  //
// Task 4. calculate the sample mean.               //
// Lecture 10, slides 12.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double meanLoop(NumericVector x) {
  if (x.size() == 0) return R_NaN;
  double total = 0.0;
  for (R_xlen_t i = 0; i < x.size(); ++i) {
    if (NumericVector::is_na(x[i])) return NA_REAL;
    total += x[i];
  }
  return total / static_cast<double>(x.size());
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "meanLoop.cpp"))
// meanLoop(c(2, 4, 6))  # 4
