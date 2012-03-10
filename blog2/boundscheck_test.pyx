import numpy as np
cimport numpy as np
cimport cython

@cython.boundscheck(False)
def array_add_false(np.ndarray[np.int_t, ndim=2] arr):
    cdef unsigned int x, y, i, j
    x = arr.shape[0]
    y = arr.shape[1]
    for i in xrange(x):
        for j in xrange(y):
            arr[i,j] = i+j
    return arr

@cython.boundscheck(True)
def array_add_true(np.ndarray[np.int_t, ndim=2] arr):
    cdef unsigned int x, y, i, j
    x = arr.shape[0]
    y = arr.shape[1]
    for i in xrange(x):
        for j in xrange(y):
            arr[i,j] = i+j
    return arr