# Week 4 Resources: Bulk RNA-seq And Differential Expression

These files support Week 4: "Bulk RNA-seq: From FASTQ To Differential Expression Without Fooling Yourself."

## Files

| File | Purpose |
|---|---|
| `nfcore_samplesheet.csv` | Minimal nf-core/rnaseq-style samplesheet example |
| `metadata_design_examples.tsv` | Toy metadata for simple, batch-adjusted, paired, and interaction designs |
| `deseq2_design_cheatsheet.md` | Saveable DESeq2 design formula reference |
| `deseq2_design_matrix_demo.R` | Runnable R script showing what common design formulas create |

## Quick Start

```bash
cd content/resources/week-04
Rscript deseq2_design_matrix_demo.R
```

This script does not require DESeq2. It uses base R model matrices so you can inspect design formulas before running a differential expression analysis.

## Key Lesson

The RNA-seq processing steps are broadly similar across many count-based assays:

```text
raw reads -> QC -> trimming/filtering -> alignment or quantification -> feature counts -> metadata-aware statistical model
```

The statistics are not interchangeable. The model must match the experimental design.
