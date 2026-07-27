---
title: "Bulk RNA-seq Field Guide: From Reads To Rigorous Differential Expression"
subtitle: "Nextflow pipelines, raw counts, TPM/FPKM, DESeq2 design formulas, replicates, assumptions, outliers, and the caveats that matter"
week: 4
audience: ["beginner", "practitioner", "researcher"]
reading_time: "7-minute core + design lab"
asset: "nf-core/rnaseq samplesheet and DESeq2 design formula cheat sheet"
---

# Bulk RNA-seq Field Guide: From Reads To Rigorous Differential Expression

**Takeaway:** Bulk RNA-seq is not just "run a pipeline, make a volcano plot." The processing steps are mostly standardized; the hard part is making sure the statistical model matches the biological experiment.

## The Pattern Behind Many Sequencing Assays

Bulk RNA-seq has its own details, but the skeleton is familiar across many sequencing assays:

```text
raw reads -> QC -> trimming/filtering -> alignment or quantification -> feature-level table -> metadata-aware statistical model
```

ATAC-seq, ChIP-seq, CUT&Tag, eCLIP-seq, and many counting-based assays follow the same broad rhythm:

- inspect raw reads
- remove obvious technical problems
- map or quantify reads against a reference
- summarize signal into genomic features
- model the feature table using metadata
- interpret results with biological context

The tools differ. The statistical assumptions differ. But the discipline is the same: every output is only as trustworthy as the metadata, reference files, QC, and model behind it.

## What Bulk RNA-seq Measures

Bulk RNA-seq measures RNA abundance averaged across many cells in a sample. A sample might be tissue, a sorted cell population, an organoid, a treatment well, or a patient biopsy.

The "bulk" part matters. A bulk sample mixes signal across all cells in the submitted material. If a treated tissue has more immune cells than a control tissue, the RNA-seq signal can change because cell composition changed, because gene regulation changed within the same cells, or both. Bulk RNA-seq is powerful, but it is not cell-type resolved.

It does not directly measure:

- protein abundance
- cell-type-specific expression
- causality
- pathway activity by itself
- expression in every individual cell

It gives you a count table: genes or transcripts by samples. Differential expression asks whether the observed counts are systematically different between groups after accounting for sequencing depth and biological variability.

## The Vocabulary You Will Keep Seeing

You will see raw counts, TPM, FPKM, normalized counts, log-normalized counts, z-scores, and transformed counts in papers and public databases. Do not be scared by the alphabet soup. These are different answers to different questions.

| Term | What it is | Good for | Not good for |
|---|---|---|---|
| raw counts | integer-ish reads or fragments assigned to a gene/transcript | DESeq2, edgeR, count-based modeling | comparing gene A to gene B directly |
| TPM | transcripts per million; adjusted for transcript length and sequencing depth | comparing relative expression of genes/transcripts within or across descriptive contexts | direct DESeq2 input |
| FPKM/RPKM | fragments/reads per kilobase per million | older expression summaries; rough descriptive plots | differential expression with DESeq2/edgeR |
| DESeq2 normalized counts | raw counts divided by sample-specific size factors | plotting same-gene expression across samples | replacing raw counts in `DESeq()` |
| log-normalized counts | log-transformed normalized expression values | heatmaps, PCA-like exploration, clustering | DESeq2 model input |
| z-scores | centered/scaled values, often per gene | heatmaps showing relative high/low patterns | differential expression testing |
| VST/rlog values | DESeq2 variance-stabilized transformations | PCA, sample distances, visualization | raw differential expression model input |

The short rule:

```text
Use raw counts for DESeq2 modeling.
Use transformed values for visualization and QC.
Use TPM/FPKM carefully for descriptive expression, not DESeq2 differential expression.
```

## Where Raw Counts Come From

Raw counts are not typed by hand. They come from assigning sequencing evidence to genes, transcripts, or other features.

Common routes:

| Route | Tools | What becomes the count |
|---|---|---|
| align then count | STAR/HISAT2 + featureCounts/HTSeq | reads/fragments overlapping gene features in a GTF/GFF |
| transcript quantification | Salmon/kallisto + tximport | estimated transcript abundance summarized to gene-level counts |
| pipeline output | nf-core/rnaseq | gene count matrices from configured aligner/quantifier choices |

For DESeq2, the safest mental model is:

```text
FASTQ -> alignment/quantification -> raw gene-level count matrix -> DESeq2
```

Salmon and kallisto produce estimated counts and TPM. When using transcript-level estimates for gene-level DESeq2 analysis, use a workflow such as `tximport` so abundance, counts, and effective lengths are handled correctly. Do not grab the TPM column and feed it directly into DESeq2.

## Hypothesis Testing: What Are We Testing?

Differential expression is hypothesis testing repeated across thousands of genes.

For one gene, a simple treated-vs-control test is:

```text
Null hypothesis H0: after accounting for the design, the treatment effect is 0.
Alternative hypothesis H1: after accounting for the design, the treatment effect is not 0.
```

In DESeq2 language, this often becomes:

```text
H0: log2 fold change = 0
H1: log2 fold change != 0
```

DESeq2 estimates a model coefficient for the contrast you ask for, such as treated versus control. It then asks whether that coefficient is far enough from zero relative to its uncertainty. Because this happens for thousands of genes, you must control for multiple testing. That is why adjusted p-values matter.

Important distinction:

```text
The p-value asks about evidence against the null.
The log2 fold change tells you effect size.
The adjusted p-value accounts for many genes being tested.
```

You need all three, plus QC and biological judgment.

## The Production Path: Use Nextflow When The Data Is Real

For real projects, do not hand-wire twenty shell commands unless you are deliberately teaching or debugging. Use a maintained workflow.

The most common production-grade choice is **nf-core/rnaseq**, a community Nextflow pipeline. It accepts FASTQ files or pre-aligned BAMs, performs QC, trimming and alignment or pseudoalignment, and produces count matrices plus QC reports.

Why this matters:

- the pipeline records software versions
- containers reduce environment drift
- samplesheets make inputs explicit
- MultiQC centralizes quality reports
- reruns are easier
- cluster/cloud execution is more manageable

Minimal nf-core/rnaseq shape:

```bash
# Install or update Nextflow separately, then run nf-core/rnaseq.
nextflow run nf-core/rnaseq \
  -profile docker \
  --input samplesheet.csv \
  --outdir results/nfcore_rnaseq \
  --genome GRCh38
```

The Week 4 resource folder includes a tiny samplesheet template:

```csv
sample,fastq_1,fastq_2,strandedness
control_rep1,data/fastq/control_rep1_R1.fastq.gz,data/fastq/control_rep1_R2.fastq.gz,auto
treated_rep1,data/fastq/treated_rep1_R1.fastq.gz,data/fastq/treated_rep1_R2.fastq.gz,auto
```

Before running a full pipeline, check:

- Are sample names unique?
- Do FASTQ paths exist?
- Is strandedness known or set to `auto` intentionally?
- Is the genome build correct?
- Is the annotation compatible with the genome?
- Are treatment labels stored in metadata, not only filenames?

## Strandedness: Why The Samplesheet Asks

RNA-seq libraries can preserve information about which DNA strand the RNA came from. This is called **strandedness**.

You will commonly see:

| Value | Meaning |
|---|---|
| unstranded | strand information is not preserved |
| forward | reads follow one expected strand convention |
| reverse | reads follow the opposite strand convention |
| auto | let the pipeline infer strandedness when supported |

Why this matters:

- gene counts can be wrong if strandedness is set incorrectly
- antisense or overlapping genes are especially affected
- assignment rates may drop
- a pipeline may produce plausible-looking but biased counts

If you do not know strandedness, check the library prep kit, sequencing provider notes, or run an inference tool such as RSeQC/infer_experiment through a pipeline-supported QC step. Setting `auto` is convenient, but you should still inspect the final strandedness/QC report.

## Genome Build And Annotation Must Match

Genome build and annotation compatibility is one of the easiest ways to quietly ruin an RNA-seq analysis.

Bad:

```text
Genome: human
Annotation: genes.gtf
```

Better:

```text
Genome FASTA: GRCh38 primary assembly
Annotation GTF: GENCODE release 44 for GRCh38
Source URL:
Download date:
Pipeline parameter:
```

The FASTA and GTF/GFF must describe the same coordinate system. If the FASTA says `chr1` and the annotation says `1`, or if one file is GRCh37 and the other is GRCh38, counting can fail or silently undercount.

Where to find references:

| Source | Use it for |
|---|---|
| GENCODE | human/mouse gene annotation and reference files |
| Ensembl | many species, FASTA/GTF/GFF resources |
| NCBI RefSeq | curated reference sequences and annotation |
| UCSC | genome browser tracks and selected reference resources |
| nf-core reference docs | guidance for pipeline reference handling |
| AWS iGenomes | public S3-hosted legacy/common reference bundles |

nf-core pipelines support reference catalogues through `--genome`, and nf-core/rnaseq ships the AWS iGenomes catalogue by default. The nf-core docs now recommend user-maintained catalogues for modern references when you want the same `--genome` convenience with current reference files.

AWS iGenomes is useful when working on AWS because common reference genomes are hosted in public S3. The general pattern is:

```bash
# Example pattern, not a universal path for every organism/build.
aws s3 ls s3://ngi-igenomes/igenomes/
```

Use public S3 references thoughtfully:

- confirm the organism
- confirm the genome build
- confirm the annotation source and release
- record the exact S3 path
- avoid mixing an iGenomes FASTA with an unrelated local GTF

## Processing Choices: Alignment Or Pseudoalignment

Bulk RNA-seq usually goes down one of two paths:

| Path | Examples | Output | Use when |
|---|---|---|---|
| Alignment | STAR, HISAT2 | BAM plus counts | you need genome-aligned reads, splice junctions, IGV tracks |
| Pseudoalignment / selective alignment | Salmon, kallisto | transcript/gene abundance estimates | you want fast quantification and do not need full BAM inspection |

Neither path saves a bad experiment. If the metadata is wrong, if batch equals condition, or if there are no biological replicates, the cleanest pipeline in the world cannot rescue the inference.

## The Count Matrix Is The Hand-Off

Differential expression begins with **raw integer counts**, not TPM, not FPKM, not z-scores, not log-normalized values.

The shape is:

```text
gene_id        control_1  control_2  treated_1  treated_2
ENSG000001        120        98        240        260
ENSG000002          4         2          3          5
ENSG000003       9000      8500       8700       9100
```

The metadata must match the count columns exactly:

```text
sample_id   condition  batch
control_1   control    A
control_2   control    B
treated_1   treated    A
treated_2   treated    B
```

If the count matrix and metadata disagree, the model tests the wrong biology.

## Data That Does Not Belong In DESeq2

DESeq2 expects a matrix of non-negative raw counts, plus metadata describing the samples. These inputs are not appropriate:

| Input | Why it does not work |
|---|---|
| TPM | already length/depth normalized; count-variance relationship is changed |
| FPKM/RPKM | same problem; not raw count evidence |
| z-scores | centered/scaled values have lost count scale |
| log-normalized expression | useful for plots, not count modeling |
| percentages or proportions | different distribution and variance structure |
| negative values | impossible as raw counts |
| batch-corrected expression matrix | model has already been transformed/corrected outside DESeq2 |
| single-cell normalized matrix | use single-cell-aware workflows or pseudobulk counts |
| no-replicate count matrix | can be explored, but formal DE is weak |

Important nuance: transcript quantifiers such as Salmon produce estimated counts that may be non-integer. DESeq2 workflows commonly use `tximport` to summarize transcript-level estimates to gene-level inputs in a way that preserves the information DESeq2 needs.

## The DESeq2 Model In Plain English

DESeq2 models counts using a **negative binomial generalized linear model**. That sounds heavy, but the intuition is manageable.

For gene `i` in sample `j`:

```text
K_ij ~ NegativeBinomial(mu_ij, alpha_i)
```

Where:

- `K_ij` is the observed count
- `mu_ij` is the expected count
- `alpha_i` is gene-specific dispersion, or extra variability beyond Poisson noise

DESeq2 separates sequencing depth from biology:

```text
mu_ij = s_j * q_ij
```

Where:

- `s_j` is the sample size factor
- `q_ij` is the expression strength after accounting for library size

Then the design formula models expression:

```text
log2(q_ij) = beta_0 + beta_1 * condition_j + beta_2 * batch_j + ...
```

When you write:

```r
design = ~ batch + condition
```

you are saying:

> Estimate the condition effect after accounting for batch.

The p-value asks whether the relevant coefficient is different from zero, given the model and assumptions. It is not a magical truth score.

Under the hood, DESeq2 does a few important things:

1. estimates size factors for sequencing-depth normalization
2. estimates gene-wise dispersion
3. borrows information across genes to stabilize dispersion estimates
4. fits a negative binomial GLM for each gene
5. tests coefficients for the requested contrast
6. adjusts p-values for multiple testing
7. optionally shrinks log2 fold changes for more stable ranking and visualization

That borrowing-across-genes step is why DESeq2 works well with modest sample sizes compared with trying to estimate every gene completely independently. But it is still not magic. The design must be valid.

## Replicates: The Part People Underestimate

There are two different things people call replicates:

| Replicate type | Meaning | What to do |
|---|---|---|
| Biological replicate | independent biological unit, such as another mouse, donor, patient, culture, or tissue sample | keep separate; this estimates biological variability |
| Technical replicate | repeated sequencing or measurement of the same library/sample | often combine or collapse before modeling |

Do not collapse biological replicates. They are the evidence for variability.

No biological replicates means no reliable estimate of within-group variation. You can explore, plot, and generate hypotheses, but formal differential expression is weak.

## DESeq2 Design Formulas You Will Actually Use

### 1. Simple Two-Group Design

Use when you have independent biological replicates:

```r
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = metadata,
  design = ~ condition
)

dds <- DESeq(dds)
res <- results(dds, contrast = c("condition", "treated", "control"))
```

Question answered:

```text
Which genes differ between treated and control samples?
```

### 2. Batch-Adjusted Design

Use when batch affects expression and is not perfectly confounded with condition:

```r
design = ~ batch + condition
```

Question answered:

```text
Which genes differ by condition after accounting for batch?
```

Be careful: this works only if both conditions appear across batches. If all controls are in batch A and all treated samples are in batch B, batch and condition are confounded. The model cannot know whether the difference is biology or batch.

### 3. Paired Design

Use when the same donor, patient, mouse, or culture is measured before and after treatment:

```r
design = ~ patient + condition
```

Question answered:

```text
Within the same patient, which genes change after treatment?
```

The patient term absorbs baseline differences between individuals. This is often much stronger than pretending before/after samples are independent.

### 4. Multi-Factor Design

Use when more than one known variable matters:

```r
design = ~ sex + batch + condition
```

This can be appropriate, but only if sample size supports it. Every extra term costs degrees of freedom. A small study cannot support a huge model.

### 5. Interaction Design

Use when the treatment effect may differ by genotype, sex, timepoint, or another factor:

```r
design = ~ genotype + treatment + genotype:treatment
```

Shorthand:

```r
design = ~ genotype * treatment
```

Question answered by the interaction:

```text
Is the treatment effect different between genotypes?
```

Interaction terms are powerful and easy to misread. They do not simply mean "genes changed in both groups." They test whether the difference between conditions differs across another variable.

## A Tiny Design-Matrix Lab

The Week 4 resources include a small R script that shows what formulas become:

```bash
cd content/resources/week-04
Rscript deseq2_design_matrix_demo.R
```

You should see sections for:

```text
Simple condition-only design
Batch-adjusted design
Paired patient design
```

This matters because DESeq2 does not test English sentences. It tests coefficients in a design matrix. If the formula is wrong, the answer is wrong.

## Assumptions And Caveats

Save this list. Most mistakes live here.

| Issue | Why it matters | What to do |
|---|---|---|
| raw counts required | DESeq2 models counts, not TPM/log values | use gene-level raw counts |
| biological replication | dispersion needs within-group variability | aim for true independent replicates |
| library size differences | samples have different sequencing depths | use DESeq2 size factors |
| composition bias | a few genes can dominate counts | inspect normalization assumptions |
| batch effects | technical variation can look biological | include batch only when design supports it |
| confounding | batch and condition cannot be separated | redesign, qualify claims, or avoid overtesting |
| outliers | one sample can drive a gene-level result | inspect PCA, sample distances, Cook's distance |
| low counts | low information inflates noise | use independent filtering and sensible thresholds |
| multiple testing | thousands of genes are tested | interpret adjusted p-values, not raw p-values |
| effect size | tiny changes can be significant in large datasets | report log2 fold change and uncertainty |

## Outliers: Do Not Let One Sample Write The Story

Outliers happen at two levels.

Sample-level outliers:

- failed library
- wrong sample label
- contamination
- different tissue composition
- batch-specific artifact

Gene-level outliers:

- one extreme count in one sample
- mapping artifact
- unmodeled subgroup
- low count instability

Before differential expression, inspect:

```r
vst_counts <- vst(dds)
plotPCA(vst_counts, intgroup = c("condition", "batch"))
```

Also check sample distance heatmaps, library sizes, mapping rates, duplication, strandedness, rRNA content, and assignment rates. A volcano plot should never be the first QC plot you trust.

## What To Be Careful With

- Do not run DESeq2 on TPM.
- Do not compare groups with no biological replicates and present it as definitive.
- Do not ignore pairing when samples come from the same patient.
- Do not include a batch term that is perfectly confounded with condition.
- Do not use every metadata column just because it exists.
- Do not interpret pathway enrichment from a poor differential expression model.
- Do not trust a result that disappears when one sample is removed.
- Do not hide QC failures because the volcano plot looks exciting.

## What A Good Bulk RNA-seq Result Includes

At minimum, report:

- reference genome and annotation version
- pipeline and version, such as nf-core/rnaseq `3.26.0`
- aligner or quantifier
- counting method
- strandedness
- sample metadata
- DESeq2 design formula
- contrast tested
- number of biological replicates
- QC summary
- outlier handling
- adjusted p-value threshold
- log2 fold-change threshold, if used

## Save This: Bulk RNA-seq Decision Map

| Decision | Good default | Ask yourself |
|---|---|---|
| Pipeline | nf-core/rnaseq | Do I need alignment, quantification, or both? |
| Input | FASTQ samplesheet | Are sample names unique and metadata complete? |
| Counts | raw gene counts | Are these integers from a compatible annotation? |
| Normalization | DESeq2 size factors | Are there extreme composition differences? |
| Design | smallest model that matches the experiment | What variation must be accounted for? |
| Replicates | biological replicates kept separate | What is the true independent unit? |
| Contrast | explicit `results()` contrast | What exact comparison am I testing? |
| QC | PCA, sample distances, MultiQC | Do samples behave as expected before testing? |

## What To Watch Next

Next, we can turn this into a small runnable differential expression lab: take a public count matrix, build metadata, check the design matrix, run DESeq2, inspect PCA, shrink log2 fold changes, and make a volcano plot without overclaiming it.

## Credits and References

- nf-core/rnaseq documentation: https://nf-co.re/rnaseq/3.26.0/
- nf-core/rnaseq usage: https://nf-co.re/rnaseq/3.26.0/docs/usage/
- nf-core reference genome documentation: https://nf-co.re/docs/running/reference-genomes
- Nextflow documentation: https://www.nextflow.io/docs/latest/
- DESeq2 vignette: https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
- DESeq2 paper: Love MI, Huber W, Anders S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biology. 2014. https://doi.org/10.1186/s13059-014-0550-8
- tximport vignette: https://www.bioconductor.org/packages/release/bioc/vignettes/tximport/inst/doc/tximport.html
- Bioconductor RNA-seq workflow: https://www.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html
- AWS iGenomes Registry of Open Data: https://registry.opendata.aws/aws-igenomes/
- AWS iGenomes documentation: https://ewels.github.io/AWS-iGenomes/
- GENCODE: https://www.gencodegenes.org/
- Ensembl: https://www.ensembl.org/
