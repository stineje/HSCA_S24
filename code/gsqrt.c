#include "disp.h"

/*
	This routine performs Goldschmidt`s division 
        algorithm.  The user inputs the numerator, the denominator, 
        an initial approximation, the number of iterations, and 
        the precision of both the computation and the final result. 
        
*/

int main(int argc, char* argv[]) {
  double Y1, Y, N, R, Q, X, RQ, RD, REM, RREM, prec, prec_f, scale;
  int num_iter, i, iprec, iprec_f;
  if (argc < 6) {
    fprintf(stderr,"Usage: %s radicand intial-value iterations prec prec_f \n", argv[0]);
    exit(1);
  }
  /* Read in values */
  sscanf(argv[1],"%lg", &Y);
  sscanf(argv[2],"%lg", &R);
  sscanf(argv[3],"%d", &num_iter);
  sscanf(argv[4],"%lg", &prec);
  sscanf(argv[5],"%lg", &prec_f);
  /* 
     Adjust input to proper bit size (i.e. given precision) 
     
     Note: iprec_f is the internal precision which can be larger than
     output precision, so that answer is accurate
  */   
  iprec = (int) prec;
  iprec_f = (int) prec_f;
  /*
    It's important to round the input numbers, since most users
    input numbers that don't fit the precision of your registers.
  */
  Y = Y1 = N = rne(Y, iprec_f);
  /* Actual quotient */
  Q = sqrt(Y);
  printf("Y = %1.15lf = ", Y);
  disp_bin(Y, 1, iprec_f, stdout);
  printf("\n");
  for (i = 0; i < num_iter; i++) {
    Y = flr(Y*R*R, prec);
    N = flr(N*R, prec);
    R = flr((3 - Y)/2, prec);
    printf("i = %d, N = %lf, R = %lf\n", i, N, R);
    printf("i = %d, N = ", i);
    disp_bin(N, 2, iprec, stdout);
    printf(", R = ");
    disp_bin(R, 2, iprec, stdout);
    printf("\n");
  }
  
  /* Actual Answer */
  RQ = rne(Q, prec_f);
  /* Computed using Goldschmit's iteration */
  RD = flr(N, iprec_f);
  
  printf("\n");
  printf("Actual Answer\n");
  printf("RQ = %1.15lf = ", RQ);
  disp_bin(RQ, 1, (int) prec_f, stdout);
  printf("\n");
  printf("GSQRT Answer\n");
  printf("RD = %1.15lf = ", RD);
  disp_bin(RD, 1, (int) prec_f, stdout);
  printf("\n\n");
  
  /* Error Analysis */
  printf("Error Analysis\n");
  printf("error =  %lf\n", fabs(RQ - RD));
  printf("#bits = %lf\n", log(fabs(RQ-RD))/log(2.0));
  printf("\n");

  /* Remainder */
  scale = pow(2.0, prec_f);  
  REM  = scale*(Y1 - RD*RD);
  RREM = flr(REM, iprec_f);
  printf("Remainder\n");
  printf("RREM = %lf\n", RREM);
  printf("RREM = ");
  disp_bin(RREM, 1, (int) prec_f, stdout);
  printf("\n\n");

}
