---
title: "Nextflow For Bioinformatics: The Big Picture Before You Run nf-core/rnaseq"
subtitle: "Why workflow engines matter, how Nextflow runs locally or on AWS, what caching and parallel execution actually do, and how to launch nf-core/rnaseq without getting lost"
week: 5
audience: ["beginner", "practitioner", "researcher"]
reading_time: "7-minute core + practical run notes"
asset: "nf-core/rnaseq test runner, samplesheet template, and output folder map"
---

# Nextflow For Bioinformatics: The Big Picture Before You Run nf-core/rnaseq

**Takeaway:** Nextflow is not an RNA-seq tool. It is the workflow engine that makes complex bioinformatics analyses portable, parallel, resumable, and easier to audit.

If you need a refresher on what bulk RNA-seq measures, what raw counts mean, or why TPM should not go into DESeq2, start with [Week 4: Bulk RNA-seq Field Guide](week-04-bulk-rnaseq-differential-expression.html). This week answers a different question:

```text
How do professional bioinformatics pipelines run the same analysis across many samples without becoming chaos?
```

## The Problem Nextflow Solves

A real RNA-seq analysis is not one command. It is a chain:

```text
FASTQ files
  -> read QC
  -> trimming or filtering
  -> strandedness checks
  -> reference preparation
  -> alignment or pseudoalignment
  -> quantification
  -> merged expression matrices
  -> MultiQC report
  -> downstream statistics
```

Running that by hand teaches you what the tools do. But for real projects, hand-wired commands become fragile. You need to know:

- which software versions ran
- which reference genome and annotation were used
- which samples failed QC
- which command produced the count matrix
- whether failed steps can resume without rerunning everything
- whether the same workflow can run on a laptop, HPC, or AWS

Nextflow exists to make those questions answerable.

## What Nextflow Is

Nextflow is a workflow engine. It connects computational steps and decides when each step can run.

The mental model is:

```text
inputs become channels
channels feed processes
processes produce outputs
outputs feed the next steps
independent steps run in parallel
```

You describe the analysis. Nextflow handles the execution.

That distinction matters. A workflow engine is not trying to replace `STAR`, `Salmon`, `FastQC`, `samtools`, or `DESeq2`. It coordinates those tools in a reproducible way.

## Why Bioinformaticians Use It

| Need | What Nextflow gives you |
|---|---|
| many samples | runs independent sample-level tasks in parallel |
| many tools | connects tools into a formal workflow |
| reproducibility | records logs, reports, parameters, versions, and task traces |
| environment control | supports Docker, Singularity/Apptainer, Podman, Conda, and more |
| failure recovery | caches completed tasks and resumes with `-resume` |
| portability | same pipeline logic can run locally, on HPC, or in cloud |
| collaboration | pipeline code, configs, and parameters can be version-controlled |

The point is not that Nextflow makes analysis effortless. The point is that it makes complex analysis **inspectable**.

## What It Competes With

Nextflow is not the only workflow system.

| Tool | Strength | Common fit |
|---|---|---|
| Nextflow | portable, strong cloud/HPC support, widely used in bioinformatics, nf-core ecosystem | production bioinformatics workflows |
| Snakemake | Pythonic, very readable for many researchers, strong rule-based workflows | lab-scale pipelines and custom analysis |
| WDL/Cromwell | common in Broad/GATK-style environments | genomics workflows in WDL ecosystems |
| CWL | standards-focused and portable | formal workflow portability requirements |
| Galaxy | graphical, accessible, training-friendly | users who prefer web-based workflows |

My practical recommendation:

```text
Use nf-core/Nextflow when a mature community pipeline exists.
Use custom Nextflow when you need production portability and modular execution.
Use Snakemake when a small lab pipeline needs to stay Python-adjacent and simple.
Use Galaxy when accessibility and GUI training matter most.
```

## Local, HPC, And AWS: Same Logic, Different Execution

Nextflow separates workflow logic from execution environment.

On a laptop, you might run:

```bash
nextflow run nf-core/rnaseq \
  -profile test,docker \
  --outdir results/week-05-rnaseq-test \
  -resume
```

On an HPC cluster, the profile might use Singularity/Apptainer and a scheduler such as Slurm:

```bash
nextflow run nf-core/rnaseq \
  -profile test,singularity \
  --outdir results/week-05-rnaseq-test \
  -resume
```

On AWS, the same pipeline logic can run with AWS Batch or through Seqera Platform. In cloud runs, input, output, and work directories often live in S3:

```bash
nextflow run nf-core/rnaseq \
  --input s3://my-bucket/project/samplesheet.csv \
  --outdir s3://my-bucket/project/results \
  --fasta s3://my-bucket/references/genome.fa \
  --gtf s3://my-bucket/references/genes.gtf \
  -profile awsbatch \
  -resume
```

The exact AWS profile depends on your infrastructure. The big idea is stable:

```text
pipeline code stays the same
executor changes
storage location changes
container strategy changes
```

## Caching And `-resume`

Nextflow automatically records task executions in a task cache. On local/HPC runs, this is commonly stored under `.nextflow/cache`; in cloud runs, cache behavior can use cloud storage associated with the work directory.

When you run with:

```bash
-resume
```

Nextflow checks which tasks already completed with the same inputs, code, parameters, and environment. Completed tasks can be reused. Failed or changed tasks run again.

This is why a failed 100-sample workflow does not always need to restart from zero.

Things that can invalidate cache:

- changing input files
- changing process code
- changing relevant parameters
- changing container versions
- moving paths in ways that affect task hashes
- deleting the `work/` directory or cache metadata

Beginner rule:

```text
Use -resume after fixing a failed run.
Do not delete work/ until you know you no longer need to resume or debug.
```

## How Nextflow Parallelizes

Nextflow runs tasks when their inputs are ready. If 24 samples each need FastQC, those 24 FastQC tasks are independent. Nextflow can schedule them in parallel, limited by your machine, cluster queue, cloud settings, and process resource requests.

That is why workflow structure matters. This:

```text
sample_1 -> FastQC
sample_2 -> FastQC
sample_3 -> FastQC
...
```

is naturally parallel. Later, a summary step such as MultiQC waits until the QC files are ready:

```text
all FastQC outputs -> MultiQC
```

Parallel where possible. Join where necessary.

## What nf-core Adds

nf-core is a community collection of curated Nextflow pipelines. It adds:

- standard pipeline structure
- documentation
- stable releases
- test profiles
- container support
- parameter schemas
- reusable modules and subworkflows
- community review

That means you do not need to write a new RNA-seq pipeline just to process ordinary bulk RNA-seq data. You can use `nf-core/rnaseq`, then focus your attention on experimental design, QC, and interpretation.

## What nf-core/rnaseq Does

nf-core/rnaseq analyzes RNA-seq data from organisms with a reference genome and annotation. According to current pipeline documentation, it takes a samplesheet and FASTQ files, performs QC, trimming and alignment or pseudoalignment, and produces a gene expression matrix plus extensive QC reports.

At a high level:

```text
samplesheet.csv
  -> FastQC / read QC
  -> trimming and optional filtering
  -> strandedness inference when requested
  -> STAR / Salmon / RSEM / HISAT2-style routes depending on parameters
  -> count and abundance outputs
  -> MultiQC
  -> pipeline_info provenance
```

Important: nf-core/rnaseq does **not** perform statistical differential expression testing. It produces count and abundance outputs. For the statistical side, return to [Week 4](week-04-bulk-rnaseq-differential-expression.html).

## The Samplesheet Is The Contract

A minimal paired-end samplesheet looks like:

```csv
sample,fastq_1,fastq_2,strandedness,seq_platform
CONTROL_REP1,data/fastq/control_rep1_R1.fastq.gz,data/fastq/control_rep1_R2.fastq.gz,auto,ILLUMINA
CONTROL_REP2,data/fastq/control_rep2_R1.fastq.gz,data/fastq/control_rep2_R2.fastq.gz,auto,ILLUMINA
TREATED_REP1,data/fastq/treated_rep1_R1.fastq.gz,data/fastq/treated_rep1_R2.fastq.gz,auto,ILLUMINA
TREATED_REP2,data/fastq/treated_rep2_R1.fastq.gz,data/fastq/treated_rep2_R2.fastq.gz,auto,ILLUMINA
```

Check before running:

- sample names are stable and unique
- FASTQ paths exist
- R1 and R2 files are correctly paired
- strandedness is known or intentionally set to `auto`
- genome FASTA and GTF/GFF annotation match
- output directory has enough space

If `strandedness` is `auto`, inspect the inferred strandedness evidence in MultiQC. Do not treat `auto` as a reason to ignore library prep.

## Run The Test Profile First

From the repository root:

```bash
# Confirm Nextflow is installed.
nextflow -version

# Confirm Docker Desktop or Colima is running.
docker info

# Run the official nf-core/rnaseq test profile.
bash content/resources/week-05/run_nfcore_rnaseq_test.sh
```

The helper script runs:

```bash
nextflow run nf-core/rnaseq \
  -profile "test,docker" \
  --outdir "results/week-05-nfcore-rnaseq-test" \
  -resume
```

This test answers:

```text
Can Nextflow run here?
Can containers run here?
Can the nf-core/rnaseq pipeline launch and finish?
Can I find the output report?
```

It is not a biological analysis.

## Run Your Own RNA-seq Data

Once the test profile works, a real run looks more like:

```bash
nextflow run nf-core/rnaseq \
  --input samplesheet.csv \
  --outdir results/my_rnaseq_project \
  --fasta references/GRCh38.primary_assembly.fa.gz \
  --gtf references/gencode.v44.annotation.gtf.gz \
  -profile docker \
  -resume
```

For reproducibility, save:

- exact command
- pipeline version
- Nextflow version
- samplesheet
- params file, if used
- FASTA and GTF/GFF source
- MultiQC report
- `pipeline_info/`

## First Output To Open

Open MultiQC before touching the count matrix.

Look for:

- missing samples
- low read quality
- adapter issues
- suspicious trimming
- poor mapping rate
- strandedness mismatch
- high duplication
- failed assignment or quantification

A count matrix can look tidy even when the data behind it is not trustworthy.

## Save This: Week 5 Decision Map

| Decision | Good default | Why |
|---|---|---|
| first run | `-profile test,docker` | confirms the machine can run the pipeline |
| local execution | Docker or Colima | easiest reproducible setup on a laptop |
| HPC execution | Singularity/Apptainer | common where Docker is restricted |
| cloud execution | AWS Batch or Seqera Platform | scalable for larger projects |
| restart failed run | `-resume` | avoids rerunning completed tasks |
| first report | MultiQC | tells you whether outputs are believable |
| statistical testing | downstream DESeq2/edgeR/etc. | nf-core/rnaseq does not assign DE significance |

## What Comes Next

Week 6 goes under the hood. We will build a custom Nextflow pipeline for Oxford Nanopore long-read data, step by step, then compare that custom pipeline to the existing nf-core/nanoseq pipeline.

## Credits and References

- Nextflow documentation: https://docs.seqera.io/nextflow/
- Nextflow workflow documentation: https://docs.seqera.io/nextflow/workflow
- Nextflow cache and resume documentation: https://docs.seqera.io/platform-enterprise/launch/cache-resume
- nf-core website and documentation: https://nf-co.re/
- nf-core terminology: https://nf-co.re/docs/community/terminology
- nf-core/rnaseq documentation: https://nf-co.re/rnaseq/
- nf-core/rnaseq source code: https://github.com/nf-core/rnaseq
- MultiQC documentation: https://docs.seqera.io/multiqc/
- Ewels PA et al. The nf-core framework for community-curated bioinformatics pipelines. Nature Biotechnology. 2020. https://doi.org/10.1038/s41587-020-0439-x
- Di Tommaso P et al. Nextflow enables reproducible computational workflows. Nature Biotechnology. 2017. https://doi.org/10.1038/nbt.3820
