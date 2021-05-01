#!/bin/sh

echo "Cloning Lambda Labs Tensorflow 2.x benchmarks..."
echo
git clone https://github.com/lambdal/lambda-tensorflow-benchmark.git --recursive
cd lambda-tensorflow-benchmark
git checkout tf2
git submodule update --init --recursive
cd ..

# Parsing configuration

IMAGE=$1
POWER_LIMITS_LIST=$2
BATCHES_PER_RUN=$3
ITERATIONS=$4
CPU_MODEL=$5
GPU_MODEL=$6

# List of power limits
oIFS="$IFS"; IFS=, ; set -- $POWER_LIMITS_LIST ; IFS="$oIFS"

echo
echo "Current configuration"
echo "---------------------"
echo
echo "Image: $IMAGE"
echo "Power Limits: $POWER_LIMITS_LIST"
echo "Batches per run: $BATCHES_PER_RUN"
echo "Iterations: $ITERATIONS"
echo "CPU: $CPU_MODEL"
echo "GPU: $GPU_MODEL"

# Report init

echo
echo "Initializing Report"
echo "-------------------"
echo

REPORT_PATH="./results/"$CPU_MODEL"-"$GPU_MODEL".md"

echo "Report path: $REPORT_PATH"

./init_report.sh > $REPORT_PATH

echo
echo "Executing benchmarks"
echo "--------------------"

for i in "$@"; do
  echo
  echo "** EXECUTING TESTS WITH $i W POWER LIMIT **"
  echo setting power limit to $i
  nvidia-smi -i 0 -pl $i
  echo
  echo "** Running $IMAGE docker container with following configuration**"
  echo "docker run --gpus all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --rm -it -v ${PWD}:/bench -w /bench/ nvcr.io/nvidia/tensorflow:20.10-tf2-py3 ./exec_bench.sh $BATCHES_PER_RUN $CPU_MODEL $GPU_MODEL $i $ITERATIONS"
  echo
  docker run --gpus all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --rm -it -v ${PWD}:/bench -w /bench/ nvcr.io/nvidia/tensorflow:20.10-tf2-py3 ./exec_bench.sh $BATCHES_PER_RUN $CPU_MODEL $GPU_MODEL $i $ITERATIONS

  echo "** TESTS ENDED WITH $i W POWER LIMIT**"
  echo
done

