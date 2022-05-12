#!/bin/bash
#SBATCH --job-name=WESTPA-runner
#SBATCH --output=slurm.out
#SBATCH -p dept_cpu
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
 
module purge
module load amber/20-cluster
module unload python
export WEST_PYTHON=($which python3.8)
source env.sh

rm -f west.log
# n-workers is the number of simulations that will be running at a given time, change this number based on current cluster usage
$WEST_ROOT/bin/w_run --work-manager processes --n-workers 32 "$@" &> west.log

