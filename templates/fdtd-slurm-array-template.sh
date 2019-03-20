#!/bin/bash
#Job name:
#SBATCH --job-name=array_test
#
# Array definition
# The number after the pound symbol is the number of 
# concurrent processes that the array can run.
# This can be used to prevent running out of engine 
# licenses.
#SBATCH --array=0-<numfiles>%5
#
# Partition:
#SBATCH --partition=nano1 --account=nano
#
# Processors:
#SBATCH --ntasks=<n>
#
# Memory:
#SBATCH --mem-per-cpu=4G
#
# Wall clock limit:
#SBATCH --time=40:00:00
#
# Mail type: (uncomment following line once to receive emails)
##SBATCH --mail-type=all
#
# Mail user: (uncomment following line once to receive emails)
##SBATCH --mail-user=<email>

## Run command
MPI_PATH="<mpipath>"
LUM_PATH="<lumpath>"

# List of files:
FLIST="<flist>"
# Redefine the file list as an array
FARRAY=($FLIST)

# File to run is in the array indexed by the task ID
FILE_PATH=${FARRAY[$SLURM_ARRAY_TASK_ID]}

echo "Running file $FILE_PATH"
module unload openmpi
module load lumerical
     $MPI_PATH $LUM_PATH $FILE_PATH;
echo "Completed at `date`"