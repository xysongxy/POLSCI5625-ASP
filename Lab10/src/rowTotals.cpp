//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/rowTotals.cpp                                //
//                                                  //
// Task 5. calculate matrix row totals.             //
// Lecture 10, slides 15.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector rowTotals(NumericMatrix A) {
  NumericVector out(A.nrow());
  for (int j = 0; j < A.ncol(); ++j) {
    for (int i = 0; i < A.nrow(); ++i) {
      out[i] += A(i, j);
    }
  }
  return out;
}

// [[Rcpp::export]]
NumericVector colTotals(NumericMatrix A) {
  NumericVector out(A.ncol());
  for (int i = 0; i < A.nrow(); ++i) {
    for (int j = 0; j < A.ncol(); ++j) {
      out[j] += A(i, j);
    }
  }
  return out;
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "rowTotals.cpp"))
// A <- matrix(1:6, nrow = 2)
// rowTotals(A)  # 9 12
