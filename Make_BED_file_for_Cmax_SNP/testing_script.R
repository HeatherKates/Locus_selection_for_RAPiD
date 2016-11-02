library(pbapply)
library(readr)
setwd("C:/Users/hkates/Downloads/RAPiD_locus_selection")

#### Read in Data
# read csv file with SNP position info.
SNP_position_file <- read.csv("SNP_file_real.csv")
#format of file
# GeneID,Scaffold_from_pos,SNP_POSITION

# read csv genome file with scaffold names and sequences
All_Scaffolds_file <- read_csv("Cmax_scaffolds_formatted_for_R.fa",col_types="cc")
#format of all_scaffolds_file
#Scaffold_from_fasta,SEQUENCE

#### Define functions doit() and getflanking() (called in doit())
# The doit() function is applied over each scaffold name (y=Cmax_scf00001-Cmax_scf008300) in the genome file 
# (scaffold names,sequences).  
# For each scaffold name, 1)getflanking(): All the SNP positions(x) listed for that scaffold in the 
# SNP Positions file are used, +/- 250, to subtr the sequence of the scaffold from the fasta file. 
# 2) The returns of getflanking()are stored as a value (list) 
# "flanking_seq" and 
# 3) then the corresponding GeneID is extracted from SNP Position file and 4) pasted to the flanking seq, 
# separated by a space

doit <- function(y)
{
getflanking <- function(x)
{
substr((subset(All_Scaffolds_file,Scaffold_from_fasta==y)$SEQUENCE),x-250,x+250)
}

flanking_seq <- lapply(subset(SNP_position_file,Scaffold_from_pos==y)$SNP_POSITION, getflanking)
GeneID <- (subset(SNP_position_file,Scaffold_from_pos==y))$GeneID
#testing
ScafID <- (subset(SNP_position_file,Scaffold_from_pos==y))$Scaffold_from_pos
#testing
results <- paste(ScafID,GeneID,flanking_seq,sep=" ")
}

#### Run doit() and process the output
# Create a list of all the scaffold names in the SNP_positions_file
scaffold_names <- SNP_position_file[,'Scaffold_from_pos']
short_scaffold_names <- levels(scaffold_names)

# Runs doit() for all the scaffold names in the SNP_position_file
geneID_and_SNP_with_flanking <- pblapply(short_scaffold_names,doit)

# Print output from doit() (list) to a file =""
# at the moment this is not correctly formatted for BLAST, to format run:
#sed -i.bak 's/(Cma_Scf\d+)\s(S\d+_\d+)\s(\w+),*/>\1_\2\t\3\n/g' file
cat(sapply(geneID_and_SNP_with_flanking,toString),file="flanking_seqs_with_scafID.txt",sep="\n")


