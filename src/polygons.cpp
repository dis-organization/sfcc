#include <Rcpp.h>
using namespace Rcpp;

// build_x list of flat coords, or matrices (dim attr is simply set assuming native R order)
// build_xyg vectors of x, y with a g-rouping
// build_xd vector of flat coords with a g-rouping

//' Build sf
//'
//' @param data_x list of coordinates in a vector
//' @param type sf geometry type (defaults to POYLGON)
//' @param gtype sf geometry dimension (defaults to XY)
//' @export
// [[Rcpp::depends(RcppProgress)]]
// [[Rcpp::export]]
List polygons_cpp(List data_x, CharacterVector topology = "POLYGON", CharacterVector gdim = "XY",
                  LogicalVector classme = true) {
  // originally prototyped https://github.com/diminutive/sfgminbuilder/blob/master/src/sfgbuilder.cpp
  int nsfg = data_x.length();
  Rcpp::List rectlist(nsfg);
  Rcpp::List sfglist(1);
 // if (classme[0]) {
    sfglist.attr("class") = CharacterVector::create(gdim[0], topology[0], "sfg");

//  }
  std::string a = Rcpp::as<std::string>(gdim[0]);

  int idim = a.length();
  for (int idata = 0; idata < nsfg; idata++) {
    if (idata % 500 == 0) {
      Rcpp::checkUserInterrupt();
    }
    Rcpp::NumericVector x = data_x[idata];
    x.attr("dim") = Dimension(x.length()/idim, idim);
    sfglist[0] = x;
    rectlist[idata] = Rcpp::clone(sfglist);
  }
  return rectlist;
}
