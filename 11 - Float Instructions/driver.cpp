

//
#include <iostream>


//
extern "C"
{
	double floater();
}


//
using std::cout, std::endl;


//
int main()
{
	//
	cout << "Hello from the driver" << endl;
	
	//
	double returnValue = floater();
	
	//
	cout << "Driver has regained control" << endl;
	cout << "Driver received this value: " << returnValue << endl;
	
	return 0;
}

