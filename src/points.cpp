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


// [[Rcpp::export]]
List multipoints_cpp(NumericMatrix pts, IntegerVector group, CharacterVector gdim = "XY") {
  int n = pts.nrow();
  // MAYBE, convert group to the index where it changes, so that length is the
  // output??
  //List out(n);
  // CharacterVector cls = CharacterVector::create(gdim[0], "POINT", "sfg");
  // for (int i = 0; i < n; i++) {
  //
  //   NumericVector lp = pts(i, _);
  //   lp.attr("class") = cls;
  //   out[i] = lp;
  // }
  // return out;
}
