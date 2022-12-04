#!/bin/bash
#SBATCH --job-name=water-aimd-cp2k
#SBATCH --nodes=1
#SBATCH --tasks-per-node=12
#SBATCH --mem=80GB
#SBATCH --time=24:00:00
#SBATCH --reservation=gmh4
module load cp2k/openmpi/intel/20201212
mpirun -np 12 cp2k.popt -i water.inp -o OUTPUT_FILE_NAME.log
