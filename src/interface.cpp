#include <string.h>
#include <Rvector.hpp>
#include "interface.hpp"

using std::set;
using namespace RAbstraction;

SEXP getDates(const SEXP x) {
  if(isClass(x,"fts")) {
    return getAttrib(x,install("dates"));
  } else {
    return R_NilValue;
  }
}

bool isClass(const SEXP x, const char* klass) {
  SEXP this_klass = getAttrib(x, R_ClassSymbol);

  if(this_klass == R_NilValue) {
    return false;
  }

  if(strcmp(CHAR(this_klass),klass) == 0) {
    return true;
  }

  return false;
}

void extractDates(simpleDates& dts, const SEXP x) {
  SEXP dates_sexp = getDates(x);
  R_len_t len = length(dates_sexp);

  for(R_len_t i = 0; i < len; i++) {
    dts.insert(REAL(dates_sexp)[i]);
  }
}

SEXP getDatesComl(const SEXP x) {
  simpleDates dts;

  if(!isClass(x,"coml")) {
    return R_NilValue;
  }

  R_len_t len = length(x);

  for(R_len_t i = 0; i < len; i++) {
    SEXP this_contract = VECTOR_ELT(x,i);
    extractDates(dts,this_contract);
  }

  RVector<REALSXP> ans(dts.size());
  R_len_t i = 0;
  for(simpleDates::iterator it = dts.begin(); it != dts.end(); it++, i++) {
    ans[i] = *it;
  }
  return ans.getSEXP();
}

SEXP rollDates(SEXP x, SEXP method) {
  return R_NilValue;
}
