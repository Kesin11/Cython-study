#include <vector>
#include <math.h>
#include <iostream>

void logsum(long MAX){
	std::vector<double> logs;
	long i;
	double log_sum = 0;
	for (i=1;i<MAX;i++){
		logs.push_back(log(i));
	}
	for (i=1;i<MAX;i++){
		log_sum += logs[i];
	}
	std::cout << log_sum << std::endl;
}

int main(){
	logsum(10000000);

	return 0;
}
