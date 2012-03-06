#include <vector>

void odd(long MAX){
	long i;
	std::vector<long> odds;
	for (i=0;i<MAX;i++){
		if(i%2 != 0){
			odds.push_back(i);
		}
	}
}
int main()
{
	odd(10000000);

	return 0;
}
