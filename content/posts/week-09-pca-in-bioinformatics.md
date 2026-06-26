---
title: "PCA in Bioinformatics"
subtitle: "Why everyone uses it and how people misread it"
week: 9
audience: ["beginner", "practitioner", "researcher"]
reading_time: "7 minutes"
asset: "Visual PCA notebook"
---

# PCA in Bioinformatics

**Takeaway:** PCA summarizes major patterns in high-dimensional data, but it does not tell you automatically whether those patterns are biological, technical, or accidental.

## Why PCA Shows Up Everywhere

Bioinformatics datasets often have thousands of features:

- genes
- variants
- peaks
- proteins
- cells

PCA, or principal component analysis, compresses many features into a few axes that explain large sources of variation.

## The Plain-English Version

Imagine each sample has 20,000 gene expression values. You cannot plot 20,000 dimensions.

PCA finds new axes that summarize the strongest patterns across those genes.

- **PC1** explains the largest amount of variation.
- **PC2** explains the next largest amount, separate from PC1.

The plot is a map of variation, not a map of truth.

## What PCA Can Help With

PCA can reveal:

- treatment separation
- batch effects
- outlier samples
- tissue differences
- sample swaps
- strong technical artifacts

It is often used early because it gives a fast overview.

## What PCA Cannot Prove

PCA cannot prove:

- causality
- mechanism
- cell identity by itself
- clinical relevance
- that visual groups are real biological clusters

It is an exploratory tool.

## The Most Important Question

When you see a PCA plot, ask:

```text
What explains the separation?
```

Then check metadata:

- condition
- batch
- donor
- sex
- tissue
- time point
- sequencing depth
- quality metrics

If PC1 separates by batch, your treatment result may be in trouble.

## Why The Same Data Can Give Different PCA Plots

PCA changes when you change:

- normalization
- transformation
- feature selection
- scaling
- outlier handling
- batch correction

This is not a flaw in PCA. It is a reminder that preprocessing is part of the analysis.

## A Mini Interpretation Example

| Pattern | First question |
|---|---|
| disease and control separate | Is disease confounded with batch or tissue quality? |
| one sample sits far away | Is it a biological outlier or QC failure? |
| PC1 tracks sequencing depth | Was normalization adequate? |
| cell types separate strongly | Is this expected from marker biology? |

The plot starts the investigation. It does not end it.

## Common Mistakes

- Calling groups "clusters" just because points are near each other.
- Forgetting that transformation changes PCA.
- Ignoring batch labels.
- Overinterpreting PC1 and PC2 while other PCs matter.
- Using PCA as final evidence.
- Forgetting that outliers can dominate.
- Reading UMAP-style intuition into PCA axes.

## Save This: PCA Review Checklist

| Check | Question |
|---|---|
| input | What matrix was used? |
| transformation | Were counts normalized or transformed? |
| features | Which genes/features were included? |
| labels | Are condition, batch, donor, and QC shown? |
| variance | How much variance do PC1 and PC2 explain? |
| outliers | Are individual samples driving the plot? |
| interpretation | Is the claim exploratory or confirmatory? |

## What To Watch Next

Experts debate preprocessing choices before PCA, especially for sparse, compositional, or single-cell data. The best practice is not to hide those choices. Show them, justify them, and avoid making claims the plot cannot support.

## Credits and References

- scikit-learn PCA documentation: https://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html
- Bioconductor RNA-seq workflow: https://www.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html
- Scanpy documentation: https://scanpy.readthedocs.io/
- Seurat PBMC tutorial: https://satijalab.org/seurat/articles/pbmc3k_tutorial
