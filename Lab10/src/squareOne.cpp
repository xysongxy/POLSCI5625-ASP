//////////////////////////////////////////////////////
//                                                  //
// Lab 10: Loops, matrices, and lists with Rcpp     //
//                                                  //
// src/squareOne.cpp                                //
//                                                  //
// Task 1. square a single number.                  //
// Lecture 10, slides 3-4.                          //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double squareOne(double x) {
  return x * x; // Square a single number
}

// Example in R (working directory: Lab10):
// Rcpp::sourceCpp(file.path("src", "squareOne.cpp"))
// squareOne(3)  # 9
