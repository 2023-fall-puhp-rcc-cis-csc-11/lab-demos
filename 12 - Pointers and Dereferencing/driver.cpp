

//
#include <iostream>


//
extern "C"
{
	void point(char * printMe, long * changeMe);
	void heyDriverPrintThis(char * theString, long * theLong, double * theDouble);
}


//
using std::cout, std::endl;


//
int main()
{
	//
	cout << "Hello from the driver" << endl;
	
	//
	char myCString[] = "Hello, this is a cstring owned by main() !";
	long myLong = 100;
	
	cout << "Driver see's myLong as: " << myLong << endl;
	
	point(myCString, &myLong);
	
	cout << "Driver has regained control" << endl;
	cout << "Driver see's myLong as: " << myLong << endl;
	
	return 0;
}


//
void heyDriverPrintThis(char * theString, long * theLong, double * theDouble)
{
	cout << endl;
	cout << "Driver has received a call to heyDriverPrintThis()" << endl;
	
	cout << "Got the string: " << theString << endl;
	
	cout << "Got the long (" << theLong << "): " << *theLong << endl;
	cout << "Got the double (" << theDouble << "): " << *theDouble << endl;
	
	cout << "heyDriverPrintThis() exiting" << endl;
	cout << endl;
}





