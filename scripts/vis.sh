#!/bin/bash
#SBATCH --job-name=data_test
#SBATCH --account=kempner_sham_lab
#SBATCH -o ./logs/%x_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e ./logs/%x_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --nodes=1              # Total number of nodes
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=1       # Allocate one gpu per MPI rank
#SBATCH --cpus-per-task=32
#SBATCH --time=0-00:30:00
#SBATCH --mem=128G			# All memory on the node
#SBATCH --partition=kempner_h100

# module load cuda/11.8.0-fasrc01 cudnn gcc/10.2.0-fasrc01
module load cuda/12.2.0-fasrc01 cudnn gcc
eval "$(conda shell.bash hook)"
conda activate molmo_env
nvidia-smi
echo $CONDA_PREFIX

export MOLMO_DATA_DIR=/n/holylfs06/LABS/kempner_shared/Lab/data/molmo



python scripts/dataset_visualize.py okvqa /n/holylabs/LABS/sham_lab/Users/mkwun/viz
