#include <stdio.h>

void simple_add(long long MAX){
	long long i=0;
	long long  result=0;
	for(i=0;i<MAX;i++){
		result += i;
	}
}

int main()
{
	simple_add(100000000);

	return 0;
}
