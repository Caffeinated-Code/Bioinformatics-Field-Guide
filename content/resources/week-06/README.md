# Week 6 Resources: Build A Custom ONT Nextflow Pipeline

These files support the Week 6 guide on building a custom Nextflow pipeline for Oxford Nanopore long-read data.

The example is intentionally small and scaffold-like. It teaches structure, strategy, and handoff points. For real production use, pin tool versions, test with known data, and review whether an existing community pipeline such as `nf-core/nanoseq` already solves the problem.

## Files

| File | Purpose |
|---|---|
| `main.nf` | Custom DSL2 Nextflow pipeline skeleton for ONT FASTQ to sorted BAM plus QC placeholders |
| `nextflow.config` | Local, Docker, Singularity, and AWS-style profile examples |
| `samplesheet_ont.csv` | Example ONT samplesheet |
| `params.local.yml` | Example parameter file |
| `sgnex_ont_demo_samples.tsv` | One public SG-NEx ONT RNA sample with FASTQ/BAM URLs |
| `run_sgnex_ont_qc_demo.sh` | Streams a small public ONT FASTQ subset for QC practice |
| `modules/local/fastq_qc.nf` | FASTQ QC module using NanoPlot-style output |
| `modules/local/align_minimap2.nf` | Minimap2 long-read alignment module |
| `modules/local/sort_index_bam.nf` | Samtools sorting/indexing module |
| `modules/local/alignment_qc.nf` | Alignment QC module |
| `modules/local/isoform_collapse_placeholder.nf` | Placeholder for a future ONT isoform-collapse step |
| `modules/local/sqanti3_annotation.nf` | SQANTI3 annotation/QC module skeleton for collapsed transcript models |

## Quick Syntax Check

From this folder:

```bash
nextflow run main.nf --help
```

For a real run, you need real FASTQ, reference FASTA, and optional annotation files:

```bash
nextflow run main.nf \
  -profile docker \
  -params-file params.local.yml \
  -resume
```

The pipeline skeleton is designed to teach structure. It may need container tags, memory values, and tool arguments adjusted for your data and compute environment.

## Public ONT QC Demo

This demo streams a small prefix of one public SG-NEx direct-cDNA FASTQ file and writes a local subset for QC practice.

```bash
# From the repository root.
bash content/resources/week-06/run_sgnex_ont_qc_demo.sh 10000
```

The script does not run full isoform discovery. It gives you a small public ONT FASTQ subset for practicing file checks and NanoPlot-style read QC.

## SQANTI3 Handoff

SQANTI3 should be run after you have transcript models from IsoQuant, StringTie2, FLAIR, TALON, or a custom isoform-collapse method.

The included `sqanti3_annotation.nf` module is a skeleton. Before using it:

```text
1. Choose and test a SQANTI3 release.
2. Set sqanti3_container in params.local.yml or nextflow.config.
3. Provide collapsed isoform models, reference annotation, and genome FASTA.
4. Review SQANTI3 classification/QC outputs before reporting novel isoforms.
```
