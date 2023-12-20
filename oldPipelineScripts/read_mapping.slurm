#!/bin/bash
#SBATCH --job-name=butterfly_map
#SBATCH --partition=qcb
#SBATCH --time=336:00:00
#SBATCH --mem=120000
#SBATCH -n 12
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=tferrari@usc.edu

#load modules
module load gcc/11.3.0 intel/19.0.4 bwa/0.7.17 samtools/1.17

#set working directory
cd /scratch2/tferrari/Project-ButterflyAssembly/

mkdir ./bamFiles
mkdir ./bamFiles/bamRaw

#set file directory
FILEDIR=/project/guzmanur_1192/WGS/

#set reference
REFERENCE=/project/jazlynmo_738/DataRepository/Reference_Files/SquintingBushBrown/GCF_947172395.1_ilBicAnyn1.1_genomic.fna.gz
THREADS_BWA=24

for file in $(ls -1 ${FILEDIR}/*R1_001.fastq.gz | sort -r);do

        bn=`basename -s _R1_001.fastq.gz $file`
	
	# copy files to bam directory
	cp ${FILEDIR}/${bn}_R*_001.fastq.gz ./bamFiles/

	# map reads
	bwa mem -t $THREADS_BWA $REFERENCE ./bamFiles/${bn}_R1_001.fastq.gz ./bamFiles/${bn}_R2_001.fastq.gz | samtools view -bS - | samtools sort - > ./bamFiles/bamRaw/${bn}.sorted.bam
	
	# delete copy
	rm ./bamFiles/${bn}_R*_001.fastq.gz
done
