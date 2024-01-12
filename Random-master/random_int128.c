// 
// Program:  random.c
// Name:  James E. Stine, Jr.
// Purpose: to create some random hex digits
// 

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <inttypes.h>

#define STR_LEN 32
#define NUMB 32767

int main(void) {

  typedef __int128 int128_t;
  typedef unsigned __int128 uint128_t;

  int      temp;
  int      i, j, p;
  uint128_t number1u;
  uint128_t number2u;
  int128_t  number1;
  int128_t  number2;    
  int      fcc;
  
  unsigned char str1[STR_LEN + 1] = {0};
  unsigned char str2[STR_LEN + 1] = {0};    
  const char *hex_digits16 = "0123456789abcdef";
  const char *hex_digits8 = "01234567";
  const char *hex_digits4 = "0123";
  const char *hex_digits2 = "01";
  
  srand(time(NULL));
  
  for (j = 0; j < NUMB; j++) {
    
    str1[31] = hex_digits16[ rand() % 16 ];
    str1[30] = hex_digits16[ rand() % 16 ];      
    str1[29] = hex_digits16[ rand() % 16 ];
    str1[28] = hex_digits16[ rand() % 16 ];      
    str1[27] = hex_digits16[ rand() % 16 ];
    str1[26] = hex_digits16[ rand() % 16 ];      
    str1[25] = hex_digits16[ rand() % 16 ];
    str1[24] = hex_digits16[ rand() % 16 ];      
    str1[23] = hex_digits16[ rand() % 16 ];
    str1[22] = hex_digits16[ rand() % 16 ];      
    str1[21] = hex_digits16[ rand() % 16 ];
    str1[20] = hex_digits16[ rand() % 16 ];      
    str1[19] = hex_digits16[ rand() % 16 ];
    str1[18] = hex_digits16[ rand() % 16 ];      
    str1[17] = hex_digits16[ rand() % 16 ];
    str1[16] = hex_digits16[ rand() % 16 ];      
    str1[15] = hex_digits16[ rand() % 16 ];
    str1[14] = hex_digits16[ rand() % 16 ];      
    str1[13] = hex_digits16[ rand() % 16 ];
    str1[12] = hex_digits16[ rand() % 16 ];      
    str1[11] = hex_digits16[ rand() % 16 ];
    str1[10] = hex_digits16[ rand() % 16 ];      
    str1[9] = hex_digits16[ rand() % 16 ];
    str1[8] = hex_digits16[ rand() % 16 ];      
    str1[7] = hex_digits16[ rand() % 16 ];
    str1[6] = hex_digits16[ rand() % 16 ];      
    str1[5] = hex_digits16[ rand() % 16 ];
    str1[4] = hex_digits16[ rand() % 16 ];      
    str1[3] = hex_digits16[ rand() % 16 ];
    str1[2] = hex_digits16[ rand() % 16 ];      
    str1[1] = hex_digits16[ rand() % 16 ];
    str1[0] = hex_digits16[ rand() % 16 ];

    str2[31] = hex_digits16[ rand() % 16 ];
    str2[30] = hex_digits16[ rand() % 16 ];      
    str2[29] = hex_digits16[ rand() % 16 ];
    str2[28] = hex_digits16[ rand() % 16 ];      
    str2[27] = hex_digits16[ rand() % 16 ];
    str2[26] = hex_digits16[ rand() % 16 ];      
    str2[25] = hex_digits16[ rand() % 16 ];
    str2[24] = hex_digits16[ rand() % 16 ];      
    str2[23] = hex_digits16[ rand() % 16 ];
    str2[22] = hex_digits16[ rand() % 16 ];      
    str2[21] = hex_digits16[ rand() % 16 ];
    str2[20] = hex_digits16[ rand() % 16 ];      
    str2[19] = hex_digits16[ rand() % 16 ];
    str2[18] = hex_digits16[ rand() % 16 ];      
    str2[17] = hex_digits16[ rand() % 16 ];
    str2[16] = hex_digits16[ rand() % 16 ];      
    str2[15] = hex_digits16[ rand() % 16 ];
    str2[14] = hex_digits16[ rand() % 16 ];      
    str2[13] = hex_digits16[ rand() % 16 ];
    str2[12] = hex_digits16[ rand() % 16 ];      
    str2[11] = hex_digits16[ rand() % 16 ];
    str2[10] = hex_digits16[ rand() % 16 ];      
    str2[9] = hex_digits16[ rand() % 16 ];
    str2[8] = hex_digits16[ rand() % 16 ];      
    str2[7] = hex_digits16[ rand() % 16 ];
    str2[6] = hex_digits16[ rand() % 16 ];      
    str2[5] = hex_digits16[ rand() % 16 ];
    str2[4] = hex_digits16[ rand() % 16 ];      
    str2[3] = hex_digits16[ rand() % 16 ];
    str2[2] = hex_digits16[ rand() % 16 ];      
    str2[1] = hex_digits16[ rand() % 16 ];
    str2[0] = hex_digits16[ rand() % 16 ];

    number1u = 0;
    number2u = 0;
    number1 = 0;
    number2 = 0;      
    for(i=(STR_LEN-1), p=0; i >= 0; i--, p++){
      if(str1[i]>='0' && str1[i]<='9') {
	temp=str1[i]-0x30;
      }
      else if((str1[i]>='A' && str1[i]<='F') ||
	      (str1[i]>='a' && str1[i]<='f')) {
	switch(str1[i])  {
	case 'A': case 'a': temp=10; break;
	case 'B': case 'b': temp=11; break;
	case 'C': case 'c': temp=12; break;
	case 'D': case 'd': temp=13; break;
	case 'E': case 'e': temp=14; break;
	case 'F': case 'f': temp=15; break;
	}
      }
      number1u += (uint128_t) (temp * pow(16.0, p));
    }
      
    for(i=(STR_LEN-1), p=0; i >= 0; i--, p++){
      if(str2[i]>='0' && str2[i]<='9') {
	temp=str2[i]-0x30;
      }
      else if((str2[i]>='A' && str2[i]<='F') ||
	      (str2[i]>='a' && str2[i]<='f')) {
	switch(str2[i])  {
	case 'A': case 'a': temp=10; break;
	case 'B': case 'b': temp=11; break;
	case 'C': case 'c': temp=12; break;
	case 'D': case 'd': temp=13; break;
	case 'E': case 'e': temp=14; break;
	case 'F': case 'f': temp=15; break;
	}
      }
      number2u += (uint128_t) (temp * pow(16.0, p));
    }

    for(i=(STR_LEN-1), p=0; i >= 0; i--, p++){
      if(str1[i]>='0' && str1[i]<='9') {
	temp=str1[i]-0x30;
      }
      else if((str1[i]>='A' && str1[i]<='F') ||
	      (str1[i]>='a' && str1[i]<='f')) {
	switch(str1[i])  {
	case 'A': case 'a': temp=10; break;
	case 'B': case 'b': temp=11; break;
	case 'C': case 'c': temp=12; break;
	case 'D': case 'd': temp=13; break;
	case 'E': case 'e': temp=14; break;
	case 'F': case 'f': temp=15; break;
	}
      }
      number1 += (uint128_t) (temp * pow(16.0, p));
    }
      
    for(i=(STR_LEN-1), p=0; i >= 0; i--, p++){
      if(str2[i]>='0' && str2[i]<='9') {
	temp=str2[i]-0x30;
      }
      else if((str2[i]>='A' && str2[i]<='F') ||
	      (str2[i]>='a' && str2[i]<='f')) {
	switch(str2[i])  {
	case 'A': case 'a': temp=10; break;
	case 'B': case 'b': temp=11; break;
	case 'C': case 'c': temp=12; break;
	case 'D': case 'd': temp=13; break;
	case 'E': case 'e': temp=14; break;
	case 'F': case 'f': temp=15; break;
	}
      }
      number2 += (uint128_t) (temp * pow(16.0, p));
    }      

    printf("%s_%s_%d_%d_%d\n", str1, str2, (number1 == number2), (number1 < number2), (number1u < number2u));
  }
 
  return EXIT_SUCCESS;
}
