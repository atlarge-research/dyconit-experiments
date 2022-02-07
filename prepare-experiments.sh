#!/usr/bin/env bash

set -o pipefail

USER=$(whoami)

# Declare variables
DIR_NAME="atds-dyconits"
MINICONDA_PATH="/var/scratch/$USER/miniconda3"
EXPERIMENT_PATH="/var/scratch/$USER/$DIR_NAME/experiments"
CODE_PATH="/var/scratch/$USER/$DIR_NAME/code"
OPENCRAFT_PATH=$CODE_PATH/opencraft
YARDSTICK_PATH=$CODE_PATH/yardstick


if ! which conda
then
    # Install Miniconda 3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p $MINICONDA_PATH
    eval "$(${MINICONDA_PATH}/bin/conda shell.bash hook)"
    conda init
    rm Miniconda3-latest-Linux-x86_64.sh
else
    echo "INFO: Conda detected, skipping installation"
fi

source ~/.bashrc
if ! conda info --envs | grep -E "^opencraft\s"
then
    # Create 'opencraft' Python environment
    source ~/.bashrc
    wget https://raw.githubusercontent.com/atlarge-research/opencraft-tutorial/main/conda/spec-file.txt
    conda create --name opencraft --file spec-file.txt
    echo "conda activate opencraft" >> ~/.bashrc
    source ~/.bashrc
    rm spec-file.txt
else
    echo "INFO: Conda 'opencraft' environment detected. Skipping creation"
fi
conda activate opencraft


if ! which ocd
then
    # Install OCD
    curl -sSL https://raw.githubusercontent.com/atlarge-research/opencraft-tutorial/main/scripts/setup-opencraft.sh | bash
    source ~/.bashrc # load the prun module
else
    echo "INFO: OpenCraft Deployer (ocd) detected, skipping installation"
fi

# if [ ! -d $OPENCRAFT_PATH ]
# then
#     # Get Opencraft source code and compile
#     git clone https://github.com/atlarge-research/opencraft
#     cd opencraft
#     git checkout 4744c9f91
#     mvn verify
# fi

# if [ ! -d $YARDSTICK_PATH ]
# then
#     # Get Yardstick source code and compile
#     git clone https://github.com/atlarge-research/yardstick
#     cd yardstick
#     git checkout ...
#     mvn verify
# fi

# # Create experiment directories, put files in the right place
# if [ ! -d $EXPERIMENT_PATH ]
# then
#     mkdir -p $EXPERIMENT_PATH
    
#     cd $EXPERIMENT_PATH
#     mkdir -p experiment-scalability
#     cd experiment-scalability
#     mkdir resources policy-zero policy-aoi policy-is policy-isn

#     cd $EXPERIMENT_PATH
#     mkdir -p dynamic-consistency-experiment/resources

#     cd $EXPERIMENT_PATH
#     mkdir -p consistency-network-experiment/resources
# fi
