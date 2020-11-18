#!/bin/sh

if [ "$#" -lt 1 ] || [ ! -d "$1" ]; then
	echo "${0##*/}: provide a directory as the first argument"
	exit 1
fi

POWER_LIMIT=$2
BATCHES_PER_RUN=$3

# Based on the directory structure: 
#
#  i9-9920X-PLACEHOLDER.logs
#  ├── syn-replicated-fp16-1gpus
#  │   ├── alexnet-512
#  │   │   ├── throughput
#  │   │   │   └── 1
#  │   │   │   └── 2   <- Iteration number
#  │   │   │   └── 3
#  │   │   └── thermal
#  │   │       └── 1
#  │   │       └── 2
#  │   │       └── 3
#  │   ├── inception3-64
#  │   │   ├── throughput
#  │   │   │   └── 1
#  │   │   │   └── 2
#  │   │   │   └── 3
#  │   │   └── thermal
#  │   │       └── 1
#  │   │       └── 2
#  │   │       └── 3
#  .............................

# $1: i9-9920X-2080Ti.logs
cd $1 || exit 1

for param_dir in */; do

	# $param_dir: "syn-replicated-fp16-1gpus/"
	cd "$param_dir" || continue

	# $model_dir: "resnet152-32/" (model-batchsize)
	cat <<- EOF
	$(for model_dir in *; do
		model="$(basename $model_dir)"
		avg="$(awk '!/total/ && /images\/sec/ { s+=$3; c++ } END { print s/c }' `find $model_dir/throughput -type f`)"
		echo "$(basename $param_dir) | $model | $POWER_LIMIT | $BATCHES_PER_RUN | $avg |"
	done)
	EOF

	cd .. || exit 1
done
