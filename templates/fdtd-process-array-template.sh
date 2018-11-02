#!/bin/bash
# This script is used to replace tags in a template script file with actual
# values for an FDTD Solutions project file. The script is called with the following
# arguments:
#
# fdtd-process-template.sh <#processes> <template file> <fsp files> 
#
#
# The script will replace the following tokens in the template file with specified values
# Token                	Value
# <n>                  	The number of processes to use
# <flist>				The list of paths to fsp files, space delimited
# <numfiles>			The number of files in the file list
# <email>				Email address to be emailed by the script
# <lumpath>				Path to Lumerical engine
# <mpipath> 			Path to MPI
############################################################################################

MPI_PATH="/global/home/groups-sw/nano/software/sl-7.x86_64/lumerical/fdtd-8.20.1661/mpich2/nemesis/bin/mpiexec"
LUM_PATH="/global/home/groups-sw/nano/software/sl-7.x86_64/lumerical/fdtd-8.20.1661/bin/fdtd-engine-mpich2nem"
EMAIL="christopherchen@lbl.gov"


#Number of processes
PROCS=$1
shift

#template files
TEMPLATE_FILE=$1
shift

# FLIST=$1
# shift
# ((COUNT=0))
# while (($# > 0)) ; do
	# FLIST="$FLIST $1"
	# ((COUNT=COUNT+1))
	# shift
# done

# number of files 
COUNT=$#
# list of fsp file paths
FLIST="$@"

# Replace items in template script
sed -e "s#<n>#$PROCS#g" \
    -e "s#<flist>#$FLIST#g" \
    -e "s#<email>#$EMAIL#g" \
    -e "s#<lumpath>#$LUM_PATH#g" \
    -e "s#<mpipath>#$MPI_PATH#g" \
	-e "s#<numfiles>#$COUNT#g" \
    $TEMPLATE_FILE
	
