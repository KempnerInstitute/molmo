#!/bin/bash
#SBATCH --job-name=data_test
#SBATCH --account=<account_name>
#SBATCH -o ./logs/%x_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e ./logs/%x_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --nodes=1              # Total number of nodes
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=1       # Allocate one gpu per MPI rank
#SBATCH --cpus-per-task=32
#SBATCH --time=2-00:00:00
#SBATCH --mem=128G			# All memory on the node
#SBATCH --partition=kempner_h100

# module load cuda/11.8.0-fasrc01 cudnn gcc/10.2.0-fasrc01
module load cuda/12.2.0-fasrc01 cudnn gcc
eval "$(conda shell.bash hook)"
conda activate molmo_env
nvidia-smi
echo $CONDA_PREFIX

export PYTHONPATH=.:${PYTHONPATH}

export MOLMO_DATA_DIR=/n/holylfs06/LABS/kempner_shared/Lab/data/molmo


python3 scripts/download_data.py PixMoCap --n_proc 12

# to download pre-trained models
#python3 scripts/convert_hf_to_molmo.py qwen2_7b
#python3 scripts/convert_hf_to_molmo.py openai
