

//
#include <iostream>


//
extern "C"
{
	void cool();
}


//
using std::cout, std::endl;


//
int main()
{
	//
	cout << "Hello from the main.cpp driver" << endl;
	
	//
	cool();
	
	//
	cout << "Driver has regained control" << endl;
	
	return 0;
}

