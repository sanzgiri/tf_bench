#!/usr/bin/env bash

echo "Cleaning up old installs"
bazel clean
rm -rf ~/.cache/bazel
rm -f /tmp/tensorflow_pkg/tensorflow*.whl

cd ~/tensorflow
#bazel build -c opt --config=cuda --config=monolithic --copt=-msse4.1 --copt=-msse4.2 --copt=-msse3 --copt=-mfma --copt=-mavx --copt=-mavx2 -k //tensorflow/tools/pip_package:build_pip_package
bazel build -c opt --config=cuda --config=mkl --copt="-DEIGEN_USE_VML" --copt=-msse4.1 --copt=-msse4.2 --copt=-msse3 --copt=-mfma --copt=-mavx --copt=-mavx2 -k //tensorflow/tools/pip_package:build_pip_package

echo "Installing tensorflow"
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
pip install --ignore-installed --upgrade /tmp/tensorflow_pkg/tensorflow*.whl

cd ~/tf_bench
python -c 'import tensorflow as tf; print(tf.__version__); sess = tf.InteractiveSession(); sess.close();'

echo "Installing keras"
pip install keras

echo "Running mnist"
time python mnist_cnn.py 20 'l'

echo "Running cifar"
time python cifar10_cnn.py 20 'l'
