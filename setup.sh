#!/bin/bash
# This script will initialize all the settings for the .ini file and add
# this directory to the user path variable.

echo "Setting up fdtd-slurm-batch"
echo "Your home directory is $HOME"
SCRIPTDIR=`dirname $(readlink -f $(which --skip-alias $0))`
echo "Current directory is $SCRIPTDIR"
echo "export PATH=$SCRIPTDIR:$PATH"


echo 'fdtd-slurm-batch setup completed.'
