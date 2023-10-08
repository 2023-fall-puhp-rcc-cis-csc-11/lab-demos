
#include <iostream>

using
	std::cout, std::endl
	;

extern "C"
{
	void local_vars();
}

int main()
{
	//
	cout << "Hello! My name is Cecil Hipplington-Shoreditch. Welcome to my Local Variable demo!" << endl;
	
	local_vars();
	
	//
	cout << "The driver is back in control." << endl;
	
	//
	cout << "Program exiting" << endl;
	
	return 0;
}

