Run with snakemake on slurm using:

	$ conda activate snakemake
	$ nohup snakemake --slurm --default-resources slurm_account=jazlynmo_738 slurm_partition=qcb mem_mb=75000 runtime=10080 tasks=[threads] --config output=[optional params] --jobs 1 -R all >> ./Log/butterfly_snakemake_log.txt 2>&1 &

	$ nohup snakemake --slurm --default-resources slurm_account=jazlynmo_738 slurm_partition=qcb mem_mb=75000 runtime=10080 tasks=34 --configfile configAD.yaml --jobs 1 -R all >> ./Log/butterflyAD_snakemake_log.txt 2>&1 &


6Gigs for read mapping
40Gigs for dups and groups
