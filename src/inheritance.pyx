'''
Inheritance in Cython
Assert error, but it's OK
'''
class foo(object):
    def __init__(self):
        print "base foo class"
    def print_base(self):
        print "This print is base class"
        
class bar(foo):
    def __init__(self):
        print "inheritance bar class"
        self.print_base()