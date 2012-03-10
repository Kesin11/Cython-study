'''$ python setup.py build_ext --inplace'''
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy

setup(
      cmdclass = {'build_ext': build_ext},
      ext_modules = [Extension("convolve_cy", ["convolve_cy.pyx"]),
                     Extension("convolve_cdef", ["convolve_cdef.pyx"]),
                     Extension("convolve_cimport", ["convolve_cimport.pyx"], include_dirs=[numpy.get_include()]),
                     Extension("convolve_ndarray", ["convolve_ndarray.pyx"], include_dirs=[numpy.get_include()]),
                     Extension("convolve_efficient", ["convolve_efficient.pyx"], include_dirs=[numpy.get_include()]),
                     Extension("convolve_boundscheck", ["convolve_boundscheck.pyx"], include_dirs=[numpy.get_include()]),
                     Extension("boundscheck_test", ["boundscheck_test.pyx"], include_dirs=[numpy.get_include()])
                     ]
)