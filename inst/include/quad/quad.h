#ifndef QUAD_H
#define QUAD_H

#include <Rcpp.h>

namespace quad {
 using namespace Rcpp;

IntegerVector quad_ib(IntegerVector nx, IntegerVector ny);
NumericVector quad_vb(IntegerVector nx, IntegerVector ny);

IntegerVector quad_ib(IntegerVector nx, IntegerVector ny) {
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
         quad[count] = bl;
         quad[count + 1] = br;
         quad[count + 2] = tr;
         quad[count + 3] = tl;
        count = count + 4;
    }
    }
   return quad;
 }

 NumericVector quad_vb(IntegerVector nx, IntegerVector ny) {
     int nc1 = nx[0] + 1;
     int nr1 = ny[0] + 1;
     double len = nc1 * nr1 * 2;
     NumericVector vertex(len);

     int count = 0;
     double fx = (double)nx[0];
     double fy = (double)ny[0];

     double dx = 1/fx;
     double dy = 1/fy;
     double ystart = 0;  // so we can ydown start at 1 and -dy

     double xx [nx[0]];
     double yy [ny[0]];

     for (int i = 0; i < nc1; i++) {
        xx[i] = i * dx;
     }
     for (int j = 0; j < nr1; j++) {
        yy[j] = j * dy;
     }
     // increment columns first
     for (int i = 0; i < nc1; i++) {
     for (int j = 0; j < nr1; j++) {
             // replace with one-time multiply outside loop
           vertex[count + 0] = xx[i];
           vertex[count + 1] = yy[j];
           count = count + 2;
         }
    }
   return vertex;
 }


}
#endif
