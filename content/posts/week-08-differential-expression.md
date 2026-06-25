---
title: "Differential Expression: What It Tells You and What It Does Not"
subtitle: "A practical interpretation guide for RNA-seq results"
week: 8
audience: ["practitioner", "researcher", "industry"]
reading_time: "7 minutes"
asset: "Differential expression interpretation rubric"
---

# Differential Expression: What It Tells You and What It Does Not

**Takeaway:** Differential expression can tell you which genes changed between conditions, but it cannot by itself prove mechanism, causality, or clinical relevance.

## Prerequisites

Read Week 7 for the RNA-seq workflow and Week 4 for bioinformatics thinking.

## What Differential Expression Tests

Differential expression asks whether observed gene counts differ between groups more than expected by noise, given a statistical model.

It depends on:
- count data
- sample metadata
- normalization
- dispersion estimation
- study design
- multiple-testing correction

## The Columns People Misread

| Column | Meaning | Common mistake |
|---|---|---|
| log fold change | Size and direction of change | Treating tiny effects as important |
| p-value | Evidence under the model | Ignoring multiple testing |
| adjusted p-value | Multiple-testing corrected evidence | Treating as biological truth |
| base mean | Average expression level | Ignoring low-expression instability |

The most useful genes are often not just statistically significant. They are statistically supported, biologically plausible, and relevant to the question.

## A Better Interpretation Rubric

For each result, ask:

1. Is the gene expressed enough to trust the estimate?
2. Is the fold change large enough to matter?
3. Is the adjusted p-value convincing?
4. Is the direction biologically plausible?
5. Is the signal consistent across samples?
6. Is the result robust to reasonable preprocessing choices?
7. Does independent evidence support it?

## Volcano Plots Are Not Conclusions

Volcano plots are useful summaries, but they can encourage shallow interpretation. A labeled point on a volcano plot is a hypothesis, not an answer.

Always inspect:
- normalized counts
- sample-level plots
- batch structure
- pathway context
- known markers or controls

## Common Mistakes

- Ranking genes by p-value only.
- Ignoring effect size.
- Testing too many contrasts without a plan.
- Using the wrong design formula.
- Not accounting for paired samples.
- Treating adjusted p-value cutoffs as universal laws.
- Overinterpreting pathway enrichment.

## What Experts Still Debate

Experts debate best practices for shrinkage, gene filtering, complex designs, pseudobulk single-cell differential expression, and whether pathway-level methods should be primary or secondary.

## Research Gap

Bioinformatics needs more public examples showing how differential expression conclusions change under different design formulas, filtering rules, and batch adjustments.

## Original Asset

Create a differential expression interpretation rubric with scores for:
- statistical support
- effect size
- expression level
- sample consistency
- biological plausibility
- validation priority

## Credits and References

- DESeq2: https://bioconductor.org/packages/release/bioc/html/DESeq2.html
- DESeq2 paper: https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8
- edgeR: https://bioconductor.org/packages/release/bioc/html/edgeR.html
- limma: https://bioconductor.org/packages/release/bioc/html/limma.html
- Bioconductor RNA-seq workflow: https://www.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html

## Expert Review Checklist

- Add a toy result table and show interpretation.
- Verify advice for paired and batch designs.
- Add caution around clinical interpretation.
