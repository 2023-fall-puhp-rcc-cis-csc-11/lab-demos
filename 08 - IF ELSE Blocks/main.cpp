

//
#include <iostream>


//
extern "C"
{
	void if_tester();
}


//
using std::cout, std::endl;


//
int main()
{
	//
	cout << "Hello from the main.cpp driver." << endl;
	
	//
	if_tester();
	
	//
	cout << "Driver has regained control." << endl;
	
	return 0;
}

