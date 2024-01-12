// 
// Program:  random.c
// Name:  James E. Stine, Jr.
// Purpose: to create some random hex digits
// 

#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <inttypes.h>

#define STR_LEN 4
#define NUMB 32767

uint16_t hex2uint16 (const unsigned char *str) {
  
  uint16_t p;
  uint16_t num;
  uint16_t temp;  
  int i;
  
  num=0;
  temp=0;
  for(i=(STR_LEN-1), p=0; i >= 0; i--, p++){
    if(str[i]>='0' && str[i]<='9') {
      temp=str[i]-'0';
    }
    else if(str[i]>='A' && str[i]<='F') {
      temp=str[i]-'A'+10;
    }
    else if(str[i]>='a' && str[i]<='f') {
      temp=str[i]-'a'+10;
    }
    num += temp * (1L << (p*4));
  }
  return num;
}

int main(void) {

  int      temp;
  int      i, j, p;
  uint16_t number1u;
  uint16_t number2u;
  int16_t  number1;
  int16_t  number2;    
    
  unsigned char str1[STR_LEN + 1] = {0};
  unsigned char str2[STR_LEN + 1] = {0};    
  const char *hex_digits16 = "0123456789abcdef";
  const char *hex_digits8 = "01234567";
  const char *hex_digits4 = "0123";
  const char *hex_digits2 = "01";
    
  srand(time(NULL));

  for (j = 0; j < NUMB; j++) {
    for (i = 0; i < STR_LEN; i++) {
      str1[i] = hex_digits16[ rand() % 16 ];
      str2[i] = hex_digits16[ rand() % 16 ];
    }

    number1u = 0;
    number2u = 0;
    number1 = 0;
    number2 = 0;
    
    number1 = (int16_t) hex2uint16(str1);
    number2 = (int16_t) hex2uint16(str2);
    number1u = hex2uint16(str1);
    number2u = hex2uint16(str2);
    
      
    printf("%s_%s_%d_%d_%d\n", str1, str2, (number1 == number2),
	   (number1 < number2), (number1u < number2u));
  }
 
  return EXIT_SUCCESS;
}
