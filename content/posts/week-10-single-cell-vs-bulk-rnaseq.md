---
title: "Single-Cell RNA-seq vs Bulk RNA-seq"
subtitle: "What changes when every cell becomes a data point"
week: 10
audience: ["beginner", "practitioner", "researcher"]
reading_time: "7 minutes"
asset: "Bulk vs single-cell comparison map"
---

# Single-Cell RNA-seq vs Bulk RNA-seq

**Takeaway:** Bulk RNA-seq summarizes expression across many cells, while single-cell RNA-seq measures many individual cells and shifts the question from "what changed overall?" to "which cells changed?"

## Prerequisites

Read Week 7 for RNA-seq and Week 9 for PCA.

## The Simple Difference

Bulk RNA-seq blends many cells together. Single-cell RNA-seq tries to measure individual cells separately.

| Question | Bulk RNA-seq | Single-cell RNA-seq |
|---|---|---|
| What is the unit? | Sample | Cell |
| Main output | Gene by sample matrix | Gene by cell matrix |
| Strength | Robust condition-level expression | Cell-type and cell-state resolution |
| Challenge | Mixed cell populations | Sparsity, noise, annotation, scale |

## Why Single-Cell Changed the Field

Single-cell RNA-seq helps reveal:
- rare cell types
- cell states
- immune populations
- tumor heterogeneity
- developmental trajectories
- treatment response within subpopulations

It is powerful because biology often happens in specific cells, not averaged tissue.

## The Single-Cell Workflow

```text
cells -> barcoded sequencing -> count matrix -> QC -> normalization -> dimensionality reduction -> clustering -> annotation -> biological interpretation
```

Each step contains choices that can change the result.

## The Hard Part: Annotation

Clusters do not name themselves. Analysts often use marker genes, references, labels from tools, or expert knowledge to annotate cell types.

Ask:
- Are marker genes specific?
- Is the reference appropriate?
- Could the cluster be a state, not a type?
- Does annotation match tissue biology?
- Are doublets or low-quality cells driving the cluster?

## Pseudobulk: A Useful Bridge

For differential expression, many experts prefer pseudobulk approaches: aggregate counts by sample and cell type, then use bulk RNA-seq statistical tools. This helps preserve biological replication.

Single cells are not automatically independent biological replicates.

## Common Mistakes

- Treating every cell as an independent replicate.
- Overtrusting automated annotations.
- Ignoring doublets and low-quality cells.
- Choosing clustering resolution without biological reasoning.
- Treating UMAP distance as exact biology.
- Comparing cell types without enough samples.

## What Experts Still Debate

Experts debate normalization, integration, batch correction, clustering resolution, annotation standards, differential expression methods, and how to validate cell states.

## Research Gap

Single-cell analysis needs better benchmark tasks that test biological conclusions, not just clustering metrics. A method can make attractive plots and still fail at the biological question.

## Original Asset

Create a bulk vs single-cell comparison map:
- data unit
- matrix shape
- workflow steps
- statistical risks
- best use cases
- common overclaims

## Credits and References

- Seurat documentation: https://satijalab.org/seurat/
- Seurat PBMC tutorial: https://satijalab.org/seurat/articles/pbmc3k_tutorial
- Scanpy documentation: https://scanpy.readthedocs.io/
- Single Cell Expression Atlas: https://www.ebi.ac.uk/gxa/sc/home
- 10x Genomics resources: https://www.10xgenomics.com/resources

## Expert Review Checklist

- Add a diagram showing bulk averaging vs single-cell resolution.
- Add references for pseudobulk best practices before publication.
- Check latest Seurat and Scanpy recommendations.
