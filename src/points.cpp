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
List multipoints_cpp(NumericMatrix pts,
                     IntegerVector scanindex = -1,
                     CharacterVector gdim = "XY") {
  int n = 1;
  if (scanindex[0] > -1) {
    n = scanindex.length() - 1;
//Rprintf(">1!");
  }
  List out(n);

  int nc = pts.ncol();
  CharacterVector cls = CharacterVector::create(gdim[0], "MULTIPOINT", "sfg");
  for (int i = 0; i < n; i++) {
    int nr = scanindex[i + 1] - scanindex[i];

    if (n == 1) {
      pts.attr("class") = cls;
      out[i] = pts;

    } else {
      NumericMatrix am(nr,nc);
      am = pts(Range(scanindex[i], scanindex[i+1]-1), _);
      am.attr("class") = cls;
      out[i] = am;

    }
  }
  return out;
}

