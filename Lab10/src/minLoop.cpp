//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/minLoop.cpp                                  //
//                                                  //
// Task 4. track the smallest value.                //
// Lecture 10, slides 13.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double minLoop(NumericVector x) {
  double best = R_PosInf;
  for (R_xlen_t i = 0; i < x.size(); ++i) {
    if (NumericVector::is_na(x[i])) return NA_REAL;
    if (x[i] < best) best = x[i];
  }
  return best;
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "minLoop.cpp"))
// minLoop(c(4, 2, 7))  # 2
