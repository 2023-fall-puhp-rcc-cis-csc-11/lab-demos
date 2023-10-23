

//
#include <iostream>


//
extern "C"
{
	void looper();
}


//
using std::cout, std::endl;


//
int main()
{
	//
	cout << "Hello from the main.cpp driver" << endl;
	
	//
	looper();
	
	//
	cout << "Driver has regained control" << endl;
	
	return 0;
}

