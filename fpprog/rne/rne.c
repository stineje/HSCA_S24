//
// rne.c 
// Basic round-to-nearest-even of a fp number input
// james.stine@okstate.edu 11 November 2020
// 

#include <stdio.h>
#include <math.h>

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


int main(int argc, char* argv[]) {
  double N, N_rnd;
  double absolute_error;
  int precision;
  int num_iter, i;

  
  // Check if enough arguments were passed
  if (argc < 3) {
    fprintf(stderr, "Error: Not enough arguments.\n");
    fprintf(stderr, "Usage: %s <number> <precision>\n", argv[0]);
    return 1;
    }
  
  sscanf(argv[1],"%lg", &N);
  sscanf(argv[2],"%d", &precision);
  
  printf("Number before rounding = %1.15lg\n", N);
  disp_bin(N, 1, 15, stdout);
  printf("\n\n");
  N_rnd = rnd_near(N, precision);
  printf("Number after rounding = %lg\n", N_rnd);
  disp_bin(N_rnd, 1, precision, stdout);
  printf("\n");
  absolute_error = fabs(N_rnd - N);
  printf("Absolute error = %1.15lg\n", absolute_error);
  if (absolute_error > 0.0) {
    printf("Number of bits (error) = %1.15lg\n", log2(absolute_error));
  } else {
    printf("Number of bits (error) = -inf (no error)\n");
  }
  
}
