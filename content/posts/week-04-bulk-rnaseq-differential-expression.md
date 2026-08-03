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

You will see raw counts, TPM, FPKM, normalized counts, log-normalized counts, z-scores, and transformed counts in papers and public databases. These are not interchangeable. Each one answers a different question.

The safest habit is to ask:

```text
What question was this number designed to answer?
```

| Term | What it is | Good for | Not good for |
|---|---|---|---|
| Raw counts | reads or fragments assigned to a gene/transcript | DESeq2, edgeR, count-based modeling | comparing gene A to gene B directly |
| TPM | transcript-per-million abundance after length normalization | descriptive expression comparisons and browser-style summaries | direct DESeq2 input |
| FPKM/RPKM | fragments/reads per kilobase per million mapped reads | older expression summaries | modern differential expression testing |
| DESeq2 normalized counts | raw counts divided by sample size factors | plotting the same gene across samples | replacing raw counts in `DESeq()` |
| log-normalized counts | log-transformed normalized values | reducing visual domination by highly expressed genes | count-based modeling |
| z-scores | centered and scaled values, often per gene | heatmaps showing relative high/low patterns | abundance or DE testing |
| VST/rlog values | DESeq2 variance-stabilized transformed values | PCA, sample distances, clustering | raw DESeq2 model input |

The short rule:

```text
Use raw counts for DESeq2 modeling.
Use transformed values for visualization and QC.
Use TPM/FPKM carefully for descriptive expression, not DESeq2 differential expression.
```

### Raw Counts

Raw counts are the evidence table for count-based differential expression. A gene count is usually the number of reads or fragments assigned to that gene in one sample.

For paired-end RNA-seq, many tools count **fragments** rather than individual reads because the two reads came from the same original RNA fragment. For single-end RNA-seq, the read and fragment distinction is less important.

Raw counts are:

- non-negative
- usually integer-like
- strongly right-skewed
- full of low-count genes
- often zero-heavy
- more variable at higher expression levels

That last point matters. RNA-seq counts are not well described by a simple normal distribution. They are commonly modeled with a **negative binomial distribution** because the variance is usually larger than the mean. This extra variability is called **overdispersion**.

### FPKM And RPKM

FPKM means **fragments per kilobase per million mapped fragments**. RPKM is the older single-end read version. The idea is to adjust for two obvious biases:

- longer genes collect more reads
- deeper-sequenced samples collect more reads

Formula:

```text
gene length in kb = gene length in base pairs / 1000
library size in millions = total mapped fragments / 1,000,000

FPKM = raw fragment count / (gene length in kb * library size in millions)
```

FPKM can be useful when you need a rough descriptive expression value, especially in older papers and databases. It is not the preferred input for differential expression because the raw count-variance relationship has already been changed.

### TPM

TPM means **transcripts per million**. TPM also corrects for gene or transcript length and sequencing depth, but the order of operations is different from FPKM.

Formula:

```text
RPK = raw count / gene length in kb
TPM = RPK / sum(all RPK values in that sample) * 1,000,000
```

The important difference:

```text
FPKM scales by sequencing depth first.
TPM length-normalizes first, then forces each sample to sum to 1 million.
```

Because every sample's TPM values sum to the same total, TPM is often easier to compare as a relative abundance measure. If gene A is 50 TPM and gene B is 5 TPM in the same sample, gene A has higher relative abundance. But TPM is still not raw count evidence, so it should not be fed directly into DESeq2.

### Normalized Counts

DESeq2 normalized counts are raw counts divided by a sample-specific size factor. A sample with more sequencing depth gets scaled down; a sample with less sequencing depth gets scaled up.

Conceptually:

```text
normalized count = raw count / sample size factor
```

DESeq2 estimates size factors with a median-ratio method, not by simply dividing by total library size. The point is to handle sequencing-depth differences while being less sensitive to a small number of very highly expressed genes.

Normalized counts are good for plotting the same gene across samples. They are not what you pass into `DESeq()`. DESeq2 wants the raw counts and estimates the needed normalization internally.

### Log-Normalized Counts

RNA-seq expression has a huge dynamic range. One gene might have 2 counts, another 20,000. A log transform compresses that range:

```text
log-normalized count = log2(normalized count + pseudocount)
```

The pseudocount prevents `log2(0)`, which is undefined. `+ 1` is common for simple teaching examples.

Log-normalized values are useful for plots because they make low and medium expression patterns visible. They are not raw counts anymore.

### Z-Scores

A z-score asks whether a value is high or low relative to that gene's own pattern:

```text
z = (value - mean for that gene) / standard deviation for that gene
```

This is common in heatmaps. A red square might mean "higher than this gene's average," not "highly expressed in absolute terms." Z-scores are excellent for patterns and terrible for abundance claims.

### VST, rlog, And Other Transformed Counts

DESeq2's variance-stabilizing transformation and regularized log transformation are designed for sample-level exploration:

- PCA
- sample distance heatmaps
- clustering
- outlier inspection

They reduce the mean-variance relationship so high-count genes do not dominate every plot. They are not the input to the differential expression model.

### Try It: Same Counts, Different Units

The Week 4 resources include a tiny script that converts the same toy count table into FPKM, TPM, normalized counts, log-normalized counts, and z-scores.

```bash
# Go to the Week 4 resource folder.
cd content/resources/week-04

# Run the expression-units demo.
Rscript expression_units_demo.R
```

You should see raw counts first:

```text
Raw counts
----------
         gene_id length_bp control_1 control_2 treated_1 treated_2
  GENE_LONG_HIGH      4000      1200       900      2400      2600
 GENE_SHORT_HIGH      1000       600       700       650       800
        GENE_LOW      2000        12        15        20        18
 GENE_ZERO_HEAVY      1500         0         1         0         2
```

Then compare FPKM and TPM:

```text
FPKM
----
GENE_LONG_HIGH   control_1 = 165562.91
GENE_SHORT_HIGH  control_1 = 331125.83

TPM
---
GENE_LONG_HIGH   control_1 = 331125.83
GENE_SHORT_HIGH  control_1 = 662251.66
```

The short gene gets a larger length-normalized value because 600 fragments over 1 kb is denser than 1200 fragments over 4 kb. This is exactly why raw counts cannot be used to compare expression between genes without thinking about gene length.

Now compare normalized, log-normalized, and z-scored values:

```text
DESeq2-style normalized counts, simplified
GENE_LONG_HIGH   control_1 = 1559.42
GENE_SHORT_HIGH  control_1 =  779.71

log2(normalized count + 1)
GENE_LONG_HIGH   control_1 = 10.61
GENE_SHORT_HIGH  control_1 =  9.61

Per-gene z-scores from log-normalized counts
GENE_LONG_HIGH   control_1 = -0.21
GENE_SHORT_HIGH  control_1 =  0.40
```

The same sample can have a high raw expression value, a compressed log value, and a negative z-score. That is not a contradiction. It means the units answer different questions.

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

Differential expression is hypothesis testing repeated across thousands of genes. Start with one gene first.

Imagine a gene has higher counts in treated samples than controls. There are two possible explanations:

```text
Biological signal: treatment changed expression.
Noise: the samples differ because of biological variation, sequencing depth, or random sampling.
```

A statistical test asks whether the observed difference is large relative to the uncertainty.

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

A **p-value** is the probability of seeing a test statistic at least this extreme if the null hypothesis were true. It is not the probability that the null is true. It is not the probability that the result will reproduce. It is not a measure of effect size.

In RNA-seq, the p-value depends on:

- the estimated log2 fold change
- the counts available for that gene
- the dispersion, or gene-level variability
- the number and quality of biological replicates
- the design formula and contrast

This is why volcano plots can surprise beginners:

- A large log2 fold change with noisy replicates may not be statistically convincing.
- A small log2 fold change with many clean replicates may have a tiny p-value.
- A tiny p-value does not automatically mean the change is biologically important.

DESeq2 estimates a model coefficient for the contrast you ask for, such as treated versus control. It then asks whether that coefficient is far enough from zero relative to its uncertainty.

Now scale that up. A typical RNA-seq analysis may test 15,000 to 30,000 genes. If you used raw `p < 0.05` across 20,000 genes and every null hypothesis were actually true, you would still expect:

```text
20,000 genes * 0.05 = 1,000 false positives
```

That is why genome-wide RNA-seq results need multiple-testing correction.

Important distinction:

```text
The p-value asks the evidence question.
The adjusted p-value asks the genome-wide error-control question.
The log2 fold change asks the magnitude question.
```

You need all three, plus QC and biological judgment.

### Common P-Value Adjustment Methods

| Method | What it controls | When to use it |
|---|---|---|
| Bonferroni | family-wise error rate | very small, confirmatory gene families when you want a strict rule |
| Holm | family-wise error rate, usually less conservative than Bonferroni | small confirmatory analyses with strong error control |
| Benjamini-Hochberg | false discovery rate | default choice for genome-wide differential expression |
| Benjamini-Yekutieli | false discovery rate under arbitrary dependence | conservative option when dependency assumptions are a major concern |
| Independent filtering / IHW-style approaches | improves power while preserving error control when valid | genome-wide workflows using independent covariates such as mean expression |

DESeq2 reports Benjamini-Hochberg adjusted p-values by default in the `padj` column. It also uses independent filtering by default to avoid spending testing power on genes with too little count information to be useful.

Practical interpretation:

```text
Use adjusted p-value for the statistical threshold.
Use log2 fold change for the biological size of the effect.
Use plots and QC to decide whether the result is believable.
```

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
| VST/rlog/transformed counts | useful for PCA and sample distances, not model input |
| percentages or proportions | different distribution and variance structure |
| negative values | impossible as raw counts |
| batch-corrected expression matrix | model has already been transformed/corrected outside DESeq2 |
| single-cell normalized matrix | use single-cell-aware workflows or pseudobulk counts |
| no-replicate count matrix | can be explored, but formal DE is weak |

Important nuance: transcript quantifiers such as Salmon produce estimated counts that may be non-integer. DESeq2 workflows commonly use `tximport` to summarize transcript-level estimates to gene-level inputs in a way that preserves the information DESeq2 needs.

Another important nuance: single-cell RNA-seq can use DESeq2 in **pseudobulk** workflows when raw counts are summed per biological sample, donor, condition, and cell type. A normalized cell-by-gene matrix from Seurat or Scanpy is not the same thing.

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

1. estimates size factors using the median-ratio approach
2. estimates gene-wise dispersion
3. borrows information across genes to stabilize dispersion estimates
4. fits a negative binomial GLM for each gene
5. tests coefficients for the requested contrast
6. adjusts p-values for multiple testing
7. optionally shrinks log2 fold changes for more stable ranking and visualization

That borrowing-across-genes step is why DESeq2 works well with modest sample sizes compared with trying to estimate every gene completely independently. But it is still not magic. The design must be valid.

Log2 fold-change shrinkage is especially useful for ranking genes and making interpretable plots. It should be reported clearly because shrunken fold changes and test statistics answer related but not identical questions.

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
- Wagner GP, Kin K, Lynch VJ. Measurement of mRNA abundance using RNA-seq data: RPKM measure is inconsistent among samples. Theory in Biosciences. 2012. https://doi.org/10.1007/s12064-012-0162-3
- R `p.adjust` documentation: https://stat.ethz.ch/R-manual/R-devel/library/stats/html/p.adjust.html
- edgeR user's guide: https://bioconductor.org/packages/release/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf
- AWS iGenomes Registry of Open Data: https://registry.opendata.aws/aws-igenomes/
- AWS iGenomes documentation: https://ewels.github.io/AWS-iGenomes/
- GENCODE: https://www.gencodegenes.org/
- Ensembl: https://www.ensembl.org/
