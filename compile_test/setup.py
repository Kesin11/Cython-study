#coding: utf-8
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

'''
$ python setup.py build_ext --inplace

In [7]: timeit -n 5 py.test(st, 10)
5 loops, best of 3: 2.16 s per loop
In [8]: timeit -n 5 pxd.test(st, 10)
5 loops, best of 3: 1.89 s per loop
In [9]: timeit -n 5 cy.test(st, 10)
5 loops, best of 3: 1.91 s per loop
In [10]: timeit -n 5 py.test(st, 10)
5 loops, best of 3: 2.16 s per loop
In [11]: timeit -n 5 cy.test(st, 10)
5 loops, best of 3: 1.9 s per loop
In [12]: timeit -n 5 pxd.test(st, 10)
5 loops, best of 3: 1.9 s per loop
In [13]: timeit -n 5 cy.test(st, 10)
5 loops, best of 3: 1.89 s per loop
In [14]: timeit -n 5 pxd.test(st, 10)
5 loops, best of 3: 1.89 s per loop
In [15]: timeit -n 5 py.test(st, 10)
5 loops, best of 3: 2.14 s per loop

AVERAGE
py.test: 2.15333
pxd.test: 1.89333
cy.test: 1.9
dict, listの型指定はあまり効果ない？
logも効果がないところを見ると回数が少なすぎる？

In [16]: timeit -n 3 py.test(st, 50)
3 loops, best of 3: 14.4 s per loop
In [17]: timeit -n 3 pxd.test(st, 50)
3 loops, best of 3: 12.4 s per loop
In [18]: timeit -n 3 cy.test(st, 50)
3 loops, best of 3: 12.4 s per loop
変わらない。明示しなくてもコンパイルで処理されてるのか？
Cライブラリを多用しないならpxdでコンパイルするだけで効果ありそう

py_mecab.pyもコンパイルしてみた
In [7]: timeit py.test(st, 50)
1 loops, best of 3: 12.1 s per loop
In [8]: timeit cy.test(st, 50)
1 loops, best of 3: 12.1 s per loop

In [10]: timeit -n 20 cy.test(st, 2)
20 loops, best of 3: 343 ms per loop
In [11]: timeit -n 20 py.test(st, 2)
20 loops, best of 3: 344 ms per loop
for文, 関数呼び出しの回数にも相関無し。
C関数呼び出しやcdefで書けるものだけpyxかpxdで書けばいい気がしてきた

In [7]: timeit -n 20 py.test(st, 2)
20 loops, best of 3: 363 ms per loop
In [8]: timeit -n 20 pxd.test(st, 2)
20 loops, best of 3: 358 ms per loop
In [9]: timeit -n 20 cy.test(st, 2)
20 loops, best of 3: 357 ms per loop
cdefで書きなおし。若干の改善が見られた
'''

setup(
      cmdclass = {'build_ext': build_ext},
      ext_modules = [Extension("cy_mecab", ["cy_mecab.pyx"]),
                     Extension("pxd_mecab",["pxd_mecab.py"]),
                     Extension("py_mecab",["py_mecab.py"])]
)