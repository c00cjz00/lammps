#!/bin/bash
#SBATCH --job-name=Hello_lammps   ## job name
#SBATCH --nodes=2                 ## 索取 2 節點
#SBATCH --ntasks-per-node=8       ## 每個節點跑 8 個 srun tasks
#SBATCH --cpus-per-task=4         ## 每個 srun task 用 4 CPUs
#SBATCH --gres=gpu:8              ## 每個節點索取 8 GPUs
#SBATCH --time=00:10:00           ## 最長跑 10 分鐘 (測試完這邊記得改掉，或是測試完直接刪除該行)
#SBATCH --account=xxxx       ## iService_ID 請填入計畫ID(ex: MST108XXX)，扣款也會根據此計畫ID
#SBATCH --partition=gtest         ## gtest 為測試用 queue，後續測試完可改 gp1d(最長跑1天)、gp2d(最長跑2天)、p4d(最長跑4天)

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
