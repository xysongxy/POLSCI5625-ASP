//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/stepsToTotal.cpp                             //
//                                                  //
// Task 4. repeat until a total is reached.         //
// Lecture 10, slides 11.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int stepsToTotal(double target) {
  if (!R_FINITE(target) || target < 0 || target > 1e6)
    stop("target must be finite and in [0, 1e6]");
  int i = 0;
  double total = 0.0;
  while (total < target) {
    total += ++i;
    Rcout << i << " " << total << "\n";
  }
  return i;
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "stepsToTotal.cpp"))
// stepsToTotal(6)  # Prints 1 1, 2 3, 3 6; returns 3
