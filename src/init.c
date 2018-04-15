#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP _sfcc_multipoints_cpp(SEXP, SEXP, SEXP);
extern SEXP _sfcc_points_cpp(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"_sfcc_multipoints_cpp", (DL_FUNC) &_sfcc_multipoints_cpp, 3},
    {"_sfcc_points_cpp",      (DL_FUNC) &_sfcc_points_cpp,      2},
    {NULL, NULL, 0}
};

void R_init_sfcc(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
