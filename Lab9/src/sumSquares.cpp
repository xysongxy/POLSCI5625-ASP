// Lab 9 optional extension: Lecture 9, slides 19-24.
// Compile from R with Rcpp::sourceCpp(file.path("src", "sumSquares.cpp")).
#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
double sumSquares(NumericVector x) {
  double total = 0.0;

  for (R_xlen_t i = 0; i < x.size(); ++i) {
    total += x[i] * x[i];
  }

  return total;
}
