#!/bin/sh

# This shell script is intended to be executed into the docker container

# Configuration
BATCHES_PER_RUN=$1
CPU_MODEL=$2
GPU_MODEL=$3
POWER_LIMIT=$4

CONFIG=config/config_all
# CONFIG=config/config_resnet50_replicated_fp16_train_syn

cd lambda-tensorflow-benchmark

echo
echo "Executing tests with $BATCHES_PER_RUN batches per run with $CONFIG ..."
echo
TF_FORCE_GPU_ALLOW_GROWTH=true TF_XLA_FLAGS=--tf_xla_auto_jit=2 ./batch_benchmark.sh 1 1 1 $BATCHES_PER_RUN  2 $CONFIG 
 

LOGS_PATH="logs/"$CPU_MODEL"-"$GPU_MODEL".logs"
REPORT_PATH="../results/"$CPU_MODEL"-"$GPU_MODEL".md"

echo
echo "Generating reports..."
echo "Logs path: $LOGS_PATH"
echo "Report path: $REPORT_PATH"
echo

../subreport_add.sh $LOGS_PATH $POWER_LIMIT $BATCHES_PER_RUN >> $REPORT_PATH
