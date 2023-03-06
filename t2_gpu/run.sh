#!/bin/bash

# this script modify from
# https://gitlab.com/NVHPC/ngc-examples/-/blob/master/lammps/24Oct2018/multi-node/slurm/srun.slurm

# Load required modules
module load singularity

# singularity alias
SIF=/work/TWCC_cntr/gnu-openmpi-cuda-lammps-kmo.sif
SINGULARITY="singularity run --nv $SIF"

# lmp alias, assumes 1 slurm process per GPU
GPU_COUNT=$(( SLURM_NTASKS / SLURM_JOB_NUM_NODES  ))
# in.lj.txt from 'wget -c https://lammps.sandia.gov/inputs/in.lj.txt'
# ref : https://lammps.sandia.gov/doc/Speed_kokkos.html
LMP="lmp -k on g ${GPU_COUNT} -sf kk -in in.eam"

# Launch parallel lmp
srun --mpi=pmi2 ${SINGULARITY} ${LMP}
