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
| `modules/local/fastq_qc.nf` | FASTQ QC module using NanoPlot-style output |
| `modules/local/align_minimap2.nf` | Minimap2 long-read alignment module |
| `modules/local/sort_index_bam.nf` | Samtools sorting/indexing module |
| `modules/local/alignment_qc.nf` | Alignment QC module |
| `modules/local/isoform_collapse_placeholder.nf` | Placeholder for a future ONT isoform-collapse step |

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
