//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/sugarExamples.cpp                            //
//                                                  //
// Task 6. use Rcpp vector expressions.             //
// Lecture 10, slides 17.                           //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List sugarExamples(NumericVector x) {
  return List::create(
    Named("absolute") = abs(x),
    Named("exponential") = exp(x),
    Named("cube") = pow(x, 3.0),
    Named("positive") = (x > 0.0),
    Named("negative") = -x
  );
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "sugarExamples.cpp"))
// sugarExamples(c(-2, 0, 2))$cube  # -8 0 8
