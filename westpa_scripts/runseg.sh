#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF
cd $WEST_CURRENT_SEG_DATA_REF

ln -sv $WEST_SIM_ROOT/common_files/complexwfe.prmtop .
ln -sv $WEST_SIM_ROOT/common_files/md.in .

if [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_CONTINUES" ]; then
  #sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF/seg.rst ./parent.rst
elif [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_NEWTRAJ" ]; then
  #sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF ./parent.rst
fi

#export CUDA_DEVICES=(`echo $CUDA_VISIBLE_DEVICES_ALLOCATED | tr , ' '`)
#export CUDA_VISIBLE_DEVICES=${CUDA_DEVICES[$WM_PROCESS_INDEX]}

#export CUDA_VISIBLE_DEVICES=$WM_PROCESS_INDEX

#echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES_ALLOCATED = " $CUDA_VISIBLE_DEVICES_ALLOCATED
#echo "RUNSEG.SH: WM_PROCESS_INDEX = " $WM_PROCESS_INDEX
#echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES = " $CUDA_VISIBLE_DEVICES

#$PMEMD -O -i md.in   -p complexwfe.prmtop  -c parent.rst \
#          -r seg.rst -x seg.nc      -o seg.log    -inf seg.nfo

sed "s/THE_JOB_NAME/westpa-$WM_PROCESS_INDEX/g" $WEST_SIM_ROOT/common_files/sim.slurm > sim_$WM_PROCESS_INDEX.slurm 
# cp $WEST_SIM_ROOT/common_files/md.in .

sbatch --wait -C "1080Ti|1080" sim_$WM_PROCESS_INDEX.slurm

TEMP=$(mktemp)
COMMAND="         parm complexwfe.prmtop\n"
COMMAND="$COMMAND trajin $WEST_CURRENT_SEG_DATA_REF/parent.rst\n"
COMMAND="$COMMAND trajin $WEST_CURRENT_SEG_DATA_REF/seg.nc\n"
COMMAND="$COMMAND autoimage\n"
COMMAND="$COMMAND distance sulf-to-plp @3177 @5082 out $TEMP\n"
COMMAND="$COMMAND go\n"

echo -e $COMMAND | $CPPTRAJ
cat $TEMP | tail -n +2 | awk '{print $2}' > $WEST_PCOORD_RETURN

# Clean up
rm -f $TEMP md.in seg.nfo seg.pdb sim_$WM_PROCESS_INDEX.slurm
