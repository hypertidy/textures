#include <Rcpp.h>
#include "quad/quad.h"
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector quad_index_cpp(IntegerVector nx, IntegerVector ny, LogicalVector ydown) {
  return quad::quad_ib(nx, ny, ydown);
}


// [[Rcpp::export]]
NumericVector quad_vertex_cpp(IntegerVector nx, IntegerVector ny, LogicalVector ydown) {
  return quad::quad_vb(nx, ny, ydown);
}


