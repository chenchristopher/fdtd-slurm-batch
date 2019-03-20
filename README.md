# fdtd-slurm-batch
These bash scripts help automate Lumerical FDTD file submission to a cluster running the Slurm job scheduler. 

## Usage
`./fdtd-run-slurm-array.sh [-n number of processes] fsp_file_1 [fsp_file_2 ... fsp_file_N]`

## Changes from the script provided by Lumerical
- Ported commands from PBS to Slurm 
- Instead of creating a Slurm job for every .fsp file, a single .fsp file is created for use for submission as a Slurm job array
- Transition to submission as a job array allows you to limit the demands on Lumerical engine licences 
- Removed code which used the Lumerical engine to estimate run times as a limit on the total run time

Buglist
181220 - $FLIST is not being passed correctly between the scripts unless the entire list is in quotations. Perhaps ($FLIST) in order to make it a string array?