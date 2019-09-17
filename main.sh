#!/bin/bash
$HOME/anaconda3/envs/pytorch_p36/bin/python main.py -a alexnet --lr 0.01 --dist-url 'tcp://127.0.0.1:24777' --dist-backend 'nccl' --multiprocessing-distributed --world-size 1 --rank 0 /imagenet --s3bucket neurana-imaging --s3prefix rhodricusack/alexnet/checkpoints --sobel

