//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/addVectors.cpp                               //
//                                                  //
// Task 7. add two vectors.                         //
// Lecture 10, slides 19.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector addVectors(NumericVector x,
                         NumericVector y) {
  if (x.size() != y.size()) stop("Length mismatch");
  return x + y;
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "addVectors.cpp"))
// addVectors(c(1, 2, 3), c(1, 2, 3))  # 2 4 6
