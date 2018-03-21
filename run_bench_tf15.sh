#!/usr/bin/env bash

export PYTHONPATH="$CONDA_PREFIX/lib/python3.6/site-packages"
export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ashutosh/mkl-dnn/external/mklml_lnx_2018.0.20170720/lib
export PATH="/home/ashutosh/anaconda3/bin:$PATH"

echo "Running mnist"
time python mnist_cnn.py 20 'l'

echo "Running cifar"
time python cifar10_cnn.py 20 'l'
