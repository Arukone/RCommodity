#ifndef INTERFACE_HPP
#define INTERFACE_HPP

#include <set>
#include <Rinternals.h>

typedef std::set<double> simpleDates;

extern "C" {
  SEXP getComlDates(SEXP x);
  SEXP rollDates(SEXP x, SEXP method);
}

SEXP getDatesComl(const SEXP x);
SEXP getDates(const SEXP x);
void extractDates(simpleDates& dts, const SEXP x);
bool isClass(const SEXP x, const char* klass);

#endif // INTERFACE_HPP
