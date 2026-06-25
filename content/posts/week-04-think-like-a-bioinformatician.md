---
title: "How to Think Like a Bioinformatician"
subtitle: "Data, biology, statistics, and skepticism"
week: 4
status: "draft"
audience: ["beginner", "practitioner", "researcher", "industry"]
reading_time: "7 minutes"
asset: "Bioinformatics thinking framework"
---

# How to Think Like a Bioinformatician

**Takeaway:** Bioinformatics is the habit of asking whether a biological signal is real, measurable, reproducible, and useful.

## Prerequisites

Read Week 1 for setup, Week 2 for languages, and Week 3 for the biology map.

## The Four Questions

When you see a bioinformatics result, ask:

1. What biological question is being asked?
2. What data was generated to answer it?
3. What assumptions connect the data to the question?
4. What would change my mind?

This is the difference between running tools and doing analysis.

## Biology First

Start with the biological contrast:
- disease vs control
- treated vs untreated
- responder vs non-responder
- cell type A vs cell type B
- time point 1 vs time point 2

If the contrast is unclear, the analysis will drift. A beautiful plot cannot fix a vague question.

## Data Second

Then ask what the assay can measure. RNA-seq measures RNA abundance. Whole-genome sequencing measures DNA sequence. ATAC-seq measures chromatin accessibility. Spatial transcriptomics measures gene expression with location, but often at lower resolution than people assume.

The assay defines the ceiling of the claim.

## Statistics Third

Statistics helps separate signal from noise, but it does not create good experimental design. Replicates, controls, batch structure, and metadata matter before any model is fit.

Ask:
- How many biological replicates exist?
- Are samples independent?
- What batch effects might exist?
- Were covariates measured?
- How many hypotheses were tested?

## Skepticism Always

Good skepticism is not negativity. It is respect for how easy it is to fool yourself with high-dimensional data.

Common skeptical questions:
- Does this pattern survive another normalization?
- Does it appear in an independent dataset?
- Is it driven by outliers?
- Is the label circular?
- Is the strongest result biologically plausible?
- Is there a simpler explanation?

## The Bioinformatics Thinking Framework

```text
Question -> Assay -> Data -> Quality control -> Model -> Result -> Biological interpretation -> Validation
```

At each step, write down what could go wrong.

## Common Mistakes

- Starting with a tool instead of a question.
- Treating default parameters as truth.
- Confusing statistical significance with biological importance.
- Ignoring negative results.
- Making a mechanistic claim from descriptive data.
- Forgetting to ask whether the result is actionable.

## What Experts Still Debate

Experts disagree on how much automation is healthy. Automated workflows are valuable, but they can also hide assumptions. The best analysts automate execution while keeping interpretation deliberate.

## Research Gap

Bioinformatics needs better public examples of failed analyses: cases where a result looked convincing but collapsed because of batch effects, leakage, circular labels, poor controls, or weak validation.

## Original Asset

Create a one-page "Bioinformatics Result Stress Test" checklist:
- Is the question clear?
- Is the assay appropriate?
- Is the metadata complete?
- Is the quality control convincing?
- Are the assumptions visible?
- Is the interpretation overclaimed?
- What validation is needed?

## Credits and References

- Bioconductor workflows: https://www.bioconductor.org/help/workflows/
- Nature reporting summaries and reproducibility resources: https://www.nature.com/nature-portfolio/editorial-policies/reporting-standards
- NIH rigor and reproducibility: https://www.nih.gov/research-training/rigor-reproducibility

## Expert Review Checklist

- Add a visual framework diagram.
- Add one real example from RNA-seq or single-cell analysis.
- Ensure the tone is practical, not abstract.
