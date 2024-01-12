// 
// Program:  random.c
// Name:  James E. Stine, Jr.
// Purpose: to create some random hex digits
// 

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define STR_LEN 2
#define NUMB 19
 
int main(void) {

    int number;
    int i, j;
    unsigned char str[STR_LEN + 1] = {0};
    const char *hex_digits16 = "0123456789abcdef";
    const char *hex_digits8 = "01234567";
    const char *hex_digits4 = "0123";
    const char *hex_digits2 = "01";
    
    srand(time(NULL)); 

    for (j = 0; j < NUMB; j++) { 
      str[1] = hex_digits16[ rand() % 16 ];
      str[0] = hex_digits4[ rand() % 4 ];
      printf("%s\n", str);
    }
 
    return EXIT_SUCCESS;
}
