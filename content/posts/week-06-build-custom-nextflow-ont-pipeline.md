---
title: "Build Your First Custom Nextflow Pipeline For Oxford Nanopore Data"
subtitle: "A step-by-step, hand-held guide to DSL2 structure, modules, profiles, parameters, long-read strategy, and how your custom ONT pipeline compares with nf-core/nanoseq"
week: 6
audience: ["beginner", "practitioner", "researcher"]
reading_time: "Deep dive + builder lab"
asset: "Custom ONT Nextflow pipeline skeleton with modules, config profiles, samplesheet, and parameter file"
---

# Build Your First Custom Nextflow Pipeline For Oxford Nanopore Data

**Takeaway:** Nextflow becomes much less mysterious once you build a small pipeline yourself. In this guide, you will build the skeleton of a custom Oxford Nanopore long-read pipeline and understand when to use it instead of an existing community pipeline.

If Week 5 was the high-level map, this is the workshop bench.

## Pipeline Goal

We will build a small custom pipeline for Oxford Nanopore long-read FASTQ data:

```text
ONT FASTQ
  -> read QC
  -> minimap2 long-read alignment
  -> sorted and indexed BAM
  -> alignment QC
  -> isoform-collapse handoff
  -> SQANTI3 annotation and curation
```

This is not trying to beat `nf-core/nanoseq`. It is a learning pipeline that shows how pieces fit together. After you understand the pieces, you can decide whether to use an existing pipeline, customize one, or build a specialized method for a specific research problem.

## Build Or Reuse?

Build custom when:

- your assay is unusual
- your target region is small but extremely deep
- you need a method that existing pipelines do not provide
- you are benchmarking algorithms
- you need a clean prototype for a future open-source tool
- you want to understand exactly what each step does

Use an existing pipeline when:

- the task is standard
- a community pipeline already covers your assay
- you need production reliability quickly
- you need tested containers and documentation
- collaborators expect standard outputs

For Oxford Nanopore data, always check `nf-core/nanoseq` before building from scratch.

## ONT Long-Read Strategy

Nanopore reads differ from short-read RNA-seq in important ways:

| Issue | Why it matters |
|---|---|
| longer reads | a single read may span multiple exons or a full transcript |
| higher raw error rate | small indels/substitutions should not become fake isoforms |
| variable read completeness | truncated reads can mimic shorter transcripts |
| direct RNA vs cDNA differences | strandedness, adapters, polyA behavior, and alignment options differ |
| isoform complexity | splice junctions and transcript ends matter more than simple gene counts |

For transcript isoform work, do not think only:

```text
How many reads map to this gene?
```

Think:

```text
Which exon chains are supported?
Which splice junctions are reliable?
Which transcript ends are fuzzy?
Which reads are partial?
Which isoform calls are redundant?
```

That is why a custom pipeline should keep the BAM, QC metrics, read-to-isoform handoff, and SQANTI3 annotation layer clean.

## ONT-Specific QC Checklist

ONT long-read RNA QC needs more than "did the command finish?"

| QC layer | Metrics to inspect | Why it matters |
|---|---|---|
| raw FASTQ | read count, read length N50, length distribution, quality distribution | tells you whether the library produced enough useful long molecules |
| adapters and contamination | adapter signal, lambda or other control contamination, unexpected sequence content | prevents technical molecules from becoming biological claims |
| protocol fit | direct RNA vs cDNA vs PCR-cDNA, strand behavior, polyA expectations | changes alignment and interpretation choices |
| alignment | mapping rate, supplementary/secondary rate, soft clipping, mismatch/indel profile | tells you whether reads align cleanly to the reference |
| splice alignment | intron count, canonical junction fraction, junction wobble, unannotated junction support | central for isoform discovery |
| transcript ends | TSS/TES spread, internal priming risk, truncation patterns | long-read transcript ends are often noisy |
| isoform models | read support per isoform, redundant model rate, partial-read support | prevents overcalling weak or duplicate isoforms |
| SQANTI3 | structural category, junction support, TSS/TES descriptors, artifact flags | annotates and curates transcript models before reporting novelty |

Useful first-pass tools:

- NanoPlot or pycoQC for read-level summaries
- NanoFilt or filtlong for filtering when appropriate
- samtools `flagstat`, `idxstats`, and `stats` for alignment summaries
- minimap2 logs and BAM inspection for alignment behavior
- IGV or JBrowse for targeted loci
- SQANTI3 for isoform model annotation, QC, filtering, and curation

For ONT isoform work, your QC question is:

```text
Are my reads long and clean enough to support transcript structure,
and are my transcript models plausible after annotation-aware curation?
```

## Project Structure

The Week 6 resources include this mini-pipeline:

```text
content/resources/week-06/
  main.nf
  nextflow.config
  params.local.yml
  samplesheet_ont.csv
  modules/
    local/
      fastq_qc.nf
      align_minimap2.nf
      sort_index_bam.nf
      alignment_qc.nf
      isoform_collapse_placeholder.nf
      sqanti3_annotation.nf
```

This is a simplified DSL2 structure:

- `main.nf` wires the workflow together.
- `nextflow.config` defines defaults, profiles, resources, reports, and execution settings.
- `params.local.yml` stores run parameters.
- `samplesheet_ont.csv` defines samples.
- `modules/local/*.nf` define individual reusable steps.

## Samplesheet Contract

The samplesheet is the contract between your biological samples and your pipeline.

```csv
sample,fastq,protocol,condition
ONT_CONTROL_1,data/ont/control_1.fastq.gz,cDNA,control
ONT_CONTROL_2,data/ont/control_2.fastq.gz,cDNA,control
ONT_TREATED_1,data/ont/treated_1.fastq.gz,cDNA,treated
ONT_TREATED_2,data/ont/treated_2.fastq.gz,cDNA,treated
```

For real projects, consider adding:

- run ID
- barcode
- flow cell
- kit
- basecaller version
- tissue or cell type
- replicate ID
- target region
- RNA input quality

Good metadata saves projects. Bad metadata quietly ruins them.

## Parameter File

Use a parameter file instead of a very long command:

```yaml
input: "samplesheet_ont.csv"
outdir: "results/ont_custom"
reference: "references/genome.fa"
annotation: "references/genes.gtf"
minimap2_preset: "splice"
strand_mode: "unknown"
save_intermediate_bam: true
```

The important choices:

| Parameter | Meaning |
|---|---|
| `input` | samplesheet path |
| `outdir` | where published outputs go |
| `reference` | genome FASTA for alignment |
| `annotation` | GTF/GFF for downstream isoform interpretation |
| `minimap2_preset` | long-read alignment mode, often `splice` for RNA |
| `strand_mode` | helps direct RNA or cDNA-specific choices |
| `save_intermediate_bam` | whether to publish unsorted alignment output |
| `sqanti3_container` | tested SQANTI3 runtime image or local environment |
| `sqanti3_extra_args` | extra SQANTI3 QC options after version-specific review |

For real ONT transcript analysis, reference and annotation compatibility matter just as much as they did in [Week 4](week-04-bulk-rnaseq-differential-expression.html).

## Main Workflow

The `main.nf` file starts with imports:

```nextflow
include { FASTQ_QC } from './modules/local/fastq_qc'
include { ALIGN_MINIMAP2 } from './modules/local/align_minimap2'
include { SORT_INDEX_BAM } from './modules/local/sort_index_bam'
include { ALIGNMENT_QC } from './modules/local/alignment_qc'
include { ISOFORM_COLLAPSE_PLACEHOLDER } from './modules/local/isoform_collapse_placeholder'
```

Plain English:

```text
Bring in the steps we want to use.
Each step lives in its own module file.
```

Then it reads the samplesheet:

```nextflow
Channel
  .fromPath(params.input, checkIfExists: true)
  .splitCsv(header: true)
  .map { row ->
    tuple(
      [ id: row.sample, protocol: row.protocol, condition: row.condition ],
      file(row.fastq, checkIfExists: true)
    )
  }
  .set { ch_reads }
```

This is the most important pattern in beginner Nextflow:

```text
Read rows.
Attach metadata.
Attach the FASTQ file.
Emit one tuple per sample.
```

Each emitted item looks conceptually like:

```text
[
  [id: "ONT_CONTROL_1", protocol: "cDNA", condition: "control"],
  data/ont/control_1.fastq.gz
]
```

That metadata travels with the file through the pipeline.

## Read QC Module

The QC module accepts sample metadata and a FASTQ:

```nextflow
process FASTQ_QC {
  tag "${meta.id}"
  label 'process_low'

  input:
  tuple val(meta), path(fastq)

  output:
  tuple val(meta), path("${meta.id}_nanoplot"), emit: report

  script:
  """
  NanoPlot \
    --fastq ${fastq} \
    --outdir ${meta.id}_nanoplot \
    --prefix ${meta.id}_
  """
}
```

What to notice:

- `tag "${meta.id}"` makes logs readable.
- `label 'process_low'` lets config assign resources.
- `tuple val(meta), path(fastq)` keeps sample identity with the file.
- `emit: report` names the output for later use.

## Minimap2 Alignment Module

For ONT RNA/cDNA reads, minimap2 is a common aligner:

```nextflow
process ALIGN_MINIMAP2 {
  tag "${meta.id}"
  label 'process_high'

  input:
  tuple val(meta), path(fastq)
  path reference
  val preset
  val strand_mode

  output:
  tuple val(meta), path("${meta.id}.sam"), emit: bam

  script:
  def extra = strand_mode == 'directRNA' ? '-uf' : ''
  """
  minimap2 \
    -ax ${preset} ${extra} \
    -t ${task.cpus} \
    ${reference} \
    ${fastq} \
    > ${meta.id}.sam
  """
}
```

For transcript-aware alignment, `-ax splice` is the basic starting point. Direct RNA may need additional care, including strand-aware options. Do not treat the preset as a magic truth machine. Always inspect alignment behavior at known loci.

## BAM Sorting And QC

Downstream transcript tools usually expect sorted and indexed BAM files:

```nextflow
samtools sort -o sample.sorted.bam sample.sam
samtools index sample.sorted.bam
samtools flagstat sample.sorted.bam
samtools idxstats sample.sorted.bam
```

The pipeline separates this into modules:

```text
ALIGN_MINIMAP2
  -> SORT_INDEX_BAM
  -> ALIGNMENT_QC
```

That separation is useful. You may later swap the aligner, but still keep the sorting and QC steps.

## Public ONT QC Demo

For public practice data, use the **Singapore Nanopore Expression Data Set (SG-NEx)**. SG-NEx is a public benchmark resource for long-read RNA-seq with Nanopore PCR-cDNA, direct cDNA, direct RNA, PacBio Iso-Seq, matched short-read RNA-seq, and processed alignment files.

The Week 6 resources include one public direct-cDNA A549 sample:

```text
content/resources/week-06/sgnex_ont_demo_samples.tsv
```

The demo script streams a small prefix of the public FASTQ file and writes a local subset:

```bash
# From the repository root.
bash content/resources/week-06/run_sgnex_ont_qc_demo.sh 10000
```

What it does:

```text
public SG-NEx FASTQ URL
  -> stream with curl
  -> decompress
  -> keep first 10,000 reads
  -> recompress local teaching FASTQ
  -> check gzip integrity
  -> count FASTQ lines and reads
```

Expected local output:

```text
data/sgnex_demo/
  SGNex_A549_directcDNA_replicate1_run3.10000_reads.fastq.gz
```

Then run read-level QC if NanoPlot is installed:

```bash
NanoPlot \
  --fastq data/sgnex_demo/SGNex_A549_directcDNA_replicate1_run3.10000_reads.fastq.gz \
  --outdir data/sgnex_demo/nanoplot \
  --prefix SGNex_A549_directcDNA_
```

Interpret the NanoPlot-style report:

| Plot or metric | What to ask |
|---|---|
| read length histogram | are reads long enough for transcript-spanning evidence? |
| read quality distribution | is quality consistent with the chemistry/basecaller? |
| yield over reads | is the subset behaving normally or dominated by a few huge reads? |
| N50 | does the library preserve long molecules? |
| quality vs length | are long reads unusually low quality? |

This is intentionally a QC demo, not a complete SG-NEx analysis. Full SG-NEx files can be large. Start small, learn the checks, then scale deliberately.

## Isoform-Collapse Handoff

The final module is intentionally a placeholder:

```text
ISOFORM_COLLAPSE_PLACEHOLDER
```

This is where a real project might call:

- IsoQuant
- StringTie2 long-read mode
- FLAIR
- TALON
- a custom splice-junction-first collapse engine

This is also where SQANTI3 enters the plan, but with a very specific role:

```text
isoform discovery/collapse creates transcript models
SQANTI3 annotates, classifies, QC-checks, filters, and helps curate those models
```

SQANTI3 is not a direct replacement for minimap2, IsoQuant, FLAIR, StringTie2, or a custom collapse algorithm. It evaluates the transcript models they produce.

For your own ONT isoform-collapse algorithm, a sensible plan is:

```text
sorted BAM
  -> parse CIGAR operations
  -> extract exon blocks and intron chains
  -> correct splice-junction wobble
  -> hash corrected intron chains
  -> cluster fuzzy TSS/TES endpoints
  -> require read support
  -> classify partial reads
  -> export GFF3, BED12, TSV, and read assignments
```

The key idea is to make isoform collapse mostly about **splice structure**, not raw sequence identity. ONT errors should not create new transcript models just because a read has small indels.

## SQANTI3 Annotation And Curation

After isoform discovery, run SQANTI3 before treating novel isoforms as biological findings.

Conceptual flow:

```text
sorted BAM
  -> isoform discovery/collapse
  -> collapsed_isoforms.gtf
  -> SQANTI3 QC and annotation
  -> structural categories, junction descriptors, TSS/TES descriptors, artifact flags
```

SQANTI3 helps answer:

| Question | Why it matters |
|---|---|
| full splice match or incomplete splice match? | distinguishes known transcripts from partial models |
| novel in catalog or novel not in catalog? | separates known-junction combinations from novel-junction models |
| canonical or noncanonical junctions? | flags potential alignment or transcript artifacts |
| suspicious TSS/TES? | transcript ends are noisy in long-read data |
| ORF/CDS support? | helps functional interpretation |
| likely artifact? | prevents weak models from becoming claims |

Typical command shape:

```bash
sqanti3_qc.py \
  collapsed_isoforms.gtf \
  reference_annotation.gtf \
  genome.fa \
  --dir sqanti3 \
  --output sample_sqanti3
```

The Week 6 resources include:

```text
modules/local/sqanti3_annotation.nf
```

That module is a skeleton because SQANTI3 releases and runtime setup can change. Before using it in production:

```text
1. Pick a SQANTI3 release.
2. Pin and test the container or Conda environment.
3. Confirm the command-line arguments for that release.
4. Provide collapsed transcript models, reference annotation, and genome FASTA.
5. Review SQANTI3 output before reporting novel isoforms.
```

Practical rule:

```text
Do not publish novel ONT isoforms without annotation-aware QC such as SQANTI3.
```

## Execution Config

The `nextflow.config` file controls execution:

```nextflow
process {
  cpus = 2
  memory = '8 GB'
  time = '4h'

  withLabel: process_high {
    cpus = 8
    memory = '32 GB'
    time = '12h'
  }
}
```

Labels keep resource rules out of the module logic. The module says:

```text
I am process_high.
```

The config says:

```text
process_high gets 8 CPUs and 32 GB.
```

That makes the pipeline easier to tune.

## Local, HPC, And AWS Profiles

Profiles let the same pipeline run in different environments:

```nextflow
profiles {
  local {
    process.executor = 'local'
  }

  docker {
    docker.enabled = true
    process.executor = 'local'
  }

  singularity {
    singularity.enabled = true
    singularity.autoMounts = true
    process.executor = 'local'
  }

  awsbatch {
    process.executor = 'awsbatch'
    process.queue = 'YOUR_AWS_BATCH_QUEUE'
    workDir = 's3://YOUR_BUCKET/nextflow-work/custom-ont'
    aws.region = 'us-west-2'
  }
}
```

For local learning, use Docker if it is available. For HPC, Singularity/Apptainer is often the right path. For AWS, configure Batch, S3 work storage, region, queues, IAM, and containers carefully before running production data.

## Run The Pipeline

From the Week 6 resource folder:

```bash
cd content/resources/week-06

# See the help message.
nextflow run main.nf --help
```

For real data:

```bash
nextflow run main.nf \
  -profile docker \
  -params-file params.local.yml \
  -resume
```

Before the real run, check:

```bash
nextflow -version
docker info
test -f references/genome.fa
test -f references/genes.gtf
test -f data/ont/control_1.fastq.gz
```

## Production Features To Add Later

Once the skeleton works, add features deliberately:

| Feature | Why add it |
|---|---|
| samplesheet validation | fail early when metadata is wrong |
| MultiQC integration | one report across QC modules |
| `stub` mode | test workflow structure without real tools |
| container version pinning | reproducibility |
| reference indexing process | avoid requiring prebuilt indexes |
| region restriction | useful for targeted locus analysis |
| UMI handling | if protocol includes UMIs |
| strandedness checks | especially for direct RNA |
| SQANTI3 module | annotation-aware isoform QC and curation |
| isoform benchmark outputs | compare tools and custom algorithms |
| CI tests | make sure the pipeline keeps running after edits |

Do not add everything at once. A pipeline becomes reliable by growing in tested layers.

## Compare With nf-core/nanoseq

`nf-core/nanoseq` is the community pipeline to know for Nanopore data. Current documentation describes it as a Nanopore demultiplexing, QC, and alignment pipeline with support for `directRNA`, `cDNA`, and DNA-style protocols.

Typical launch shape:

```bash
nextflow run nf-core/nanoseq \
  --input samplesheet.csv \
  --protocol cDNA \
  -profile docker
```

Or for direct RNA:

```bash
nextflow run nf-core/nanoseq \
  --input samplesheet.csv \
  --protocol directRNA \
  -profile docker
```

Use `nf-core/nanoseq` when:

- your analysis fits its supported routes
- you want community-tested defaults
- you need demultiplexing/QC/alignment in a standard format
- you want strong documentation and stable releases

Use your custom pipeline when:

- you are prototyping a new isoform-collapse method
- you need a very small targeted-locus workflow
- you want to benchmark alternative tools
- you need explicit SQANTI3 curation after custom isoform discovery
- you need to expose algorithmic choices for a methods project
- you are teaching how Nextflow works

The mature move is not to reject nf-core. It is to know when to use it, when to extend it, and when to build a focused tool beside it.

## Pipeline Skeleton Complete

At this point, you have the shape of a real pipeline:

```text
samplesheet
  -> channel of sample metadata + FASTQ
  -> QC module
  -> alignment module
  -> sorting/indexing module
  -> alignment QC module
  -> isoform-collapse handoff
  -> SQANTI3 annotation and curation layer
  -> local/Docker/Singularity/AWS profiles
  -> trace/report/timeline outputs
```

That is the core of production bioinformatics engineering: clear inputs, modular steps, explicit environments, reproducible outputs, and honest limitations.

## Custom Pipeline Checklist

| Question | Good answer |
|---|---|
| What is the biological unit? | sample, replicate, barcode, donor, condition |
| What is the file contract? | samplesheet with stable columns |
| What is the reference contract? | FASTA and annotation source recorded |
| What is parallelizable? | per-sample QC and alignment |
| What must wait? | summary reports and merged outputs |
| What is published? | final outputs only, not random `work/` files |
| What is cached? | task executions, reused with `-resume` |
| What is tested? | syntax, tiny data, containers, expected outputs |
| What is not solved yet? | isoform-collapse accuracy, SQANTI3 curation, and benchmarking |

## Next In The Series

Week 7 will cover CI/CD in bioinformatics: how to test pipelines, validate small datasets, run GitHub Actions, pin environments, publish releases, and keep scientific code from silently breaking.

## Credits and References

- Nextflow documentation: https://docs.seqera.io/nextflow/
- Nextflow workflow documentation: https://docs.seqera.io/nextflow/workflow
- Nextflow modules documentation: https://docs.seqera.io/nextflow/module
- nf-core documentation: https://nf-co.re/
- nf-core/nanoseq documentation: https://nf-co.re/nanoseq/
- nf-core/nanoseq usage documentation: https://nf-co.re/nanoseq/3.1.0/docs/usage/
- SG-NEx AWS Open Data Registry: https://registry.opendata.aws/sgnex/
- SG-NEx data repository: https://github.com/GoekeLab/sg-nex-data
- Chen Y et al. A systematic benchmark of Nanopore long-read RNA sequencing for transcript-level analysis in human cell lines. Nature Methods. 2025. https://doi.org/10.1038/s41592-025-02623-4
- SQANTI3 GitHub repository and documentation: https://github.com/ConesaLab/SQANTI3
- SQANTI3 paper: Pardo-Palacios FJ et al. SQANTI3: curation of long-read transcriptomes for accurate identification of known and novel isoforms. Nature Methods. 2024. https://doi.org/10.1038/s41592-024-02229-2
- Oxford Nanopore EPI2ME workflows: https://epi2me.nanoporetech.com/wfindex/
- Minimap2 paper: Li H. Minimap2: pairwise alignment for nucleotide sequences. Bioinformatics. 2018. https://doi.org/10.1093/bioinformatics/bty191
- SAMtools paper: Danecek P et al. Twelve years of SAMtools and BCFtools. GigaScience. 2021. https://doi.org/10.1093/gigascience/giab008
