---
title: "The Bioinformatics File Types You Must Know"
subtitle: "FASTQ, BAM, VCF, GTF, count matrices, and why they matter"
week: 5
audience: ["beginner", "practitioner"]
reading_time: "7 minutes"
asset: "File-format atlas"
---

# The Bioinformatics File Types You Must Know

**Takeaway:** Bioinformatics files are not random extensions; each file type represents a stage in the path from raw measurement to biological interpretation.

## Prerequisites

Read Week 1 for laptop setup and Week 3 for basic DNA and RNA concepts.

## The Big Picture

A sequencing project often moves like this:

```text
raw reads -> aligned reads -> summarized features -> statistical results -> biological interpretation
```

The files change at each step.

## FASTQ: The Raw Read File

FASTQ stores sequencing reads and quality scores. It is often the first file you receive after sequencing.

A FASTQ record has four lines:

```text
@read_id
ACGTACGTACGT
+
FFFFFFFFFFFF
```

The sequence tells you what bases were read. The quality string estimates confidence in each base call.

Use FASTQ for:
- quality control
- trimming
- alignment
- quantification

## SAM and BAM: Where Reads Align

SAM is a text format for aligned sequencing reads. BAM is the compressed binary version. These files answer: where did each read align in the genome or transcriptome?

Use BAM for:
- viewing alignments
- counting reads over features
- variant calling
- checking coverage

Because BAM files can be large, they are usually indexed.

## VCF: Genetic Variants

VCF stores variants such as single nucleotide variants, insertions, deletions, and structural variants. It usually includes genomic position, reference allele, alternate allele, and sample-level genotype information.

Use VCF for:
- variant interpretation
- population genetics
- clinical genetics workflows
- filtering variants by quality and annotation

## GTF and GFF: Genome Annotation

GTF and GFF files describe genomic features such as genes, transcripts, exons, and coding regions. They help tools connect genomic coordinates to biological labels.

Use annotation files for:
- counting reads per gene
- transcript analysis
- feature overlap
- gene model interpretation

## Count Matrix: The Analysis Starting Point

For RNA-seq and single-cell RNA-seq, many statistical analyses begin with a count matrix.

```text
gene_id    sample_1    sample_2    sample_3
GeneA      10          25          18
GeneB      0           4           1
GeneC      100         88          140
```

Rows are usually genes or features. Columns are samples or cells. Values are counts.

## Metadata: The File People Forget

Metadata describes samples:

```text
sample_id    condition    batch    tissue
S1           control      A        liver
S2           treated      A        liver
S3           control      B        liver
```

Without metadata, a count matrix is just numbers.

## Common Mistakes

- Opening huge files in spreadsheet software.
- Editing raw data by hand.
- Mixing genome builds.
- Using gene symbols when stable IDs are needed.
- Forgetting BAM indexes.
- Losing the sample sheet.
- Treating filtered files as raw files.

## What Experts Still Debate

File formats are stable, but best practices around compression, cloud-native access, metadata standards, and workflow provenance are still evolving.

## Research Gap

Bioinformatics would benefit from beginner-friendly file-format validation reports that explain not just whether a file is valid, but whether it is appropriate for a planned analysis.

## Original Asset

Create a file-format atlas with:
- file extension
- data stage
- human-readable or binary
- typical size
- common tools
- common mistakes
- downstream analyses

## Credits and References

- SAM/BAM specification: https://samtools.github.io/hts-specs/SAMv1.pdf
- VCF specification: https://samtools.github.io/hts-specs/VCFv4.3.pdf
- GFF/GTF resources: https://github.com/The-Sequence-Ontology/Specifications
- FastQC: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
- Bioconductor RNA-seq workflow: https://www.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html

## Expert Review Checklist

- Add a diagram showing file flow through a sequencing workflow.
- Confirm specification links are current.
- Add warnings about protected human genomic data.
