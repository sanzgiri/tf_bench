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
#yes "" | ./configure

if [ $1 = "tf_bench_36" ]; then
    bazel build -c opt --config=cuda --copt=-msse4.1 --copt=-msse4.2 --copt=-msse3 --copt=-mfma --copt=-mavx --copt=-mavx2 -k //tensorflow/tools/pip_package:build_pip_package
elif [ $1 = "tf_bench_36_mkl" ]; then
    bazel build -c opt --config=cuda --config=mkl --copt="-DEIGEN_USE_VML" --copt=-msse4.1 --copt=-msse4.2 --copt=-msse3 --copt=-mfma --copt=-mavx --copt=-mavx2 -k //tensorflow/tools/pip_package:build_pip_package
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
time python mnist_cnn.py 20 'l'

echo "Running cifar"
time python cifar10_cnn.py 20 'l'
