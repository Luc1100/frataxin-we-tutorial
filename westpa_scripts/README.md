# westpa_scripts
This directory contains files that are associated with actually running the WESTPA simulation

| File | Purpose |
| --- | --- |
| `gen_istate.sh` | links the basis state to the istate which I believe is used in steady state simulations |
| `get_pccord.sh` | calculates the progress coordinate for the basis state to determine starting bin |
| `node.sh` | this may not be necessary (may have been for ZMQ) |
| `post_iter.sh` | tars iteration logs and creats backup of the .h5 file every 100 iterations |
| `runseg.sh` | runs the actual MD simulations (through slurm job submission) and calculates and returns the progress coordinate(s) at the end of each simulation. Also cleans up some files. |
| `tar_segs.sh`| tars the segments |
