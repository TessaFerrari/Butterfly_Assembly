#!/bin/bash
#SBATCH --job-name=butterfly_merge
#SBATCH --partition=qcb
#SBATCH --time=48:00:00
#SBATCH --mem=120000
#SBATCH -n 12
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=tferrari@usc.edu

#load modules
module load gcc/11.3.0 intel/19.0.4 bwa/0.7.17 samtools/1.17

#set wd
cd /scratch2/tferrari/Project-ButterflyAssembly/bamFiles/bamRaw

#mkdir ../bamMerged

for file in $(ls -1 *_L003.sorted.bam | sort -r);do

        bn=`basename -s _L003.sorted.bam $file`
	samtools merge ../bamMerged/${bn}.sorted.merge.bam ${bn}_L003.sorted.bam ${bn}_L004.sorted.bam

done
