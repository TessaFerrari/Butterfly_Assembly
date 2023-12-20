FILEDIR="/project/guzmanur_1192/WGS"

configfile: "config.yaml"

rule all:
	input:
		expand("bamFiles/bamReadGroups/{bn2}.sorted.merge.md.rg.bam.bai", bn2=config["output"]) # 96 files


rule copy_fastq:
	input: 
		FILEDIR + "/{bn}_R1_001.fastq.gz",
		FILEDIR + "/{bn}_R2_001.fastq.gz"
	output:
		temp("bamFiles/tempFastq/{bn}_R1_001.fastq.gz"),
		temp("bamFiles/tempFastq/{bn}_R2_001.fastq.gz")
	shell:
		"cp " + FILEDIR + "/{wildcards.bn}_R*_001.fastq.gz ./bamFiles/tempFastq/"


rule read_mapping:
	input:
		reference = "/project/jazlynmo_738/DataRepository/Reference_Files/Hypolimnas/GCA_008963455.1_UofC_Hmis_v1.0_genomic.fna.gz",
		R1 = "bamFiles/tempFastq/{bn}_R1_001.fastq.gz",
		R2 = "bamFiles/tempFastq/{bn}_R2_001.fastq.gz"
	output:
		"bamFiles/bamRaw/{bn}.sorted.bam"
	threads: 24
	shell:
		"""
		module load gcc/11.3.0 intel/19.0.4 bwa/0.7.17 samtools/1.17
		bwa mem -t {threads} {input.reference} {input.R1} {input.R2} | samtools view -bS - | samtools sort - > {output}
		"""


rule merge:
	input:
		"bamFiles/bamRaw/{bn2}_L003.sorted.bam",
		"bamFiles/bamRaw/{bn2}_L004.sorted.bam"
	output:
		"bamFiles/bamMerged/{bn2}.sorted.merge.bam"
	shell:
		"""
		module load gcc/11.3.0 intel/19.0.4 bwa/0.7.17 samtools/1.17
		samtools merge {output} {input}
		"""


rule mark_duplicates:
	input:
		"bamFiles/bamMerged/{bn2}.sorted.merge.bam"
	output:
		out = "bamFiles/bamMarkDups/{bn2}.sorted.merge.md.bam",
		metrics = "bamFiles/bamMarkDups/{bn2}.metrics.md.txt"
	shell:
		"""
		module load gcc/11.3.0 picard/2.26.2 intel/19.0.4 samtools/1.17
		picard MarkDuplicates I={input} O={output.out} M={output.metrics}
		"""


rule read_groups:
	input:
		"bamFiles/bamMarkDups/{bn2}.sorted.merge.md.bam"
	output:
		"bamFiles/bamReadGroups/{bn2}.sorted.merge.md.rg.bam"
	shell:
		"""
		module load gcc/11.3.0 picard/2.26.2 intel/19.0.4 samtools/1.17
		picard AddOrReplaceReadGroups I={input} O={output} SORT_ORDER=coordinate RGID={wildcards.bn2} RGLB={wildcards.bn2} RGPL=illumina RGSM={wildcards.bn2} RGPU={wildcards.bn2} CREATE_INDEX=True
		"""


rule index:
	input:
		"bamFiles/bamReadGroups/{bn2}.sorted.merge.md.rg.bam"
	output:
		"bamFiles/bamReadGroups/{bn2}.sorted.merge.md.rg.bam.bai"
	shell:
		"""
		module load gcc/11.3.0 intel/19.0.4 samtools/1.17
		samtools index {input}
		"""


