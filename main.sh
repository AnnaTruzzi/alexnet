#!/bin/bash
CHECKPOINTBUCKET="neurana-imaging"
CHECKPOINTPATH="rhodricusack/alexnet/checkpoints"

# Resume from last checkpoint
RESUME=$(aws s3 ls s3://$CHECKPOINTBUCKET/$CHECKPOINTPATH/checkpoint_ | awk '{print $4}' | sort -n -t _ -k 2 | tail -n 1)
RESUME_FALLBACK=$(aws s3 ls s3://$CHECKPOINTBUCKET/$$CHECKPOINTPATH/checkpoint_ | awk '{print $4}' | sort -n -t _ -k 2 | tail -n 2 | head -n 1)


# Parallel across GPUs, but just machine
$HOME/anaconda3/envs/pytorch_p36/bin/python main.py -a alexnet --lr 0.01 --dist-url 'tcp://127.0.0.1:24777' \
    --dist-backend 'nccl' --multiprocessing-distributed --world-size 1 --rank 0 /imagenet \
    --s3bucket ${CHECKPOINTBUCKET} --s3prefix ${CHECKPOINTPATH} --sobel \
    --resume ${RESUME}


