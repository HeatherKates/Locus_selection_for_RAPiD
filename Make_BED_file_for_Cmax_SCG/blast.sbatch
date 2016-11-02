#!/bin/bash
#SBATCH --job-name=Cmax_blast_2
#SBATCH --output=Cmax_blast_2.out
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00

module load ncbi_blast

blastn -db Cmax_genome_db -query C_max_SCGenes.fasta -outfmt 10 -out C_max_SCG_blast_report -evalue .0001 


