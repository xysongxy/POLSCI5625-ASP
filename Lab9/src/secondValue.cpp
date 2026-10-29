//////////////////////////////////////////////////////
//                                                  //
// Lab 9: Getting started with Rcpp                 //
//                                                  //
// src/secondValue.cpp                              //
//                                                  //
// Exercise 2. return the second vector element.    //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double secondValue(NumericVector x) {
  if (x.size() < 2) {
    stop("x must contain at least two values.");
  }
  return x[1];
}

// Example in R (working directory: Lab9):
// Rcpp::sourceCpp(file.path("src", "secondValue.cpp"))
// secondValue(c(12, 18, 21, 30))  # 18
