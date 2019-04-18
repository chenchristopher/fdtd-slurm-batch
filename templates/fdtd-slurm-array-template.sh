#!/bin/bash
#Job name:
#SBATCH --job-name=<jobname>
#
# Array definition
# The number after the pound symbol is the number of
# concurrent processes that the array can run.
# This can be used to prevent running out of engine
# licenses.
#SBATCH --array=0-<numfiles>%<numengines>
#
# Partition:
#SBATCH --partition=<partition> --account=<account>
#
# Processors:
#SBATCH --ntasks=<n>
#
# Memory:
#SBATCH --mem-per-cpu=<mem>
#
# Wall clock limit:
#SBATCH --time=<timelimit>
#
# Mail type:
#SBATCH --mail-type=<mailtype>
#
# Mail user:
#SBATCH --mail-user=<email>

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
