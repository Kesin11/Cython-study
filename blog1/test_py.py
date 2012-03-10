def simple_add(MAX):
    result=0
    for i in xrange(0, MAX):
        result += i
    print result
    
def odd(MAX):
    odds=[]
    for i in xrange(0, MAX):
        if(i%2 != 0):
            odds.append(i)
            
def odd_listcomp(MAX):
    odds = [odd for odd in xrange(0, MAX) if odd%2 != 0]
    
import math
def logsum(li):
    logs = [math.log(i) for i in li]
    #logs = [math.log(i) for i in xrange(1, MAX)]
    log_sum = sum(logs)
    print log_sum
    
import numpy
def logsum_numpy(li):
    logs = numpy.array(li, dtype=numpy.float64)
    logs = numpy.log(logs)
    log_sum = logs.sum()
    print log_sum

def dim2sum_numpy(N):
    vec2 = numpy.zeros((N, N), dtype=numpy.float64)
    for i in xrange(N):
        for j in xrange(N):
            #vec2[i][j] = i+j
            vec2[i,j] = i+j #fix
    vec2 += 1
    for i in xrange(N):
        vec2[i] /= vec2[i].sum()
    vec2_sum = vec2.sum()
    print vec2_sum
