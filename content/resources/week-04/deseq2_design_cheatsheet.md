# DESeq2 Design Formula Cheat Sheet

Use this before running `DESeq()`.

## Simple Two-Group Comparison

```r
design = ~ condition
results(dds, contrast = c("condition", "treated", "control"))
```

Use when samples are independent biological replicates and the main variable is condition.

## Batch-Adjusted Comparison

```r
design = ~ batch + condition
results(dds, contrast = c("condition", "treated", "control"))
```

Use when batch affects expression and is not perfectly confounded with condition.

## Paired Design

```r
design = ~ patient + condition
results(dds, contrast = c("condition", "after", "before"))
```

Use when each patient/donor has multiple measurements. The patient term absorbs baseline differences between individuals.

## Interaction Design

```r
design = ~ genotype + treatment + genotype:treatment
```

Equivalent shorthand:

```r
design = ~ genotype * treatment
```

Use when the treatment effect may differ by genotype, sex, timepoint, or another factor. Interpret interaction coefficients carefully.

## Technical Replicates

Technical replicates are repeated sequencing/library measurements from the same biological sample. They can often be collapsed before modeling.

Do not collapse biological replicates.

## Common Problems

| Problem | Why it matters |
|---|---|
| No biological replicates | No reliable within-group variability estimate |
| Batch perfectly matches condition | You cannot separate biology from batch |
| Raw counts replaced with TPM | DESeq2 expects integer-like raw counts |
| Metadata sample IDs do not match count columns | The model is testing the wrong labels |
| Too many terms for too few samples | The design matrix becomes unstable or not full rank |
| Hidden pairing ignored | Patient/donor variation can overwhelm the condition effect |
