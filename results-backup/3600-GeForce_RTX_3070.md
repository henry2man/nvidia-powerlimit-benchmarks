SUMMARY
===
| model | input size | param mem | feat. mem | flops  |
|-------|------------|--------------|----------------|-------------|
| resnet-50 | 224 x 224 | 98 MB | 103 MB | 4 BFLOPs |
| resnet-152 | 224 x 224 | 230 MB | 219 MB | 11 BFLOPs |
| inception-v3 | 299 x 299 | 91 MB | 89 MB | 6 BFLOPs |
| vgg-vd-19 | 224 x 224 | 548 MB | 63 MB | 20 BFLOPs |
| alexnet | 227 x 227 | 233 MB | 3 MB | 1.5 BFLOPs |

Config | Model | Power Limit | Batches per run | Iterations | REFERENCE |
:------:|:------:|:------:|:------:|:------:|:------:|
syn-replicated-fp32-1gpus | alexnet-384 | 135 | 50 | 20 | 2944.32 |
syn-replicated-fp32-1gpus | alexnet-384 | 140 | 50 | 20 | 2962.1 |
syn-replicated-fp32-1gpus | alexnet-384 | 145 | 50 | 20 | 3068.17 |
syn-replicated-fp32-1gpus | alexnet-384 | 150 | 50 | 20 | 2918.62 |
syn-replicated-fp32-1gpus | alexnet-384 | 155 | 50 | 20 | 3050.25 |
