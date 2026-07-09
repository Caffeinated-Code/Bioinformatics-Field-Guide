# Biology Sanity Check

Use this worksheet before analyzing a biological dataset.

## One-Sentence Dataset Story

Fill in the blanks:

```text
In [biological system], [assay] measured [molecular signal] to compare [groups or conditions].
```

Example:

```text
In liver organoids, RNA-seq measured gene expression to compare treated and control samples.
```

## Core Questions

| Question | Your answer |
|---|---|
| Organism and genome build | |
| Tissue, cell type, or model system | |
| Assay type | |
| Molecular signal measured | |
| Main comparison | |
| Biological replicates per group | |
| Controls | |
| Known batches | |
| Missing metadata | |
| Main limitation | |

## Assay Reality Check

| Assay | Measures | Does not directly prove |
|---|---|---|
| RNA-seq | RNA abundance | Protein abundance, mechanism, clinical effect |
| ATAC-seq | Chromatin accessibility | Transcription factor binding by itself |
| ChIP-seq | Protein-DNA enrichment | Functional regulation by itself |
| WGS/WES | DNA variants | Variant effect without interpretation |
| Proteomics | Protein abundance | Transcript abundance |
| scRNA-seq | Cell-level RNA abundance | Complete tissue architecture |
| Spatial transcriptomics | RNA signal with location | Full protein-level function |

## Interpretation Guardrails

Before writing a conclusion, mark the strongest claim the data supports:

| Claim level | Is this supported? | Evidence needed |
|---|---|---|
| Association | | Group difference or correlation |
| Differential signal | | Statistical test and quality control |
| Biological mechanism | | Perturbation, validation, or causal evidence |
| Biomarker | | Independent validation and performance metrics |
| Therapeutic target | | Functional evidence, specificity, and safety context |

## Final Check

Write one sentence that separates evidence from interpretation:

```text
The data show [direct observation], which may suggest [interpretation], but does not yet prove [limit].
```
