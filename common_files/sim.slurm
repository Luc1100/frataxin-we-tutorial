#!/bin/bash

#SBATCH --job THE_JOB_NAME
#SBATCH --nodes=1
#SBATCH --partition=dept_gpu
#SBATCH --gres=gpu:1

echo Running on `hostname`
echo workdir $SLURM_SUBMIT_DIR
export LD_LIBRARY_PATH=/net/pulsar/home/koes/dkoes/build/amber20/lib:$LD_LIBRARY_PATH
echo ld_library_path $LD_LIBRARY_PATH

cd $SLURM_SUBMIT_DIR

#scratch drive folder to work in
SCRDIR=/scr/${SLURM_JOB_ID}

module load amber/20-cluster

#if the scratch drive doesn't exist (it shouldn't) make it.
if [[ ! -e $SCRDIR ]]; then
        mkdir $SCRDIR
fi

chmod +rX $SCRDIR

echo scratch drive ${SCRDIR}

# copy simulation files to scrataion directory
cp $SLURM_SUBMIT_DIR/md.in ${SCRDIR}
cp $SLURM_SUBMIT_DIR/complexwfe.prmtop ${SCRDIR}
cp $SLURM_SUBMIT_DIR/parent.rst ${SCRDIR} # created by WESTPA
cd ${SCRDIR}

#setup to copy files back to working dir on exit
trap "mv seg.nc seg.rst $SLURM_SUBMIT_DIR" EXIT

#run the MD
pmemd.cuda -O -i md.in -o $SLURM_SUBMIT_DIR/seg.out -p complexwfe.prmtop -c parent.rst -r seg.rst -x seg.nc -inf $SLURM_SUBMIT_DIR/seg.nfo 
