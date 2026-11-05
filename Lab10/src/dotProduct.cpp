//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/dotProduct.cpp                               //
//                                                  //
// Task 7. sum element-by-element products.         //
// Lecture 10, slides 20.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dotProduct(NumericVector x, NumericVector y) {
  if (x.size() != y.size()) stop("Length mismatch");
  double out = 0.0;
  for (R_xlen_t i = 0; i < x.size(); ++i) {
    out += x[i] * y[i];
  }
  return out;
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "dotProduct.cpp"))
// x <- c(1, 2, 3)
// y <- c(4, 5, 6)
// dotProduct(x, y)  # 32
