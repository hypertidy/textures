#ifndef TEXTURES_QUAD_H
#define TEXTURES_QUAD_H

// Header library for quad mesh primitives on regular grids.
//
// A grid of nx * ny cells has (nx + 1) * (ny + 1) vertices at the cell
// corners. quad_ib() enumerates the 4 vertex indexes of every cell
// (0-based, flat vector, 4 values per quad), quad_vb() enumerates the
// vertex coordinates in the unit square (interleaved, optionally with
// constant z and homogeneous h rows for 'mesh3d' use).
//
// Quads are emitted in cell order, x fastest (matrix/image convention,
// and raster cell order when ydown is true). Vertex winding is
// counter-clockwise for y-up grids.
//
// This header is installed at inst/include/textures/ so other packages
// may use it via LinkingTo: textures.

#include <cpp11.hpp>
#include <cpp11/doubles.hpp>
#include <cpp11/integers.hpp>
#include <cpp11/matrix.hpp>

namespace quad {

// 0-based quad index, flat vector of length nx * ny * 4
inline cpp11::writable::integers quad_ib(int nx, int ny, bool ydown) {
  R_xlen_t len = (R_xlen_t)nx * (R_xlen_t)ny * 4;
  int nc1 = nx + 1;  // vertex columns
  cpp11::writable::integers quad(len);
  R_xlen_t count = 0;
  int v1, v2, v3, v4;  // y-up: bl, br, tr, tl
  for (int j = 0; j < ny; j++) {
    for (int i = 0; i < nx; i++) {
      v1 = i + j * nc1;
      v2 = i + 1 + j * nc1;
      v3 = v2 + nc1;
      v4 = v1 + nc1;
      if (ydown) {
        quad[count + 0] = v3;
        quad[count + 1] = v4;
        quad[count + 2] = v1;
        quad[count + 3] = v2;
      } else {
        quad[count + 0] = v1;
        quad[count + 1] = v2;
        quad[count + 2] = v3;
        quad[count + 3] = v4;
      }
      count = count + 4;
    }
  }
  return quad;
}

// as quad_ib(), but double storage for vertex counts or index lengths
// beyond the integer maximum (doubles are exact to 2^53)
inline cpp11::writable::doubles quad_ib_dbl(double nx, double ny, bool ydown) {
  R_xlen_t len = (R_xlen_t)(nx * ny * 4.0);
  double nc1 = nx + 1.0;
  cpp11::writable::doubles quad(len);
  R_xlen_t count = 0;
  double v1, v2, v3, v4;
  for (double j = 0; j < ny; j++) {
    for (double i = 0; i < nx; i++) {
      v1 = i + j * nc1;
      v2 = i + 1.0 + j * nc1;
      v3 = v2 + nc1;
      v4 = v1 + nc1;
      if (ydown) {
        quad[count + 0] = v3;
        quad[count + 1] = v4;
        quad[count + 2] = v1;
        quad[count + 3] = v2;
      } else {
        quad[count + 0] = v1;
        quad[count + 1] = v2;
        quad[count + 2] = v3;
        quad[count + 3] = v4;
      }
      count = count + 4;
    }
  }
  return quad;
}

// vertex coordinates in the unit square, interleaved (x, y[, z, h]),
// x fastest, optionally with constant z = 0 and homogeneous h = 1 rows
inline cpp11::writable::doubles quad_vb(int nx, int ny, bool ydown,
                                        bool zh) {
  R_xlen_t nc1 = nx + 1;  // column edges
  R_xlen_t nr1 = ny + 1;  // row edges
  int nrow = zh ? 4 : 2;
  R_xlen_t len = nc1 * nr1 * nrow;
  R_xlen_t count = 0;
  cpp11::writable::doubles vertex(len);

  double dx = 1.0 / (double)nx;
  double dy = 1.0 / (double)ny;
  double ystart = 0.0;
  if (ydown) {
    ystart = 1.0;
    dy = -dy;
  }
  for (R_xlen_t jj = 0; jj < nr1; jj++) {
    for (R_xlen_t ii = 0; ii < nc1; ii++) {
      vertex[count + 0] = ii * dx;
      vertex[count + 1] = ystart + jj * dy;
      if (zh) {
        vertex[count + 2] = 0.0;  // z constant
        vertex[count + 3] = 1.0;  // h constant
      }
      count = count + nrow;
    }
  }
  return vertex;
}

// matrix form of quad_vb() (2 x n or 4 x n)
inline cpp11::writable::doubles_matrix<> quad_matrix_vb(int nx, int ny,
                                                        bool ydown,
                                                        bool zh) {
  cpp11::writable::doubles v = quad_vb(nx, ny, ydown, zh);
  int nr = zh ? 4 : 2;
  R_xlen_t nc = (R_xlen_t)(nx + 1) * (R_xlen_t)(ny + 1);
  cpp11::writable::doubles_matrix<> quadvb_matrix(nr, nc);
  R_xlen_t cnt = 0;
  for (R_xlen_t i = 0; i < nc; i++) {
    for (int j = 0; j < nr; j++) {
      quadvb_matrix(j, i) = (double)v[cnt];
      cnt++;
    }
  }
  return quadvb_matrix;
}

}  // namespace quad
#endif
