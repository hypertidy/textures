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

// [[Rcpp::export]]
NumericMatrix quad_vertex_matrix_cpp(IntegerVector nx, IntegerVector ny, LogicalVector ydown) {
  NumericVector v = quad_vertex_cpp(nx, ny, ydown);
  // Set number of rows and columns to attribute dim
  v.attr("dim") = Dimension(2, (nx[0] + 1) * (ny[0] + 1));

  // Converting to Rcpp Matrix type
  NumericMatrix quadvb_matrix = as<NumericMatrix>(v);
  return quadvb_matrix;
}
