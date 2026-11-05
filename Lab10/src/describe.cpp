//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/describe.cpp                                 //
//                                                  //
// Task 6. return several named results.            //
// Lecture 10, slides 16.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List describe(NumericVector x, NumericMatrix A) {
  double first = NA_REAL;
  if (x.size() > 0) first = x[0];
  return List::create(
    Named("length") = x.size(),
    Named("nrow") = A.nrow(),
    Named("ncol") = A.ncol(),
    Named("first") = first
  );
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "describe.cpp"))
// ans <- describe(c(10, 20), matrix(0, 3, 2))
// ans$length  # 2
// ans$nrow    # 3
