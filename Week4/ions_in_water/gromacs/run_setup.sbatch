#!/bin/sh
#SBATCH --job-name=ions-in-water
#SBATCH --nodes=5
#SBATCH --tasks-per-node=20
#SBATCH --mem=8GB
#SBATCH --time=6:00:00


module purge
module load gromacs/openmpi/intel/2020.4
./README.bash
