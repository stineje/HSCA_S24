// fp.c
// james.stine@okstate.edu 29 March 2024

// Also check https://www.h-schmidt.net/FloatConverter/IEEE754.html

#include <stdio.h>
#include <math.h>

union {
  float val;
  unsigned short x[2];
} a, b, c;

int main() {

  a.val = 1.95;
  b.val = 1.875;
  c.val = a.val / b.val;

  printf("a = %1.15f\n", a.val);
  printf("hex: %4.4x %4.4x\n", a.x[1], a.x[0]);
  printf("b = %1.15f\n", b.val);
  printf("hex: %4.4x %4.4x\n", b.x[1], b.x[0]);
  printf("c = %1.15f\n", c.val);
  printf("hex: %4.4x %4.4x\n", c.x[1], c.x[0]);    

}
