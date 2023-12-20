#!/bin/bash
#SBATCH --job-name=butterfly_dupsNgroups_EZ
#SBATCH --partition=qcb
#SBATCH --time=48:00:00
#SBATCH --mem=120000
#SBATCH -n 12
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=tferrari@usc.edu

#load modules
module load gcc/11.3.0 picard/2.26.2 intel/19.0.4 samtools/1.17

#set wd
cd /scratch2/tferrari/Project-ButterflyAssembly/bamFiles/bamMerged

mkdir ../bamMarkDups
mkdir ../bamReadGroups

for file in [E-Z]*.sorted.merge.bam;do
	bn=`basename -s .sorted.merge.bam $file`

	# Mark Duplicates
	picard MarkDuplicates I=${file} O=../bamMarkDups/${bn}.sorted.merge.md.bam M=../bamMarkDups/${bn}.metrics.md.txt

	# Read Groups
	picard AddOrReplaceReadGroups I=../bamMarkDups/${bn}.sorted.merge.md.bam O=../bamReadGroups/${bn}.sorted.merge.md.rg.bam SORT_ORDER=coordinate RGID=${bn} RGLB=${bn} RGPL=illumina RGSM=${bn} RGPU=${bn} CREATE_INDEX=True
	
	# Index file
	samtools index ../bamReadGroups/${bn}.sorted.merge.md.rg.bam 
done
