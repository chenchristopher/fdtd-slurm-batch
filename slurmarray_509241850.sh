#!/bin/bash
#Job name:
#SBATCH --job-name=array_test
#
# Array definition
# The number after the pound symbol is the number of 
# concurrent processes that the array can run.
# This can be used to prevent running out of engine 
# licenses.
#SBATCH --array=0-0%5
#
# Partition:
#SBATCH --partition=nano1 --account=nano
#
# Processors:
#SBATCH --ntasks=8
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
##SBATCH --mail-user=XXX@XXX.XXX

## Run command
MPI_PATH="/global/home/groups-sw/nano/software/sl-7.x86_64/lumerical/fdtd-8.20.1661/mpich2/nemesis/bin/mpiexec"
LUM_PATH="/global/home/groups-sw/nano/software/sl-7.x86_64/lumerical/fdtd-8.20.1661/bin/fdtd-engine-mpich2nem"

# List of files:
FLIST="/global/home/users/christopherchen/fdtd-slurm-batch/example/1_Gamma-L_1.fsp"
# Redefine the file list as an array
FARRAY=($FLIST)

# File to run is in the array indexed by the task ID
FILE_PATH=${FARRAY[$SLURM_ARRAY_TASK_ID]}

echo "Running file $FILE_PATH"
module unload openmpi
module load lumerical/fdtd-8.20.1661
     $MPI_PATH $LUM_PATH $FILE_PATH;
echo "Completed at `date`"