# Week 5 Resources: Nextflow And nf-core/rnaseq

These files support the Week 5 guide on Nextflow and nf-core/rnaseq.

| File | Purpose |
|---|---|
| `samplesheet_tiny_demo.csv` | Example samplesheet shape for a paired-end RNA-seq project |
| `run_nfcore_rnaseq_test.sh` | Runs the official nf-core/rnaseq test profile |
| `nextflow_syntax_cheatsheet.md` | Short guide to channels, processes, workflows, profiles, and operators |
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
