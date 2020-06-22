#include <stdio.h>
typedef float V __attribute__((vector_size(16)));
V foo (V a, V b) { return a+b*a; }

main(int argc, char** argv) {
	V a = {12.5};
	V b = {25.7};
	V c;
 	c= foo(a, b);
	printf("Value of c is %v4f\n", c);
}
