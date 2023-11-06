

//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>


//
long getInput(double* theDouble)
{
	//
	char buffer[LINE_MAX];
	
	//	Grab Side1
	if (fgets(buffer, LINE_MAX, stdin) == NULL || sscanf( buffer, "%lf", theDouble ) < 1) {
		return 0;
	}
	
	return 1;
}


//
int main()
{
	//
	double value;
	long result = getInput(&value);
	
	printf("getInput returned %ld and the value is now: %lf\n", result, value);
	
	return 0;
}





