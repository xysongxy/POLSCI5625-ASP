//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/positivePart.cpp                             //
//                                                  //
// Task 3. use conditionals inside a loop.          //
// Lecture 10, slides 9.                            //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector positivePart(NumericVector x) {
  NumericVector out(x.size());
  for (R_xlen_t i = 0; i < x.size(); ++i) {
    if (NumericVector::is_na(x[i])) out[i] = NA_REAL;
    else if (x[i] > 0.0) out[i] = x[i];
    else out[i] = 0.0;
  }
  return out;
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "positivePart.cpp"))
// positivePart(c(-2, 0, 3, NA))  # 0 0 3 NA
