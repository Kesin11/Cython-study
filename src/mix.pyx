#coding: utf-8
'''
import pyximport; pyximport.install()
import mix
3乗したものと総和とを足す
'''
def mixpy(range):
    num=[]
    for x in xrange(range):
        powx = pow(x, 3)
        sumx=0
        for i in xrange(range):
            sumx += x
        num.append(sumx+powx)
    
def mixcy(int range):
    cdef int powx = 0
    cdef int sumx = 0
    cdef int add = 0
    cdef int x
    num=[]
    for x in xrange(range):
        powx = x**3
        for i in xrange(range):
            sumx += x
        add = powx + sumx
        num.append(add)

        
if __name__ == '__main__':
    mixpy(100)
    mixcy(100)
        