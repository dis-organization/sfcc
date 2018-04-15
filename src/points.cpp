#include <Rcpp.h>
using namespace Rcpp;



// [[Rcpp::export]]
List points_cpp(NumericMatrix pts, CharacterVector gdim = "XY") {
  int n = pts.nrow();
  List out(n);
  CharacterVector cls = CharacterVector::create(gdim[0], "POINT", "sfg");
  for (int i = 0; i < n; i++) {

    NumericVector lp = pts(i, _);
    lp.attr("class") = cls;
    out[i] = lp;
  }
  return out;
}



//List multipoints_cpp(NumericMatrix pts,
//                     IntegerVector objectindex = -1,
//                     IntegerVector objectcount = 1,
//                     CharacterVector gdim = "XY") {
  //int n = objectcount[0];
  // MAYBE, convert group to the index where it changes, so that length is the
  // output?  Just like decido, so we handle all the other optional stuff at the
  // R level and this index is a basic trigger to split off another list element
  // which should also work for multipolygons
  //List out(n);
  //CharacterVector cls = CharacterVector::create(gdim[0], "MULTIPOINT", "sfg");
  // for (int i = 0; i < n; i++) {
  //
  //   NumericVector lp = pts(i, _);
  //   lp.attr("class") = cls;
  //   out[i] = lp;
  // }
  // return out;
//}
