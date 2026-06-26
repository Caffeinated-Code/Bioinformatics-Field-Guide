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

## What The Test Actually Asks

Differential expression asks whether observed gene counts differ between groups more than expected under a statistical model.

It depends on:

- count data
- sample metadata
- normalization
- dispersion estimation
- study design
- multiple-testing correction

The result is model-based evidence. It is not automatic biology.

## The Columns People Misread

| Column | Meaning | Common mistake |
|---|---|---|
| log fold change | size and direction of change | treating tiny effects as important |
| p-value | evidence under the model | ignoring multiple testing |
| adjusted p-value | corrected evidence across many tests | treating it as biological truth |
| base mean | average expression level | ignoring low-expression instability |

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
- outliers

## A Tiny Example

Suppose `GENE1` has:

| gene | log2 fold change | adjusted p-value | base mean |
|---|---:|---:|---:|
| GENE1 | 0.18 | 0.00001 | 900 |
| GENE2 | 2.4 | 0.04 | 6 |
| GENE3 | 1.2 | 0.003 | 180 |

`GENE1` is statistically strong but may have a small effect. `GENE2` has a large effect but low expression, so the estimate may be unstable. `GENE3` may be the more interesting first follow-up if the biology fits.

That is the point: interpretation needs more than one column.

## Design Formula Matters

A design formula tells the model what comparison to test and what covariates to account for.

Examples:

```r
~ condition
~ batch + condition
~ donor + condition
```

If batch is confounded with condition, no formula can magically create a clean experiment. If donor pairing matters and is ignored, the result can be misleading.

## Common Mistakes

- Ranking genes by p-value only.
- Ignoring effect size.
- Testing too many contrasts without a plan.
- Using the wrong design formula.
- Not accounting for paired samples.
- Treating adjusted p-value cutoffs as universal laws.
- Overinterpreting pathway enrichment.
- Making clinical claims from exploratory results.

## Save This: DE Result Triage

| Check | Good sign |
|---|---|
| expression | not driven by near-zero counts |
| effect size | large enough to matter biologically |
| adjusted p-value | survives multiple-testing correction |
| sample consistency | not driven by one outlier |
| design | covariates match the experiment |
| biology | direction fits known or testable biology |
| validation | independent data or experiment can support it |

## What To Watch Next

Experts still debate shrinkage, filtering, complex designs, pseudobulk single-cell differential expression, and when pathway-level interpretation should be primary or secondary. A careful analyst treats differential expression as a prioritized hypothesis list, not as final proof.

## Credits and References

- DESeq2: https://bioconductor.org/packages/release/bioc/html/DESeq2.html
- DESeq2 paper: https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8
- edgeR: https://bioconductor.org/packages/release/bioc/html/edgeR.html
- limma: https://bioconductor.org/packages/release/bioc/html/limma.html
- Bioconductor RNA-seq workflow: https://www.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html
