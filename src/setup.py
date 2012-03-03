from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

'''
$ python setup.py build_ext --inplace
'''

setup(
      cmdclass = {'build_ext': build_ext},
      ext_modules = [Extension("mix", ["mix.pyx"])]
)

