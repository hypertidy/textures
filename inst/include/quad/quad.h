#ifndef QUAD_H
#define QUAD_H

#include <Rcpp.h>

namespace quad {
 using namespace Rcpp;

//IntegerVector quad_ib(IntegerVector nx, IntegerVector ny, LogicalVector ydown);
//NumericVector quad_vb(IntegerVector nx, IntegerVector ny, LogicalVector ydown);

inline IntegerVector quad_ib(IntegerVector nx, IntegerVector ny, LogicalVector ydown) {
    int len;
    int nc1;
    len = (nx[0]) * (ny[0]) * 4;
    nc1 = nx[0] + 1L; // nx columns
    //int nr1 = ny[0] + 1; // ny rows
    IntegerVector quad(len);
    int bl, br, tr, tl; // bottom left, bottom right, top left, top right
    int count = 0;
    for (int i = 0; i < nx[0]; i++) {
       for (int j = 0; j < ny[0]; j++) {
          bl = i + j * nc1;
          br = i + 1 + j * nc1;
          tr = br + nc1;
          tl = bl + nc1;
          if (ydown[0]) {
            quad[count + 3] = bl;
            quad[count + 2] = br;
            quad[count + 1] = tr;
            quad[count + 0] = tl;
            count = count + 4;

          } else {
           quad[count] = bl;
           quad[count + 1] = br;
           quad[count + 2] = tr;
           quad[count + 3] = tl;
            count = count + 4;
        }
    }
    }
   return quad;
 }
// flesh out x and y coordinates at edges of 2D array of nx*ny quads
 inline NumericVector quad_vb(IntegerVector nx, IntegerVector ny,
                              LogicalVector ydown,
                              LogicalVector zh) {
     int nc1 = nx[0] + 1;  // column edges
     int nr1 = ny[0] + 1;  // row edges
     int nrow = 2;
     if (zh[0]) {
       nrow = 4;
     }
     double len = nc1 * nr1 * nrow; // total length of output
     int count = 0;   // ease chunking through loop
     // output vector
     NumericVector vertex(len);

     // step size from 0 to 1
     double dx = 1/(double)nx[0];
     double dy = 1/(double)ny[0];

     double ystart = 0;  // so we can ydown start at 1 and -dy
     if (ydown[0]) {
       ystart = 1;
       dy = -dy;
     }
     // the 1D arrays across each margin, we calculate them first then expand-xy
     NumericVector xx(nc1);
     NumericVector yy(nr1);
     // populate x
     int i;
     for (i = 0; i < nc1; i++) {
        xx[i] = i * dx;
     }
    //  populate y
     for (int j = 0; j < nr1; j++) {
        yy[j] = ystart + j * dy;
     }
     for (int jj = 0; jj < nr1; jj++) {
         // increment columns first
         for (int ii = 0; ii < nc1; ii++) {
           vertex[count + 0] = xx[ii];
           vertex[count + 1] = yy[jj];
           if (zh[0]) {
             vertex[count + 2] = 0; // z constant
             vertex[count + 3] = 1; // h constant

           }
           count = count + nrow;
         }
    }
   return vertex;
 }
// return matrix form of quad_vb (not interleaved) and optionally include z+h
inline NumericMatrix quad_matrix_vb(IntegerVector nx, IntegerVector ny,
                                    LogicalVector ydown,
                                    LogicalVector zh) {
  NumericVector v = quad_vb(nx, ny, ydown, zh);
  int nr = 2;
  if (zh[0]) {
    nr = 4; // including z and h
  }
  // Set number of rows and columns to attribute dim
  v.attr("dim") = Dimension(nr, (nx[0] + 1) * (ny[0] + 1));

  // Converting to Rcpp Matrix type
  NumericMatrix quadvb_matrix = as<NumericMatrix>(v);
  return quadvb_matrix;
}
}
#endif
