from turtle import Vec2D
def simple_add(MAX):
    result=0
    for i in xrange(0, MAX):
        result += i
        
def simple_addc(long MAX):
    cdef long i
    cdef long result=0
    for i in xrange(0, MAX):
        result += i
        
def odd_listcomp(long MAX):
    cdef long odd
    odds = [odd for odd in xrange(0, MAX) if odd%2 != 0]
    
from libcpp.vector cimport vector
def odd_vec(long MAX):
    cdef vector[long] odds
    cdef long i
    for i in xrange(0, MAX):
        if(i%2 != 0):
            odds.push_back(i)
            
cdef extern from "math.h":
    double log(double)
def logsum(li):
    cdef vector[double] logs
    cdef double log_sum = 0
    cdef int M = len(li)
    cdef int i
    for i in xrange(M):
        logs.push_back(log(li[i]))
    for i in xrange(M):
        log_sum += logs[i]
    print log_sum
'''
def dim2sum(int N):
    cdef vector[vector[double]] vec2
    cdef double row_sum, all_sum
    cdef int i
    vec2.resize(N)
    for i in xrange(N):
        vec2[i].resize(N)
    
    for i in xrange(N):
        for j in xrange(N):
            vec2[i][j] = i+j
            
    for i in xrange(N):
        row_sum = 0
        for j in xrange(N):
            vec2[i][j] += 1
            row_sum += vec2[i][j]
        for j in xrange(N):
            vec2[i][j] /= row_sum
            
    all_sum = 0
    for i in xrange(N):
        for j in xrange(N):
            all_sum += vec2[i][j]
    print all_sum
'''        
import numpy as np
cimport numpy as np
def dim2sum_pynumpy(int N):
    cdef int i, j
    cdef double vec2_sum
    vec2 = np.zeros((N, N), dtype=np.float64)
    for i in xrange(N):
        for j in xrange(N):
            vec2[i][j] = i+j
    vec2 += 1
    for i in xrange(N):
        vec2[i] /= vec2[i].sum()
    vec2_sum = vec2.sum()
    print vec2_sum
    return
    

