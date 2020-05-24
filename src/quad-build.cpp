#include <Rcpp.h>
#include "quad/quad.h"
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector quad_index_cpp(IntegerVector nx, IntegerVector ny) {
  return quad::quad_ib(nx, ny);
}


// [[Rcpp::export]]
NumericVector quad_vertex_cpp(IntegerVector nx, IntegerVector ny) {
  return quad::quad_vb(nx, ny);
}


