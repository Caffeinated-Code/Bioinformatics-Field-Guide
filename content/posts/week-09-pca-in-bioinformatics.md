---
title: "PCA in Bioinformatics"
subtitle: "Why everyone uses it and how people misread it"
week: 9
status: "draft"
audience: ["beginner", "practitioner", "researcher"]
reading_time: "7 minutes"
asset: "Visual PCA notebook"
---

# PCA in Bioinformatics

**Takeaway:** PCA is a way to summarize major patterns in high-dimensional data, but it does not tell you automatically whether those patterns are biological, technical, or accidental.

## Prerequisites

Read Week 4 for analysis thinking and Week 7 for RNA-seq context.

## Why PCA Shows Up Everywhere

Bioinformatics datasets often have thousands of features:
- genes
- variants
- peaks
- proteins
- cells

PCA, or principal component analysis, compresses many features into a few axes that explain large sources of variation.

## The Plain-English Version

Imagine each sample has 20,000 gene expression values. You cannot plot 20,000 dimensions. PCA finds new axes that summarize the strongest patterns across those genes.

The first principal component, PC1, explains the largest amount of variation. PC2 explains the next largest amount, under the constraint that it is separate from PC1.

## What PCA Can Help With

PCA can reveal:
- treatment separation
- batch effects
- outlier samples
- tissue differences
- sample swaps
- strong technical artifacts

It is often used early in analysis because it gives a fast overview.

## What PCA Cannot Prove

PCA cannot prove:
- causality
- mechanism
- cell identity by itself
- clinical relevance
- that clusters are real biological groups

It is an exploratory tool.

## The Most Important Question

When you see a PCA plot, ask:

```text
What explains the separation?
```

Then check metadata:
- condition
- batch
- sex
- tissue
- time point
- sequencing depth
- quality metrics

If PC1 separates by batch, your treatment result may be in trouble.

## Common Mistakes

- Calling groups "clusters" just because points are near each other.
- Forgetting that scaling and transformation change PCA.
- Ignoring batch labels.
- Overinterpreting PC1 and PC2 while other PCs matter.
- Using PCA as final evidence.
- Forgetting that outliers can dominate.

## What Experts Still Debate

Experts debate preprocessing choices before PCA, especially normalization, transformation, feature selection, scaling, and whether PCA is appropriate for sparse or compositional data.

## Research Gap

A useful public resource would show the same dataset under different PCA preprocessing choices and explain why the plot changes.

## Original Asset

Create a visual notebook that:
- simulates gene expression data
- adds a biological signal
- adds a batch effect
- runs PCA
- shows how interpretation changes

## Credits and References

- scikit-learn PCA documentation: https://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html
- Bioconductor RNA-seq workflow: https://www.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html
- Scanpy documentation: https://scanpy.readthedocs.io/
- Seurat PBMC tutorial: https://satijalab.org/seurat/articles/pbmc3k_tutorial

## Expert Review Checklist

- Build the notebook before publication.
- Add an annotated PCA figure.
- Include a caution about sparse single-cell matrices.
