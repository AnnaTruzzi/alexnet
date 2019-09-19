#!/bin/bash
LINEARCLASSBUCKET="neurana-imaging"
LINEARCLASSPATH="rhodricusack/alexnet/linearclass/"

CHECKPOINTBUCKET="neurana-imaging"
CHECKPOINTPATH="rhodricusack/alexnet/checkpoints"

echo "Fill SQS with requests, where checkpoint exists but linearclass does not"
for ((tp=5;tp<25;tp+=5)); do
    getcheckpoint=$(aws s3 ls "s3://${CHECKPOINTBUCKET}/${CHECKPOINTPATH}/checkpoint_${tp}.pth.tar")
    if [ ! -z "$getcheckpoint" ]; then
        echo "Found checkpoint file $getcheckpoint"
        for ((conv=5;conv>0; conv--)); do
            gotfile=$(aws s3 ls "s3://${LINEARCLASSBUCKET}/${LINEARCLASSPATH}linearclass_time_${tp}_conv_${conv}")
            if [ -z "$gotfile" ]; then
                    echo "Nothing found for time $tp conv $conv";
                    aws sqs send-message --queue-url "https://sqs.eu-west-1.amazonaws.com/807820536621/deepcluster-linearclass.fifo" \
                        --message-body "{\"epoch\":$tp,\"conv\":$conv}" \
                        --message-group-id "standard4"
            fi
        done
    fi
done
         