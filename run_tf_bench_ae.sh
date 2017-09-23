#!/usr/bin/env bash

unset PYTHONPATH

echo "Creating new conda environment"
yes | conda remove --name $1 --all
yes | conda create --name $1 python=$2

echo "Activating new conda environment"
source activate $1
pip install numpy h5py

export PYTHONPATH="$CONDA_PREFIX/lib/python$2/site-packages"
echo $PYTHONPATH
which python

echo "Updating tensorflow"
cd ~/tensorflow
git pull origin master

echo "Cleaning up old installs"
bazel clean
rm -rf ~/.cache/bazel
rm -f /tmp/tensorflow_pkg/tensorflow*.whl

echo "Building tensorflow"
yes "" | ./configure

if [ $1 = "tf_bench_36" ]; then
    bazel build -c opt --copt=-msse4.1 --copt=-msse4.2 --copt=-msse3 --copt=-mavx --copt=-mfpmath=both -k //tensorflow/tools/pip_package:build_pip_package
elif [ $1 = "tf_bench_36_mkl_1" ]; then
    bazel build --config=mkl --copt="-DEIGEN_USE_VML" -c opt -k //tensorflow/tools/pip_package:build_pip_package
elif [ $1 = "tf_bench_36_mkl_2" ]; then
    bazel build --config=mkl --copt="-DEIGEN_USE_VML" -c opt --copt=-msse4.1 --copt=-msse4.2 --copt=-msse3 --copt=-mavx --copt=-mfpmath=both -k //tensorflow/tools/pip_package:build_pip_package
elif [ $1 = "tf_bench_27" ]; then
    bazel build -c opt --copt=-msse4.1 --copt=-msse4.2 --copt=-msse3 -k //tensorflow/tools/pip_package:build_pip_package
elif [ $1 = "tf_bench_27_mkl_1" ]; then
    bazel build --config=mkl --copt="-DEIGEN_USE_VML" -c opt -k //tensorflow/tools/pip_package:build_pip_package
elif [ $1 = "tf_bench_27_mkl_2" ]; then
    bazel build --config=mkl --copt="-DEIGEN_USE_VML" -c opt --copt=-msse4.1 --copt=-msse4.2 --copt=-msse3 --copt=-mfpmath=both -k //tensorflow/tools/pip_package:build_pip_package
else
    echo "No valid env"
fi

echo "Installing tensorflow"
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
pip install --ignore-installed --upgrade /tmp/tensorflow_pkg/tensorflow*.whl

cd ~/tf_bench
python -c 'import tensorflow as tf; print(tf.__version__); sess = tf.InteractiveSession(); sess.close();'

echo "Installing keras"
pip install keras

echo "Running mnist"
python mnist_cnn.py

echo "Running cifar"
python cifar10_cnn.py
