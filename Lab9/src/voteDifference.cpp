//////////////////////////////////////////////////////
//                                                  //
// Lab 9: Getting started with Rcpp                 //
//                                                  //
// src/voteDifference.cpp                           //
//                                                  //
// Exercise 1. calculate a signed vote margin.      //
//                                                  //
//////////////////////////////////////////////////////

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double voteDifference(double votesA, double votesB) {
  return votesA - votesB;
}

// Example in R (working directory: Lab9):
// Rcpp::sourceCpp(file.path("src", "voteDifference.cpp"))
// voteDifference(620, 580)  # 40
// voteDifference(580, 620)  # -40
