//////////////////////////////////////////////////////
//                                                  //
// Lab 9: Getting started with Rcpp                 //
//                                                  //
// src/isEligible.cpp                               //
//                                                  //
// Exercise 3. check whether age is at least 18.    //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
bool isEligible(double age) {
  return age >= 18.0;
}

// Example in R (working directory: Lab9):
// Rcpp::sourceCpp(file.path("src", "isEligible.cpp"))
// isEligible(17)  # FALSE
// isEligible(18)  # TRUE
