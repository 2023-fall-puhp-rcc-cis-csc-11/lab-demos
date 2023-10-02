
#include <stdio.h>

extern void console_demo();

int main()
{
	//	Welcome
	printf("My name is Caspian Bellevedere. Welcome to the driver module!\n");
	printf("I will now call the console_demo module ...\n");
	
	//	Delete the output file, if it exists
	remove("output.txt");
	
	//	No arguments; It just does console stuff.
	console_demo();
	
	printf("The driver is now back in control.\n");
	
	printf("Goodbye!\n");
	
	return 0;
}


