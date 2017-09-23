import sys
import os
#sys.path.append('/home/asanzgiri/miniconda/envs/deep_train_expt/lib/python2.7/site-packages/tensorflow')

import tensorflow as tf

print(tf.__file__)

path = os.path.dirname(tf.__file__)
print(path)

path = os.path.abspath(tf.__file__)
print(path)

print(tf.__version__)
print(os.environ['PYTHONPATH'])
print(os.environ['PATH'])
