Run with snakemake on slurm using:

	$ conda activate snakemake
	$ nohup snakemake --slurm --default-resources slurm_account=jazlynmo_738 slurm_partition=qcb mem_mb=75000 runtime=10080 tasks=34 --configfile config.yaml --jobs 1 >> ./Log/butterfly_snakemake_log.txt 2>&1 &

Use flag '-np' to do dry-run and print all rules to be executed
Use flag '-R copy_fastq' to force-run all rules to regenerate all files
