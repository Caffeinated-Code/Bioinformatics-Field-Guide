# Nextflow Syntax Cheat Sheet For RNA-seq Readers

Use this while reading the Week 5 article.

## The Mental Model

```text
channel = stream of inputs or outputs
process = one computational step
workflow = how processes are connected
module = reusable process
subworkflow = reusable group of processes
profile = execution environment settings
params = user-facing pipeline options
```

## Minimal Process Shape

```nextflow
process FASTQC {
  input:
  tuple val(meta), path(reads)

  output:
  tuple val(meta), path("*_fastqc.html")

  script:
  """
  fastqc ${reads}
  """
}
```

## Common Channel Operators

| Operator | Plain-language meaning |
|---|---|
| `.map { }` | transform each item |
| `.filter { }` | keep only matching items |
| `.mix()` | combine streams without matching keys |
| `.join()` | combine streams by matching keys |
| `.branch { }` | split one stream into named streams |
| `.collect()` | gather many items into one list-like value |
| `.set { }` | give a channel a name |

## Useful Run Flags

| Flag | Meaning |
|---|---|
| `-profile docker` | run tasks in Docker containers |
| `-profile singularity` | run tasks in Singularity/Apptainer, common on HPC |
| `-profile test,docker` | run the built-in test dataset with Docker |
| `-resume` | reuse cached successful tasks |
| `-params-file params.yml` | pass pipeline parameters through YAML |
| `-c custom.config` | add execution/configuration settings |

## RNA-seq Handoff Rule

```text
nf-core/rnaseq makes QC reports and count/abundance outputs.
DESeq2-style statistical testing happens downstream.
```
