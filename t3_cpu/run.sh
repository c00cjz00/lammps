#!/bin/bash

module purge
###module load intel/19.1.3.304
module load compiler/intel/2021 IntelMPI/2021 hdf5/1.12 netcdf/4.7.4 adios2/2.7.1

### force to adopt OFA
export I_MPI_FABRICS=shm:ofi
export UCX_TLS=rc,ud,sm,self
### set processor management library
export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi2.so
### set debug level, 0:no debug info
export I_MPI_DEBUG=10
###
export I_MPI_HYDRA_BOOTSTRAP=slurm
### set cpu binding
export I_MPI_PIN=1

###export EXE=/opt/ohpc/pkg/lammps/patch_24Dec2020-106-g102a6eb/lmp_intel_cpu_intelmpi
export EXE=/opt/ohpc/pkg/lammps/patch_10Mar2021-137-g73b9f22/lmp_intel_cpu_intelmpi


# When running a large number of tasks simultaneously, it may be
# necessary to increase the user process limit.
ulimit -u 10000

echo "Running on hosts: $SLURM_NODELIST"
echo "Running on $SLURM_NNODES nodes."
echo "Running $SLURM_NTASKS tasks."

echo "Your LAMMPS job starts at `date`"
mpiexec.hydra $EXE -in in.eam
echo "Your LAMMPS job completed at  `date` "
