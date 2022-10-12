#!/bin/sh
#SBATCH --job-name=run-gromacs-charmm
#SBATCH --nodes=5
#SBATCH --tasks-per-node=4
#SBATCH --mem=8GB
#SBATCH --time=24:00:00

./README.bash
