# WESTPA Tutorial: SDAUF Loop Sampling
This tutorial is meant to give a general overview of running WE simulations with WESTPA. The files in this tutorial are based on (or directly copied from) the [LiveComs journal article](https://doi.org/10.33011/livecoms.1.2.10607) on best practices for Weighted Ensemble simulations, which I highly recommend looking over. The documentation for the WESTPA commands can also be found [here](https://westpa.readthedocs.io/en/latest/sphinx_index.html#)

The "Running WE Simulations" section is useful if you just want to jump in and run a WESTPA simulation. The "WE main directory" gives an overview on each file in this directory. Each subdirectory also contains a readme file with a high level overview of the files in it. I have also attempted to document files that are not super clear.

## Running WE Simulations
### Install WESTPA on the cluster
```
module load anaconda
conda create -n westpa-2020.05 -c conda-forge westpa
```
### Run WESTPA
```
module load anaconda
conda activate westpa-2020.05
./init.sh
sbatch runwe.slurm
```
### Stop WESTPA
If WESTPA reaches the user speicified number of iterations, the simulations will stop. However, you may wany to stop the simulations early in order to view how the simulations are progressing, or the desired state has been reached.

To manually stop WESTPA, cancel the slurm task associated with the `runwe.slurm` file. You may also need to cancel any lingering simulations. A quick way to cancel many jobs at once is:
```
scancel {start_id..end_id}
```

If you just wanted to check the progress of the simulation and would like to restart where the simulation left off, simply resubmit `runwe.slurm`. **DO NOT rerun `init.sh` or the entire simulation will be erased and need to start from the beginning**
### Simple analysis
Once the simulation has stopped, you can visualize how it is progressing from bin to bin by running:
```
w_pdist
plothist evolution pdist.h5
```
To visualize the PMF along the progress coordinate:
```
w_pdist
plothist average pdist.h5
```



## WE main directory
| File | Purpose |
| --- | --- |
| `env.sh` | Load environment variables specific to our cluster |
| `init.sh` | Initialize the WESTPA simulation (delete old files, create new subdirectories) |
| `runwe.slurm` | Run the WESTPA simulation | 
| `west.cfg` | Specify the main WE parameters (there are bits in this file that even I don't know what they do, and should probably not be touched)|
