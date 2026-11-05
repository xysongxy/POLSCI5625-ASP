//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/squareAll.cpp                                //
//                                                  //
// Task 1. square every element of a vector.        //
// Lecture 10, slides 3-4.                          //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector squareAll(NumericVector x) {
  // Create an output vector of the same length
  NumericVector out(x.size());

  // Square each element
  for (R_xlen_t i = 0; i < x.size(); ++i) {
    out[i] = x[i] * x[i];
  }

  return out; // Return the entire vector
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "squareAll.cpp"))
// squareAll(c(2, 3, 4))  # 4 9 16
