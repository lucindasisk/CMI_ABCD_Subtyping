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


R -e "rmarkdown::render('/gpfs/milgram/project/gee_dylan/lms233/CMI_ABCD/CMI_ABCD_Subtyping/CMI_ABCD_JIVE_Cluster.Rmd',
output_file='$1')"
