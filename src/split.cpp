//#include <RcppArmadillo.h>
//// [[Rcpp::depends(RcppArmadillo)]]

// // [[Rcpp::export]]
// arma::field<arma::mat> splitImagesRcpp(arma::mat x) {
//
//   // Sample size
//   int relevantSampleSize = x.n_rows;
//
//   // Create a field class with a pre-set amount of elements
//   arma::field<arma::mat> listOfRelevantImages(relevantSampleSize);
//
//   for(int k = 0; k < relevantSampleSize; ++k)
//   {
//     listOfRelevantImages(k) = x.row(k);
//   }
//
//
//   return listOfRelevantImages;
// }
