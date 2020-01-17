#! /bin/bash

#SBATCH --job-name=CMI_ABCD_JIVE_analysis
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH --time=36:00:00
#SBATCH --partition=verylong
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lucinda.sisk@yale.edu

date=$(date +%m.%d.%Y)

R CMI_ABCD_JIVE_test.Rmd
