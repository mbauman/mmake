#include <mex.h>
#include <matrix.h>

extern void helloplus(int num);
extern "C" void hello(int num);

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
    hello(1);
    helloplus(2);
}
