#include "cpp11.hpp"

#include "quad/quad.h"
#include "cpp11/matrix.hpp"
#include "cpp11/logicals.hpp"

using namespace cpp11;

namespace writable = cpp11::writable;
[[cpp11::register]]
integers quad_index_cpp(integers nx, integers ny, logicals ydown) {
  return quad::quad_ib(nx, ny, ydown);
}


[[cpp11::register]]
doubles quad_vertex_cpp(integers nx, integers ny,
                              logicals ydown,
                              logicals zh) {  // include z and homogeneous coord (0 and 1 respectively)
  return quad::quad_vb(nx, ny, ydown, zh);
}

[[cpp11::register]]
writable::doubles_matrix<> quad_vertex_matrix_cpp(integers nx, integers ny,
                                     logicals ydown,
                                     logicals zh) {
  return quad::quad_matrix_vb(nx, ny, ydown, zh);
}
