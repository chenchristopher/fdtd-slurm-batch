#!/bin/bash
# This script will create a Slurm style job submission script for
# FDTD Solutions project files as a Slurm job array using the template 
# provided in templates/fdtd-slurm-array-template.sh. The script is then 
# submitted with the sbatch command. Certain tags in the template file 
# are replaced with project specific values that are extracted from the 
# project file.
#
# The calling convention for this script is:
#
# fdtd-run-slurm-array.sh [-n <procs>] fsp1 [fsp2 ... [fspN]]
#
# The arguments are as follows:
#
# -n        The number of processes to use for the job(s).
#           If no argument is given a default value of 8 is used
#
# fsp*      An FDTD Solutions project file. One is required, but
#           multiple can be specified on one command line
#
# Important parameters, including the number of jobs that can be run 
# simultaneously, are contained in 
# templates/fdtd-process-array-template.sh
# 
# This can also be configured to email you by uncommenting two lines in 
# templates/fdtd-slurm-array-template.sh
#
# This script is a heavily modified version of the PBS script provided by
# Lumerical.
#
##########################################################################

#Locate the directory of this script so we can find
#utility scripts and templates relative to this path
SCRIPTDIR=`dirname $(readlink -f $(which --skip-alias $0))`

#The location of the template file to use when submitting jobs
#The line below can be changed to use your own template file
TEMPLATE=$SCRIPTDIR/templates/fdtd-slurm-array-template.sh

#Determine number of processes to use. Default is 8 if no -n argument is
#given
PROCS=8
if [ "$1" = "-n" ]; then
    PROCS=$2
    shift
    shift
fi

# Generate a unique name for the shell script file using the bash date 
# function
SHELLFILE="$SCRIPTDIR/slurmarray_`date +%N`.sh"

# Pass the rest of the arguments as the list of files, making sure we have 
# the full path for every file. Note that this assumes that the target fsp 
# files are located in a subdirectory of the directory containing this 
# script.

COUNT=$#
echo "$COUNT file(s) submitted."

FLIST=" "
# Loop over all remaining arguments
while(( $# > 0 ))
do
	# If this is the first file... 
	if [ "${FLIST: -1}" = " " ]
	then 
		FLIST="$(readlink -f $1)"
	elif [ "${1: -4}" = ".fsp" ]
	then
		## Adds the next arguments as full paths to the file lists
		FLIST="$FLIST $(readlink -f $1)"

	else
		echo "$1 is not a valid Lumerical file."
		((COUNT=COUNT-1))
	fi
    shift
done

if((COUNT > 0))
then
	echo "$COUNT valid file(s) to be submitted to job array."
	# Submit the list of files to the next script
	$SCRIPTDIR/templates/fdtd-process-array-template.sh $PROCS $TEMPLATE $FLIST > $SHELLFILE

	# Run the Slurm job array
	sbatch $SHELLFILE
else
	echo "No valid Lumerical files."
fi
