#ifndef QUAD_H
#define QUAD_H

#include <Rcpp.h>

namespace quad {
 using namespace Rcpp;

IntegerVector quad_ib(IntegerVector nx, IntegerVector ny, LogicalVector ydown);
NumericVector quad_vb(IntegerVector nx, IntegerVector ny, LogicalVector ydown);

IntegerVector quad_ib(IntegerVector nx, IntegerVector ny, LogicalVector ydown) {
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

 NumericVector quad_vb(IntegerVector nx, IntegerVector ny, LogicalVector ydown) {
     int nc1 = nx[0] + 1;
     int nr1 = ny[0] + 1;
     double len = nc1 * nr1 * 2;
     NumericVector vertex(len);

     int count = 0;
     double fx = (double)nx[0];
     double fy = (double)ny[0];

     double dx = 1/fx;
     double dy = 1/fy;

     double xx [nc1];
     double yy [nr1];

     int i;
     xx[0] = 0;

     for (i = 0; i < nc1; i++) {
        xx[i] = i * dx;
      // Rprintf("%f\n", xx[i]);
     }

     double ystart = 0;  // so we can ydown start at 1 and -dy
     if (ydown[0]) {
       ystart = 1;
       dy = -dy;
     }
     for (int j = 0; j < nr1; j++) {
        yy[j] = ystart + j * dy;
     }
     for (int jj = 0; jj < nr1; jj++) {
         // increment columns first
         for (int ii = 0; ii < nc1; ii++) {
           vertex[count + 0] = xx[ii];
           vertex[count + 1] = yy[jj];
           count = count + 2;
         }
    }
   return vertex;
 }


}
#endif
