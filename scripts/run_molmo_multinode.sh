#!/bin/bash
#SBATCH --job-name=data_test
#SBATCH --account=<account_name>
#SBATCH -o ./logs/%x_%j/%x_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e ./logs/%x_%j/%x_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --nodes=1              # Total number of nodes
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-node=4       # Allocate one gpu per MPI rank
#SBATCH --cpus-per-task=24
#SBATCH --time=2-00:00:00
#SBATCH --mem=0			# All memory on the node
#SBATCH --exclusive
#SBATCH --partition=kempner_h100

# module load cuda/11.8.0-fasrc01 cudnn gcc/10.2.0-fasrc01
module load python/3.10.13-fasrc01 cuda/12.2.0-fasrc01 cudnn gcc
eval "$(conda shell.bash hook)"
conda deactivate
conda activate molmo_env
nvidia-smi
echo $CONDA_PREFIX

export PYTHONPATH=.:${PYTHONPATH}

export MOLMO_DATA_DIR=/n/holylfs06/LABS/kempner_shared/Lab/data/molmo

save_dir=./outputs/${SLURM_JOB_NAME}_${SLURM_JOB_ID}/

torchrun --nproc-per-node=4 launch_scripts/train_captioner.py qwen2_7b --wandb=null --save_folder=$save_dir