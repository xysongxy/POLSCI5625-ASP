//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/firstValue.cpp                               //
//                                                  //
// Task 6. extract a numeric vector from a list.    //
// Lecture 10, slides 18.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double firstValue(List input) {
  NumericVector x = as<NumericVector>(input["x"]);
  if (x.size() == 0) stop("x must be nonempty");
  return x[0];
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "firstValue.cpp"))
// firstValue(list(x = c(7, 9)))  # 7
