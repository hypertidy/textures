#include <cpp11.hpp>
#include <cpp11/matrix.hpp>

#include "textures/quad.h"

[[cpp11::register]]
cpp11::integers quad_index_cpp(int nx, int ny, bool ydown) {
  return quad::quad_ib(nx, ny, ydown);
}

[[cpp11::register]]
cpp11::doubles quad_index_dbl_cpp(double nx, double ny, bool ydown) {
  return quad::quad_ib_dbl(nx, ny, ydown);
}

[[cpp11::register]]
cpp11::doubles quad_vertex_cpp(int nx, int ny, bool ydown, bool zh) {
  return quad::quad_vb(nx, ny, ydown, zh);
}

[[cpp11::register]]
cpp11::writable::doubles_matrix<> quad_vertex_matrix_cpp(int nx, int ny,
                                                         bool ydown, bool zh) {
  return quad::quad_matrix_vb(nx, ny, ydown, zh);
}
