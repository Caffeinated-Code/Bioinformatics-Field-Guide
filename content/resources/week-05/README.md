# Week 5 Resources: Nextflow Big Picture And nf-core/rnaseq

These files support the Week 5 guide on the high-level view of Nextflow and running nf-core/rnaseq.

| File | Purpose |
|---|---|
| `samplesheet_tiny_demo.csv` | Example samplesheet shape for a paired-end RNA-seq project |
| `run_nfcore_rnaseq_test.sh` | Runs the official nf-core/rnaseq test profile |
| `public_airway_accessions.txt` | Four public SRA runs from the Himes et al. airway RNA-seq dataset |
| `airway_curated_metadata.tsv` | Human-readable metadata for the four-run airway subset |
| `airway_rnaseq_params.yml` | Template params file for processing the airway subset with nf-core/rnaseq |
| `run_public_airway_nfcore.sh` | Helper script for fetchngs followed by nf-core/rnaseq |
| `nextflow_syntax_cheatsheet.md` | Short orientation to channels, processes, workflows, profiles, and operators. Week 6 goes deeper. |
| `output_folder_map.md` | Practical map of common nf-core/rnaseq output folders |

## Quick Start

From the repository root:

```bash
# Check that Nextflow is installed.
nextflow -version

# Make sure Docker Desktop or Colima is running before using the Docker profile.
docker info

# Run the official nf-core/rnaseq test profile with Docker.
bash content/resources/week-05/run_nfcore_rnaseq_test.sh
```

The test profile checks the pipeline machinery. It is not a biological experiment.

## Public Dataset Tutorial

The article also includes a public-data tutorial using a small subset of the Himes et al. airway RNA-seq dataset.

```bash
# Review curated accessions and metadata.
cat content/resources/week-05/public_airway_accessions.txt
column -t content/resources/week-05/airway_curated_metadata.tsv

# Run public FASTQ fetch + nf-core/rnaseq.
# Edit airway_rnaseq_params.yml first so the FASTA/GTF paths match your machine.
bash content/resources/week-05/run_public_airway_nfcore.sh
```

This can download real FASTQ data and run a real pipeline. Check disk space, Docker/Colima, and reference paths before launching.
