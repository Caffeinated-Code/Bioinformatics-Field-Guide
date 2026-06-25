---
title: "RNA-seq in 7 Minutes"
subtitle: "From reads to differential expression"
week: 7
audience: ["beginner", "practitioner", "researcher"]
reading_time: "7 minutes"
asset: "RNA-seq workflow map"
---

# RNA-seq in 7 Minutes

**Takeaway:** RNA-seq turns RNA fragments into a count matrix, then uses statistics to ask which genes differ across biological conditions.

## Prerequisites

Read Week 3 for RNA basics, Week 5 for file types, and Week 6 for project structure.

## What RNA-seq Measures

RNA-seq measures RNA abundance. It does not directly measure protein abundance, enzyme activity, or mechanism. It is powerful because it gives a broad view of transcription across thousands of genes.

## The Workflow

```text
samples -> RNA extraction -> sequencing -> FASTQ -> QC -> alignment or quantification -> count matrix -> statistics -> interpretation
```

Each step can introduce bias, so each step needs quality control.

## Step 1: Experimental Design

Before sequencing, decide:
- What condition is being compared?
- How many biological replicates are needed?
- What batches might exist?
- What covariates should be recorded?
- What tissue, cell type, or time point is relevant?

Analysis cannot rescue a weak design.

## Step 2: FASTQ Quality Control

FASTQ files should be checked for:
- base quality
- adapter contamination
- duplication
- overrepresented sequences
- read length

Tools such as FastQC and MultiQC are commonly used to summarize quality.

## Step 3: Alignment or Quantification

There are two common paths:

| Path | Example tools | Output |
|---|---|---|
| Align reads to genome | STAR, HISAT2 | BAM files |
| Quantify transcripts directly | Salmon, kallisto | transcript abundance |

Both paths can lead to gene-level analysis, but assumptions differ.

## Step 4: Count Matrix

Most differential expression workflows use a matrix of counts per gene per sample. Counts must be paired with metadata. Without metadata, the model does not know which samples are control, treated, batch A, or batch B.

## Step 5: Differential Expression

Tools such as DESeq2, edgeR, and limma-voom model count data and test whether genes differ between conditions.

The output usually includes:
- gene ID
- log fold change
- p-value
- adjusted p-value
- base expression

The adjusted p-value matters because thousands of genes are tested.

## Step 6: Interpretation

Differential expression is not the endpoint. Ask:
- Are the top genes biologically plausible?
- Is the effect size meaningful?
- Are results driven by one sample?
- Do pathway results match the gene-level result?
- Is validation needed?

## Common Mistakes

- Comparing technical replicates as if they were biological replicates.
- Ignoring batch effects.
- Filtering genes after looking at results.
- Reporting only p-values without effect sizes.
- Treating RNA change as proof of mechanism.
- Forgetting gene annotation version.

## What Experts Still Debate

Experts still debate transcript-level vs gene-level analysis, alignment vs quasi-mapping, best normalization strategies for unusual designs, and how to integrate RNA-seq with proteomics or single-cell data.

## Research Gap

A useful public benchmark would compare beginner-friendly RNA-seq workflows on the same dataset, scoring them by correctness, transparency, runtime, memory use, and interpretability.

## Original Asset

Create a one-page RNA-seq workflow map:
- input files
- tools
- outputs
- QC checkpoints
- common failure modes
- interpretation questions

## Credits and References

- Bioconductor RNA-seq workflow: https://www.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html
- DESeq2 paper: https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8
- FastQC: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
- MultiQC: https://multiqc.info/
- Salmon: https://combine-lab.github.io/salmon/

## Expert Review Checklist

- Add a real example dataset.
- Verify all tool recommendations.
- Add one figure explaining count matrices and metadata.
