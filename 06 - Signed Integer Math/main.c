

//
#include <stdio.h>


//
extern long math();


//
int main()
{
	//
	printf("Hello from the main.c driver\n");
	
	//
	long result = math();
	
	//
	printf("Driver got the following value from math(): %ld\n", result);
	
	return 0;
}

