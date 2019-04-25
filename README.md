# fdtd-slurm-batch
These bash scripts help automate Lumerical FDTD file submission to a cluster running the Slurm job scheduler.

Run setup.sh to add this folder to .bashrc.

## Usage
`fdtd-run-slurm-array.sh [-n number of threads per simulation] fsp_file_1 [fsp_file_2 ... fsp_file_N]`


## User settings
Change the values in user_settings.ini to modify the behavior of the script. 

- `NUM_ENGINES` The number of simulations to run simultaneously (equal to the number of FDTD engine licenses required).
- `JOB_NAME` Slurm job name
- `TIME_LIMIT` Total time allowed per simulation in HH:MM:SS
- `MEMORY_PER_CPU` Amount of memory per CPU/thread required
- `EMAIL` Your email address, should you want emails from Slurm
- `MAIL_TYPE` The type of emails you want Slurm to send you. [Refer to the Slurm documentation for details](https://slurm.schedmd.com/sbatch.html#OPT_mail-type).
- `MPI_PATH` Path to the Lumerical supplied MPI binary*
- `LUM_PATH` Path to the Lumerical FDTD binary*
- `PARTITION` Slurm partition*
- `ACCOUNT` Slurm account*

\* If you are running FDTD simulations on the cluster at the Molecular Foundry, you will not need to change these values.


## Changes from the script provided by Lumerical
- Ported commands from PBS to Slurm
- Instead of creating a Slurm job for every .fsp file, a single .fsp file is created for use for submission as a Slurm job array
- Transition to submission as a job array allows you to limit the demands on Lumerical engine licences
- Removed code which used the Lumerical engine to estimate run times as a limit on the total run time
- Uses user_settings.ini as a way to load important user and server settings
