import cython
from math import log

@cython.locals(i=cython.int)
cpdef test(char* strings, int N)

cdef count_word(char* strings)

@cython.locals(word_sum=cython.int)
cdef get_prob(freq_dic)

@cython.locals(value=cython.double)
cdef aggregate_dict(dict_list)