#ifndef QUAD_H
#define QUAD_H

#include "cpp11.hpp"
#include "cpp11/matrix.hpp"
#include "cpp11/doubles.hpp"
#include "cpp11/integers.hpp"

using namespace cpp11;
namespace writable = cpp11::writable;

namespace quad {

[[cpp11::register]]
inline integers quad_ib(integers nx, integers ny, logicals ydown) {
    int len;
    int nc1;
    len = (nx[0]) * (ny[0]) * 4;
    nc1 = nx[0] + 1L; // nx columns
    //int nr1 = ny[0] + 1; // ny rows
    writable::integers quad(len);
    //int bl, br, tr, tl; // bottom left, bottom right, top right, top left
    int v1, v2, v3, v4;  // order is ydown: bl, br, tr, tl
                         //          yup  :
    int count = 0;
    for (int i = 0; i < nx[0]; i++) {
       for (int j = 0; j < ny[0]; j++) {
          v1 = i + j * nc1;
          v2 = i + 1 + j * nc1;
          v3 = v2 + nc1;
          v4 = v1 + nc1;
          if (ydown[0]) {

            quad[count + 0] = v3;
            quad[count + 1] = v4;
            quad[count + 2] = v1;
            quad[count + 3] = v2;
            count = count + 4;

          } else {
           quad[count + 0] = v1;
           quad[count + 1] = v2;
           quad[count + 2] = v3;
           quad[count + 3] = v4;
            count = count + 4;
        }
    }
    }
   return quad;
 }
// flesh out x and y coordinates at edges of 2D array of nx*ny quads
 inline doubles quad_vb(integers nx, integers ny,
                              logicals ydown,
                              logicals zh) {
     int nc1 = nx[0] + 1;  // column edges
     int nr1 = ny[0] + 1;  // row edges
     int nrow = 2;
     if (zh[0]) {
       nrow = 4;
     }
     double len = nc1 * nr1 * nrow; // total length of output
     int count = 0;   // ease chunking through loop
     // output vector
     writable::doubles vertex(len);

     // step size from 0 to 1
     double dx = 1/(double)nx[0];
     double dy = 1/(double)ny[0];

     double ystart = 0;  // so we can ydown start at 1 and -dy
     if (ydown[0]) {
       ystart = 1;
       dy = -dy;
     }
     // the 1D arrays across each margin, we calculate them first then expand-xy
     writable::doubles xx(nc1);
     writable::doubles yy(nr1);
     // populate x
     int i;
     for (i = 0; i < nc1; i++) {
        xx[i] = i * dx;
      // Rprintf("%f\n", i * dx);
     }
    //  populate y
     for (int j = 0; j < nr1; j++) {
        yy[j] = ystart + j * dy;
       //Rprintf("%f\n", j * dy);

     }
     for (int jj = 0; jj < nr1; jj++) {
         // increment columns first
         for (int ii = 0; ii < nc1; ii++) {
           vertex[count + 0] = ii * dx; //(double)xx[ii];
           vertex[count + 1] = ystart + jj * dy; //(double)yy[jj];
           if (zh[0]) {
             vertex[count + 2] = 0.0; // z constant
             vertex[count + 3] = 1.0; // h constant

           }
           count = count + nrow;
         }
    }
   return vertex;
 }
// return matrix form of quad_vb (not interleaved) and optionally include z+h
inline writable::doubles_matrix<>  quad_matrix_vb(integers nx, integers ny,
                                    logicals ydown,
                                    logicals zh) {
  writable::doubles v = quad_vb(nx, ny, ydown, zh);
  int nr = 2;
  if (zh[0]) {
    nr = 4; // including z and h
  }

  int nc = (nx[0] + 1) * (ny[0] + 1);
  writable::doubles_matrix<> quadvb_matrix(nr, nc);
  int cnt = 0;
  for (int i = 0; i < nc; i++) {
    for (int j = 0; j < nr; j++) {
      // note j, i whereas with Rcpp we just set dim on the flat v and converted to matrix
      quadvb_matrix(j, i) = (double)v[cnt];
      cnt++;
   }
  }
  return quadvb_matrix;
}
}
#endif
