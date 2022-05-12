# Modify to taste

# Load Modules
module purge
module load amber/20-cluster

module unload python

# load ld library path
export LD_LIBRARY_PATH=/net/pulsar/home/koes/dkoes/build/amber20/lib:$LD_LIBRARY_PATH

# This is our local scratch, where we'll store files during the dynamics.
export NODELOC=$LOCAL
export USE_LOCAL_SCRATCH=1

# Inform WEST where to find Python and our other scripts where to find WEST
export WEST_PYTHON=$(which python3.9)
if [[ -z "$WEST_ROOT" ]]; then
    echo "Must set environ variable WEST_ROOT"
    exit
fi

# Explicitly name our simulation root directory
if [[ -z "$WEST_SIM_ROOT" ]]; then
    # The way we're calling this, it's $SLURM_SUBMIT_DIR, which is fine.
    export WEST_SIM_ROOT="$PWD"
fi

# Set simulation name
export SIM_NAME=$(basename $WEST_SIM_ROOT)
echo "simulation $SIM_NAME root is $WEST_SIM_ROOT"

# Export environment variables for pmemd and cpptraj (too lazy to type the path each time)
export PMEMD=$AMBERHOME/bin/pmemd.cuda
export CPPTRAJ=$AMBERHOME/bin/cpptraj
