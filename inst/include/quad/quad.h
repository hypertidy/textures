#ifndef QUAD_H
#define QUAD_H

#include <Rcpp.h>

namespace quad {
 using namespace Rcpp;

IntegerVector quad_ib(IntegerVector nx, IntegerVector ny);
//IntegerVector quad_vb(IntegerVector nx, IntegerVector ny);

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
//
//  NumericVector quad_vb(IntegerVector nx, IntegerVector ny) {
//
//    return 0;
//  }


}
#endif
