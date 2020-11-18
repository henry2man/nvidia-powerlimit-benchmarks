# nvidia-powerlimit-benchmarks
A set of scripts that allows you to run benchmarks on NVida graphics cards by setting different power levels.  The repository is open to suggestions and improvements as well as the publication of new results.

In current implementation we use [Lambda Labs Tensorflow Benchmarks](https://github.com/lambdal/lambda-tensorflow-benchmark/tree/tf2). 

## Prerequisites

* A Nvidia GPU 😄
* Ubuntu 20.04 (other similar systems may also work)
* NVidia drivers installed
* Docker with GPU support (please check https://www.tensorflow.org/install/docker)


## How to benchmark your system

First you need to use `nvidia-smi` to check allowed power limits:

```shell
sudo nvidia-smi -pl 10
```

The output of the comand will tell you the minimum and maximum power limits of your card:

```shell
Provided power limit 10.00 W is not a valid power limit which should be between 100.00 W and 242.00 W for GPU 00000000:29:00.0
Terminating early due to previous errors.
```

Then you can run the benchmark script. You'll need to execute it as root. This is needed to let the script change your GPU power limit. The following command will execute a full benchmark with:

* **Docker image**: nvcr.io/nvidia/tensorflow:20.10-tf2-py3 - Tensorflow 2.x Python 3 image
* **GPU Power limits to be tested** (comma separated): 100,130,160,190,220,242 
* **Batches per run**: 50
* **CPU Code**: 3600 (for Ryzen 5 3600)
* **GPU Code**: GeForce_RTX_3070 

```shell
sudo ./run_benchmarks.sh nvcr.io/nvidia/tensorflow:20.10-tf2-py3 100,130,160,190,220,242 50 3600 GeForce_RTX_3070
````

## Results

When benchmarks are completed the `./results` folder will contain a Markdown file with the results. In the example we will find a file called `3600-GeForce_RTX_3070.md` 

