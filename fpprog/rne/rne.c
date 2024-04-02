#include <stdio.h>
#include <math.h>

/*
	This routine performs the RNE rounding.  The user inputs 
        value she/he wants to round and the rounded value gets
        printed out.
        
*/

/*
  Rounding Calls
*/

double rnd_near(double x, double bits) {
  double scale, x_round;
  scale = pow(2.0, bits);
  x_round = rint(x * scale) / scale;
  return x_round;
}

double rnd_down(double x, double bits) {
  double scale, x_round;
  scale = pow(2.0, bits);
  x_round = floor(x * scale) / scale;
  return x_round;
}

double rnd_up(double x, double bits) {
  double scale, x_round;
  scale = pow(2.0, bits);
  x_round = ceil(x * scale) / scale;
  return x_round;
}

double rnd_zero(double x, double bits) {
  if (x < 0) 
    return rnd_up(x, bits);
  else
    return rnd_down(x, bits);
}


/*
  Floor function
*/

double flr(double x, double precision) {
  double scale, x_round;
  scale = pow(2.0, precision);
  x_round = floor(x * scale) / scale;
  return x_round;
}


/*
  Binary Conversion
*/

void disp_bin(double x, int bits_to_left, int bits_to_right, FILE *out_file) {
  double diff;
  int i;
  if (fabs(x) <  pow(2.0, -bits_to_right)) {
    for (i = -bits_to_left + 1; i <= bits_to_right; i++) {
      printf("0");
    }
    return;
  }
  if (x < 0.0) {
    x = pow(2.0, ((double) bits_to_left)) + x;
  }
  for (i = -bits_to_left + 1; i <= bits_to_right; i++) {
    diff = pow(2.0, -i);
    if (x < diff) {
      printf("0");
    }
    else {
      fprintf(out_file, "1");
      x -= diff;
    }
    if (i == 0) {
      printf(".");
    }
  }
}


main(int argc, char* argv[]) {
   double N;
   int precision;
   int num_iter, i;

   sscanf(argv[1],"%lg", &N);
   sscanf(argv[2],"%d", &precision);

   printf("Number before rounding = %1.15lg\n", N);
   disp_bin(N, 1, 15, stdout);
   printf("\n");
   N = rnd_near(N, precision);
   disp_bin(N, 1, precision, stdout);
   printf("\n");
   printf("Number after rounding = %lg\n", N);

}
