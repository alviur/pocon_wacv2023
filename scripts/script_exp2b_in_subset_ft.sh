#!/bin/bash

if [ "$1" != "" ]; then
    echo "Running dataset: $1"
else
    echo "No dataset has been assigned."
fi
if [ "$2" != "" ]; then
    echo "Running on gpu: $2"
else
    echo "No gpu has been assigned."
fi

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )"
SRC_DIR="$PROJECT_DIR/src"
echo "Project dir: $PROJECT_DIR"
echo "Sources dir: $SRC_DIR"

RESULTS_DIR="$PROJECT_DIR/results" 
if [ "$3" != "" ]; then
    RESULTS_DIR=$3
else
    echo "No results dir is given. Default will be used."
fi
echo "Results dir: $RESULTS_DIR"


# for APPROACH in finetune 
# do
APPROACH="finetune"

if [ "$1" = "random5" ]; then
        for SEED in 0 1 2 3 4
        do
                PYTHONPATH=$SRC_DIR python3 -u $SRC_DIR/main_incremental.py --exp_name exp2b_random_${SEED} \
                        --datasets imagenet_subset --num_tasks 10 --network resnet18 --seed $SEED \
                        --nepochs 200 --batch_size 128 --results_path $RESULTS_DIR \
                        --gridsearch_tasks 3 --gridsearch_config gridsearch_config \
                        --gridsearch_acc_drop_thr 0.2 --gridsearch_hparam_decay 0.5 \
                        --approach $APPROACH --gpu $2 
        done
else
        echo "Running on dataset: $1"
        PYTHONPATH=$SRC_DIR python3 -u $SRC_DIR/main_incremental.py --exp_name exp2b \
                --datasets $1 --num_tasks 10 --network resnet18 \
                --nepochs 200 --batch_size 128 --results_path $RESULTS_DIR \
                --gridsearch_tasks 3 --gridsearch_config gridsearch_config \
                --gridsearch_acc_drop_thr 0.2 --gridsearch_hparam_decay 0.5 \
                --approach $APPROACH --gpu $2

fi

#done
