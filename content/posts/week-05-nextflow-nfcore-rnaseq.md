---
title: "Nextflow And nf-core/rnaseq: From FASTQ Files To A Reproducible Count Matrix"
subtitle: "A practical deep dive into workflow engines, channels, processes, profiles, modules, parallel execution, and how nf-core/rnaseq turns sequencing files into QC reports and expression matrices"
week: 5
audience: ["beginner", "practitioner", "researcher"]
reading_time: "Deep dive"
asset: "Nextflow syntax cheat sheet, nf-core/rnaseq test runner, samplesheet template, and output folder map"
---

# Nextflow And nf-core/rnaseq: From FASTQ Files To A Reproducible Count Matrix

**Takeaway:** Nextflow is the engine that decides what should run, when it should run, and where it should run. nf-core/rnaseq is the community-curated RNA-seq pipeline built on that engine.

If RNA-seq differential expression starts with a count matrix, this guide explains how that count matrix is made.

## Why Workflow Engines Exist

A real RNA-seq project is not one command. It is a chain of decisions:

```text
FASTQ files
  -> raw read QC
  -> trimming or filtering
  -> strandedness checks
  -> reference preparation
  -> alignment or pseudoalignment
  -> gene or transcript quantification
  -> merged count matrices
  -> MultiQC report
  -> downstream statistics
```

You can run those steps manually while learning. That is useful. But manual commands become fragile when you have many samples, many projects, multiple users, an HPC cluster, cloud storage, containers, and reruns after failure.

The common failure is not that a tool never runs. The common failure is that nobody can confidently answer:

```text
Which version ran?
Which reference was used?
Which samples failed QC?
Which command produced this count matrix?
Can I rerun only the failed step?
Can another lab reproduce this?
```

Nextflow exists to make those questions answerable.

## What Nextflow Is

Nextflow is a workflow system for scalable, portable, and reproducible scientific pipelines. It uses a dataflow model: tasks run when their inputs are available, and outputs flow into the next step.

That is the key idea. You do not write:

```text
Run sample 1, then sample 2, then sample 3.
```

You write:

```text
For every sample with FASTQ files, run the appropriate process.
When outputs are ready, pass them to the next process.
```

Nextflow handles scheduling. On your laptop, that may mean local parallel jobs. On a cluster, that may mean submitting jobs to Slurm or another scheduler. On cloud, that may mean AWS Batch, Google Cloud Batch, Azure Batch, Kubernetes, or another supported executor.

## The Five Concepts To Learn First

| Concept | Plain-language meaning | RNA-seq example |
|---|---|---|
| Channel | a stream of values or files | sample metadata plus FASTQ paths |
| Process | one computational step | run FastQC on reads |
| Workflow | how processes connect | QC -> trim -> align -> quantify |
| Module | reusable process definition | a standard FastQC module |
| Profile | execution environment | Docker locally, Singularity on HPC |

Once these click, Nextflow stops feeling like a black box.

## A Tiny Nextflow Example

This simplified example is not nf-core/rnaseq. It is a teaching version of the pattern.

```nextflow
process COUNT_LINES {
  input:
  path file_to_count

  output:
  path "${file_to_count}.lines.txt"

  script:
  """
  wc -l ${file_to_count} > ${file_to_count}.lines.txt
  """
}

workflow {
  Channel.fromPath("data/*.fastq.gz") | COUNT_LINES
}
```

Read it like this:

```text
Find every FASTQ file in data/.
For each file, run COUNT_LINES independently.
Write one output per input.
```

If there are 20 FASTQ files and enough compute resources, those jobs do not need to wait politely in a single-file line. Nextflow can schedule independent tasks in parallel because each task has its own input and output.

## Why Nextflow Is Good For Bioinformatics

Nextflow solves several problems that bioinformatics keeps creating.

| Problem | What Nextflow helps with |
|---|---|
| Many samples | runs independent sample-level tasks in parallel |
| Many tools | connects tools into a formal workflow |
| Fragile environments | supports Docker, Singularity/Apptainer, Conda, Podman, and other runtimes |
| Reruns after failure | caches successful tasks and supports `-resume` |
| HPC and cloud execution | separates workflow logic from execution backend |
| Hidden provenance | records reports, traces, timelines, parameters, and logs |
| Collaboration | pipelines can be shared through Git repositories |

The practical win is not glamour. It is trust.

## The Pitfalls

Nextflow is powerful, but beginners usually struggle in predictable places.

| Pitfall | What it looks like | How to avoid it |
|---|---|---|
| confusing `params` and config | pipeline behaves differently than expected | pass pipeline parameters through CLI or `-params-file` |
| treating `work/` as final output | lost in hashed task folders | use `--outdir` outputs for scientific results |
| forgetting `-resume` | reruns expensive completed tasks | use `-resume` after fixing a failed run |
| wrong profile | Docker command on HPC, Singularity command on laptop | choose profile for the environment |
| underestimating disk | `work/` grows quickly | plan storage before full datasets |
| changing inputs silently | cached tasks no longer mean what you think | keep samplesheet, params, references, and command |
| mixing genome and annotation | low assignment or broken counting | record FASTA and GTF/GFF source and release |

Most Nextflow problems are not syntax problems. They are input, environment, and expectation problems.

## Important Syntax Without The Panic

### Channels

A channel is a stream. It may contain paths, values, or structured tuples.

```nextflow
Channel.fromPath("data/*.fastq.gz")
```

In RNA-seq, a channel often carries a sample ID plus one or two FASTQ files:

```text
[sample metadata, reads]
```

That pairing matters. You do not want reads floating around without their sample identity.

### Processes

A process is one step. It declares what it needs and what it produces.

```nextflow
process FASTQC {
  input:
  tuple val(meta), path(reads)

  output:
  tuple val(meta), path("*_fastqc.html")

  script:
  """
  fastqc ${reads}
  """
}
```

The process says:

```text
Give me sample metadata and read files.
Run FastQC.
Return the sample metadata with the FastQC report.
```

Keeping `meta` with outputs is how large pipelines avoid losing sample identity.

### Workflows

A workflow connects processes.

```nextflow
workflow {
  reads_ch | FASTQC
}
```

nf-core/rnaseq uses much larger workflows and subworkflows, but the idea is the same: channels enter, processes run, outputs continue.

### Operators

Operators transform channels.

| Operator | What it does |
|---|---|
| `.map { }` | changes each item |
| `.filter { }` | keeps selected items |
| `.branch { }` | splits a channel into named routes |
| `.mix()` | combines streams |
| `.join()` | combines streams by matching keys |
| `.collect()` | gathers items together |

These are how Nextflow supports modular, parallel processing. Independent branches can run separately, then join later when the workflow needs combined evidence.

## What nf-core Adds

nf-core is a community project that provides curated Nextflow pipelines for bioinformatics. It adds:

- standardized pipeline templates
- reusable modules and subworkflows
- consistent documentation
- parameter schemas
- test profiles
- container support
- versioned releases
- community review and maintenance

That matters because a pipeline is not only code. It is an agreement about structure.

The nf-core ecosystem includes pipelines across many areas: RNA-seq, variant calling, single-cell, methylation, metagenomics, proteomics, viral reconstruction, and more. The point is not that nf-core has one magic RNA-seq pipeline. The point is that the community has built a shared pattern for running complex bioscience workflows.

## How nf-core Pipelines Are Structured

A typical nf-core pipeline has several layers:

```text
main.nf
  -> imports workflows and subworkflows
workflows/
  -> defines the main analysis logic
subworkflows/
  -> groups related steps
modules/
  -> reusable tool-level processes
conf/
  -> profiles and process-specific settings
nextflow_schema.json
  -> parameter validation and launch forms
assets/
  -> schemas, report text, templates, helper files
```

That structure is why nf-core pipelines can be large without becoming a single unreadable script.

## What nf-core/rnaseq Does

nf-core/rnaseq analyzes RNA-seq data from organisms with a reference genome and annotation. It accepts FASTQ files or selected pre-aligned BAM workflows, runs QC and processing steps, and produces expression outputs plus QC reports.

At a high level:

```text
samplesheet.csv
  -> reference preparation
  -> raw FASTQ QC
  -> trimming/filtering/optional rRNA removal
  -> strandedness inference when requested
  -> STAR, HISAT2, Bowtie2+Salmon, Salmon, kallisto, or RSEM-style routes
  -> count and abundance outputs
  -> MultiQC report
  -> pipeline_info provenance
```

It does **not** replace your biological interpretation. It does **not** prove differential expression by itself. It gets you to QC reports and expression matrices so downstream analysis can begin responsibly.

## The Samplesheet Is The Contract

The samplesheet tells nf-core/rnaseq what biological files exist and how they should be grouped.

```csv
sample,fastq_1,fastq_2,strandedness,seq_platform
CONTROL_REP1,data/fastq/control_rep1_R1.fastq.gz,data/fastq/control_rep1_R2.fastq.gz,auto,ILLUMINA
CONTROL_REP2,data/fastq/control_rep2_R1.fastq.gz,data/fastq/control_rep2_R2.fastq.gz,auto,ILLUMINA
TREATED_REP1,data/fastq/treated_rep1_R1.fastq.gz,data/fastq/treated_rep1_R2.fastq.gz,auto,ILLUMINA
TREATED_REP2,data/fastq/treated_rep2_R1.fastq.gz,data/fastq/treated_rep2_R2.fastq.gz,auto,ILLUMINA
```

The first columns matter:

| Column | Meaning | Common mistake |
|---|---|---|
| `sample` | sample identifier | using filenames instead of stable sample names |
| `fastq_1` | R1 file or single-end FASTQ | path does not exist |
| `fastq_2` | R2 file for paired-end data | R1/R2 pairs mismatched |
| `strandedness` | `forward`, `reverse`, `unstranded`, or `auto` | guessing instead of checking kit/QC |
| `seq_platform` | optional sequencing platform information | inconsistent spelling |

Rows with the same sample identifier can represent repeated sequencing runs for the same sample; nf-core/rnaseq can merge them before downstream steps. That is useful for technical runs. It is not a license to collapse biological replicates.

If `strandedness` is set to `auto`, nf-core/rnaseq does not shrug and guess. Current documentation describes a subsampling-based inference step that uses Salmon and reports strandedness evidence in MultiQC. Treat that as a QC result to inspect, especially if the library-prep kit says one thing and the inferred result says another.

## A Real Pipeline Excerpt: Top-Level Wiring

In nf-core/rnaseq, the top-level `main.nf` imports the main RNA-seq workflow and supporting subworkflows. A shortened excerpt looks like this:

```nextflow
include { RNASEQ                  } from './workflows/rnaseq'
include { PREPARE_GENOME          } from './subworkflows/local/prepare_genome'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils_nfcore_rnaseq_pipeline'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils_nfcore_rnaseq_pipeline'
```

This teaches a big idea:

```text
The top-level pipeline does not do every tool step directly.
It imports reusable workflows and coordinates them.
```

Then the pipeline prepares reference files before launching the main RNA-seq workflow:

```nextflow
PREPARE_GENOME(...)
RNASEQ(ch_samplesheet, PREPARE_GENOME.out.fasta, PREPARE_GENOME.out.gtf, ...)
```

That is the handoff pattern: one subworkflow emits reference outputs; the main RNA-seq workflow consumes them.

## A Real Pipeline Excerpt: Branching FASTQ And BAM Inputs

Inside the RNA-seq workflow, nf-core/rnaseq converts the samplesheet into structured channel records. A shortened teaching excerpt:

```nextflow
channel
  .fromList(samplesheetToList(params.input, "${projectDir}/assets/schema_input.json"))
  .map { meta, fastq_1, fastq_2, genome_bam, transcriptome_bam ->
    if (!fastq_2) {
      return [ meta.id, meta + [ single_end:true ], [ fastq_1 ], genome_bam, transcriptome_bam ]
    } else {
      return [ meta.id, meta + [ single_end:false ], [ fastq_1, fastq_2 ], genome_bam, transcriptome_bam ]
    }
  }
  .groupTuple()
  .branch {
    bam: params.skip_alignment && (genome_bam || transcriptome_bam)
    fastq: reads.size() > 0 && reads[0]
  }
```

Do not worry about every character. Read the shape:

```text
Read samplesheet.
Attach metadata.
Detect single-end vs paired-end.
Group repeated rows for a sample.
Branch inputs into BAM route or FASTQ route.
```

This is how one pipeline supports multiple input styles without becoming a pile of separate scripts.

## A Real Pipeline Excerpt: Conditional Alignment

nf-core/rnaseq does not blindly run every aligner. It checks parameters and follows the selected route.

```nextflow
if (!params.skip_alignment && (params.aligner == 'star_salmon' || params.aligner == 'star_rsem')) {
  ALIGN_STAR(...)
}

if (!params.skip_alignment && params.aligner == 'hisat2') {
  FASTQ_ALIGN_HISAT2(...)
}
```

That is modular processing in practice:

```text
If STAR route is selected, run STAR-related subworkflow.
If HISAT2 route is selected, run HISAT2-related subworkflow.
If alignment is skipped, do not waste time aligning.
```

The same pipeline can behave differently based on parameters while preserving the same overall structure.

## A Real Pipeline Excerpt: Parallel QC Evidence

nf-core/rnaseq collects QC evidence from many places and feeds it into MultiQC. You will see patterns like:

```nextflow
ch_multiqc_files = ch_multiqc_files.mix(FASTQ_QC_TRIM_FILTER_SETSTRANDEDNESS.out.multiqc_files)
ch_multiqc_files = ch_multiqc_files.mix(ALIGN_STAR.out.log_final)
```

Plain English:

```text
Take QC files from read-level processing.
Take QC files from alignment.
Mix them into the MultiQC input stream.
```

That is why MultiQC can show read quality, trimming, alignment, strandedness, duplication, assignment, and other metrics in one report.

## Profiles: Same Pipeline, Different Compute Reality

The same nf-core/rnaseq pipeline can run in different environments.

| Profile | Use when |
|---|---|
| `docker` | local laptop or workstation with Docker/Colima |
| `singularity` / `apptainer` | HPC where Docker is not allowed |
| `conda` | local learning or when containers are unavailable |
| institute profile | your organization has a maintained config |
| cloud profile | running through supported cloud infrastructure |

For a local test:

```bash
nextflow run nf-core/rnaseq \
  -profile test,docker \
  --outdir results/week-05-nfcore-rnaseq-test \
  -resume
```

The `test` profile supplies a tiny input dataset and reference files. The `docker` profile tells Nextflow to use Docker containers. The `-resume` flag tells Nextflow to reuse successful cached tasks if the run is restarted.

If you are on an HPC cluster, the equivalent might be:

```bash
nextflow run nf-core/rnaseq \
  -profile test,singularity \
  --outdir results/week-05-nfcore-rnaseq-test \
  -resume
```

Use the profile your computing environment supports.

## Run The Week 5 Test Helper

The resource folder includes a small wrapper script:

```bash
# From the repository root:
bash content/resources/week-05/run_nfcore_rnaseq_test.sh
```

Before using the Docker profile, make sure Docker Desktop or Colima is running:

```bash
docker info
```

If that command cannot connect to Docker, start Docker Desktop or run `colima start` before launching the pipeline.

The script runs:

```bash
nextflow run nf-core/rnaseq \
  -profile "test,docker" \
  --outdir "results/week-05-nfcore-rnaseq-test" \
  -resume
```

This is a pipeline machinery test, not a publishable biological analysis. It answers:

```text
Can this machine run Nextflow?
Can it pull the pipeline?
Can it use the selected container profile?
Can it produce the expected output structure?
```

## What Happens During A Run

When you launch a Nextflow pipeline, several things happen:

| Thing | Meaning |
|---|---|
| `.nextflow.log` | main run log |
| `.nextflow/` | Nextflow metadata |
| `work/` | task-level working directories and cache |
| `results/` or your `--outdir` | published results |
| execution report | resource and task summary |
| trace file | task-level runtime details |
| timeline file | when tasks ran |

The `work/` directory is important for caching and debugging. It is not the folder you hand to a collaborator as final results.

## Output Folder Tour

The exact output structure depends on pipeline version and parameters, but a typical RNA-seq run may include:

| Output area | Why it matters |
|---|---|
| `multiqc/` | start here; one report summarizing many QC tools |
| `fastqc/` | raw and/or trimmed read quality |
| trimming folder | adapter removal and reads retained |
| aligner folder | mapping summaries, BAMs, logs, indexes |
| quantification folder | gene/transcript counts and abundance |
| `rseqc/` | strandedness and RNA-seq-specific QC when enabled |
| `pipeline_info/` | versions, parameters, reports, timeline, trace |

The resource file `output_folder_map.md` gives a practical folder-by-folder checklist.

## How To Read The First MultiQC Report

Open MultiQC before opening a count matrix.

Look for:

- Did all expected samples appear?
- Are read qualities acceptable?
- Is adapter content under control?
- Did trimming remove a suspicious amount of data?
- Are mapping rates reasonable for the organism and assay?
- Is strandedness consistent with the expected library prep?
- Are duplication levels plausible?
- Are any samples extreme outliers?
- Did assignment or quantification look unusually low?

If MultiQC is alarming, do not rush into DESeq2. A bad count matrix still produces a volcano plot.

## Where Week 5 Hands Off To Week 4

Week 5 is about producing and auditing the count matrix.

Week 4 is about interpreting the count matrix correctly:

```text
Week 5:
FASTQ -> nf-core/rnaseq -> QC reports -> count matrix

Week 4:
count matrix + metadata -> DESeq2 model -> cautious biological interpretation
```

That separation matters. Pipelines create structured evidence. Statistical models test biological questions. Neither replaces experimental judgment.

## Save This: Nextflow + nf-core/rnaseq Decision Map

| Decision | Good beginner default | Ask before changing |
|---|---|---|
| pipeline | nf-core/rnaseq stable release | Do I need a custom workflow or a community pipeline? |
| first run | `-profile test,docker` | Does my compute environment support Docker? |
| local containers | Docker or Colima | Is Docker running and allowed? |
| HPC containers | Singularity/Apptainer | Does my cluster provide a profile? |
| input | validated samplesheet | Are sample names, FASTQs, and strandedness correct? |
| reference | matched FASTA + GTF/GFF | Are genome build and annotation compatible? |
| rerun | `-resume` | Did I change inputs or parameters intentionally? |
| first output to inspect | MultiQC | Do QC metrics support downstream analysis? |
| final handoff | count matrix + metadata + QC | Is this ready for DESeq2 or should I stop? |

## Common Mistakes Worth Avoiding

- Running a full dataset before the test profile works.
- Using Docker on a cluster where Docker is blocked.
- Treating `auto` strandedness as a substitute for checking the report.
- Mixing `GRCh37` FASTA with `GRCh38` annotation.
- Deleting `work/` before a failed run is debugged.
- Forgetting to save the exact command, pipeline version, and parameter file.
- Assuming nf-core/rnaseq performs statistical differential expression. It does not.
- Trusting a count matrix before reading MultiQC.

## What To Watch Next

Next, the natural follow-up is **RNA-seq QC: When To Trust, Pause, Or Re-run Your Analysis**. That article should be less about launching the pipeline and more about reading the evidence: FastQC, MultiQC, mapping rate, duplication, strandedness, assignment, sample swaps, and batch patterns.

## Credits and References

- Nextflow documentation: https://docs.seqera.io/nextflow/
- Nextflow GitHub repository: https://github.com/nextflow-io/nextflow
- nf-core website and documentation: https://nf-co.re/
- nf-core/rnaseq documentation: https://nf-co.re/rnaseq/3.26.0/
- nf-core/rnaseq usage documentation: https://nf-co.re/rnaseq/3.26.0/docs/usage/
- nf-core/rnaseq output documentation: https://nf-co.re/rnaseq/3.26.0/docs/output/
- nf-core/rnaseq source code: https://github.com/nf-core/rnaseq
- nf-core modules documentation: https://nf-co.re/docs/contributing/modules
- MultiQC documentation: https://docs.seqera.io/multiqc/
- Ewels PA et al. The nf-core framework for community-curated bioinformatics pipelines. Nature Biotechnology. 2020. https://doi.org/10.1038/s41587-020-0439-x
- Di Tommaso P et al. Nextflow enables reproducible computational workflows. Nature Biotechnology. 2017. https://doi.org/10.1038/nbt.3820
