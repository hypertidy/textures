#include <Rcpp.h>
#include "quad/quad.h"
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector quad_index_cpp(IntegerVector nx, IntegerVector ny, LogicalVector ydown) {
  return quad::quad_ib(nx, ny, ydown);
}


// [[Rcpp::export]]
NumericVector quad_vertex_cpp(IntegerVector nx, IntegerVector ny,
                              LogicalVector ydown,
                              LogicalVector zh) {  // include z and homogeneous coord (0 and 1 respectively)
  return quad::quad_vb(nx, ny, ydown, zh);
}

// [[Rcpp::export]]
NumericMatrix quad_vertex_matrix_cpp(IntegerVector nx, IntegerVector ny,
                                     LogicalVector ydown,
                                     LogicalVector zh) {
  return quad::quad_matrix_vb(nx, ny, ydown, zh);
}
