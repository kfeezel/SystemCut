from distutils.core import setup
from Cython.Build import cythonize

setup(name="Read Dump File",ext_modules=cythonize("read_dump.pyx"))
setup(name="Phantomize Reduced",ext_modules=cythonize("phantom.pyx"))