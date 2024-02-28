#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define INVALID_INPUT 0
#define VALID_INPUT 1
#define VALID_PREFIX 3

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
    if (i%4 == 0)
      printf(" ");
  }
}

char *valueOf(char digit) {
  switch(digit) {
  case '0': return "0000";
  case '1': return "0001";
  case '2': return "0010";
  case '3': return "0011";
  case '4': return "0100";
  case '5': return "0101";
  case '6': return "0110";
  case '7': return "0111";
  case '8': return "1000";
  case '9': return "1001";
  case 'A':
  case 'a': return "1010";
  case 'B':
  case 'b': return "1011";
  case 'C':
  case 'c': return "1100";
  case 'D':
  case 'd': return "1101";
  case 'E':
  case 'e': return "1110";
  case 'F':
  case 'f': return "1111";
  default: {
    printf("Cannot decode that symbol: %c" + digit);
    return 0;
  }
  }
}

// validate hex number whether ok
int validate(char *hex, int length) {                                                                               
  int result = VALID_INPUT;                                                     
  if(length > 2) {
    if(hex[0] == '0' && (hex[1] == 'x' || hex[1] == 'X')) {
      hex += 2;                                                             
      result = VALID_PREFIX;
    }                                                                       
  }                                                                           
  while(*hex != '\0') {
    if(*hex < '0' || (*hex > '9' && *hex < 'A') || (*hex > 'F' && *hex < 'a') || *hex > 'f') {
      printf("The input should be a hexadecimal number, containing only digits(0-9) and the first 6 letters(a-f).\n");
      result = INVALID_INPUT;
      break;
    }
    else {
      hex++;
    }
  }

  return result;
}

// convert hex char to binary char
char *hex2bin(char *hex, int validation, int length) {

  char *binary = (char*) malloc(length * 4 + 1);
  if (binary == NULL)
    exit(1);

  if (validation == VALID_PREFIX) {
      hex += 2;
      length -= 2;
  }
  
  while (*hex != '\0') {
    char *binaryValue = valueOf(*hex);
    while(*binaryValue != '\0')
      *binary++ = *binaryValue++;
    ++hex;
  }

  // End of array
  *binary = '\0';
  binary -= length * 4;
  return binary;
}

int hex2dec (char *hex) {

  int i;
  int cnt = 0;
  int digit;
  int decimal_number = 0;

  // iterating the loop using length of hexadecnumber
  for (i = (strlen(hex) - 1); i >= 0; i--) {       
    switch (hex[i]) { 
    case 'A':
    case 'a':       
      digit = 10; 
      break; 
    case 'B':
    case 'b':       
      digit = 11; 
      break; 
    case 'C':
    case 'c':       
      digit = 12; 
      break; 
    case 'D':
    case 'd':       
      digit = 13; 
      break; 
    case 'E':
    case 'e':       
      digit = 14; 
      break; 
    case 'F':
    case 'f':       
      digit = 15; 
      break; 
    default: 
      digit = hex[i] - 0x30; 
    } 
    
    // obtaining the decimal number
    decimal_number = decimal_number + (digit) * pow((double) 16.0, (double) cnt); 
    cnt++;
  }
  return decimal_number;
}

// converts QN.F
double bin2frac (char *num, int N, int F) {

  int i;
  int cnt = 0;
  int digit;
  double decimal_number = 0.0;

  // iterating the loop using length of hexadecnumber
  for (i = (strlen(num) - 1); i >= 0; i--) {       
    digit = num[i] - 0x30; 

    // obtaining the decimal number
    if (i == 0)
      decimal_number = decimal_number - (digit) * 1.0;
    else
      decimal_number = decimal_number + (digit) * pow((double) 2.0, (double) -(F-cnt));
    
    cnt++;
  }
  return decimal_number;
}

char* dec2hex (int decimal_Number, int length) {
  char* hexa_Number = (char*) malloc(length * 4 + 1);  
  int i = 1;
  int temp;
  while (decimal_Number != 0) { 
    temp = decimal_Number % 16;         
    // converting decimal number to hex
    if (temp < 10) 
      temp = temp + 48; 
    else
      temp = temp + 55; 
    hexa_Number[i++] = temp; 
    decimal_Number = decimal_Number / 16;
  }
  return hexa_Number;
}


 
int main(int argc, char* argv[]) {

  int length;
  int validation;
  char *binary;
  
  char *num1a;
  char *num1b;
  char *num2a;
  char *num2b;
  char *num3a;
  char *num3b;
  char *num4a;
  char *num4b;
  char num1r[80];
  char num2r[80];
  char num3r[80];
  char num4r[80];  
  
  double prob1a, prob1b, prob1r;
  double prob2a, prob2b, prob2r;
  double prob3a, prob3b, prob3r;
  double prob4a, prob4b, prob4r;
  int digit;
  int test;
  int i;

  char convert[80];
  
  num1a = "6d03";
  num1b = "d936";
  num2a = "dbe9";
  num2b = "15a6";
  num3a = "3c7d";
  num3b = "7821";
  num4a = "8b08";
  num4b = "d917";      
  sprintf(convert, "%x", hex2dec(num1a)+hex2dec(num1b));
  for (i=0; i<4; i++) 
    num1r[i] = convert[i+1];
  num1r[4] = '\0';
  
  sprintf(convert, "%x", hex2dec(num2a)+hex2dec(num2b));
  for (i=0; i<4; i++) 
    num2r[i] = convert[i];
  num2r[4] = '\0';
  
  sprintf(convert, "%x", hex2dec(num3a)+hex2dec(num3b));
  for (i=0; i<4; i++) 
    num3r[i] = convert[i];
  num3r[4] = '\0';
  
  sprintf(convert, "%x", hex2dec(num4a)+hex2dec(num4b));
  for (i=0; i<4; i++) 
    num4r[i] = convert[i+1];
  num4r[4] = '\0';  

  
  length = strlen(num1a);
  validation = validate(num1a, length);
  if (validation) {                                                                           
    binary = hex2bin(num1a, validation, length);
    test = hex2dec(num1a);
    prob1a = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num1a, binary, test);
    printf("The value is %1.20lg\n", prob1a);
  }

  length = strlen(num1b);
  validation = validate(num1b, length);
  if (validation) {                                                                           
    binary = hex2bin(num1b, validation, length);
    test = hex2dec(num1b);
    prob1b = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num1b, binary, test);
    printf("The value is %1.20lg\n", prob1b);
  }
  
  length = strlen(num1r);
  validation = validate(num1r, length);
  if (validation) {                                                                           
    binary = hex2bin(num1r, validation, length);
    test = hex2dec(num1r);
    prob1r = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num1r, binary, test);
    printf("The value is %1.20lg\n", prob1r);
  }


  printf("\nProblem 1b\n");
  length = strlen(num2a);
  validation = validate(num2a, length);
  if (validation) {                                                                           
    binary = hex2bin(num2a, validation, length);
    test = hex2dec(num2a);
    prob1a = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num2a, binary, test);
    printf("The value is %1.20lg\n", prob1a);
  }

  length = strlen(num2b);
  validation = validate(num2b, length);
  if (validation) {                                                                           
    binary = hex2bin(num2b, validation, length);
    test = hex2dec(num2b);
    prob1b = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num2b, binary, test);
    printf("The value is %1.20lg\n", prob1b);
  }
  
  length = strlen(num2r);
  validation = validate(num2r, length);
  if (validation) {                                                                           
    binary = hex2bin(num2r, validation, length);
    test = hex2dec(num2r);
    prob1r = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num2r, binary, test);
    printf("The value is %1.20lg\n", prob1r);
  }

  printf("\nProblem 1c\n");
  length = strlen(num3a);
  validation = validate(num3a, length);
  if (validation) {                                                                           
    binary = hex2bin(num3a, validation, length);
    test = hex2dec(num3a);
    prob1a = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num3a, binary, test);
    printf("The value is %1.20lg\n", prob1a);
  }

  length = strlen(num3b);
  validation = validate(num3b, length);
  if (validation) {                                                                           
    binary = hex2bin(num3b, validation, length);
    test = hex2dec(num3b);
    prob1b = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num3b, binary, test);
    printf("The value is %1.20lg\n", prob1b);
  }
  
  length = strlen(num3r);
  validation = validate(num3r, length);
  if (validation) {                                                                           
    binary = hex2bin(num3r, validation, length);
    test = hex2dec(num3r);
    prob1r = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num3r, binary, test);
    printf("The value is %1.20lg\n", prob1r);
  }

  printf("\nProblem 1d\n");
  length = strlen(num4a);
  validation = validate(num4a, length);
  if (validation) {                                                                           
    binary = hex2bin(num4a, validation, length);
    test = hex2dec(num4a);
    prob1a = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num4a, binary, test);
    printf("The value is %1.20lg\n", prob1a);
  }

  length = strlen(num4b);
  validation = validate(num4b, length);
  if (validation) {                                                                           
    binary = hex2bin(num4b, validation, length);
    test = hex2dec(num4b);
    prob1b = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num4b, binary, test);
    printf("The value is %1.20lg\n", prob1b);
  }
  
  length = strlen(num4r);
  validation = validate(num4r, length);
  if (validation) {                                                                           
    binary = hex2bin(num4r, validation, length);
    test = hex2dec(num4r);
    prob1r = bin2frac(binary, 1, 15);
    printf("%s in hexadecimal is %s in binary and %d integer\n", num4r, binary, test);
    printf("The value is %1.20lg\n", prob1r);
  }    
  
}
