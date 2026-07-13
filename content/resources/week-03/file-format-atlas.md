# Bioinformatics File Format Atlas

Use this when you receive a file and need to ask, "What am I looking at?"

| File | Represents | Inspect with | Watch out for |
|---|---|---|---|
| FASTQ / FASTQ.GZ | Raw sequencing reads and base qualities | `zcat`, `head`, `seqkit`, FastQC | Do not edit by hand |
| SAM | Text alignments | `head`, `samtools view` | Very large text files |
| BAM | Binary alignments | `samtools view`, IGV | Needs `.bai` index for random access |
| CRAM | Reference-compressed alignments | `samtools view` | Needs compatible reference genome |
| VCF / VCF.GZ | Genetic variants and genotypes | `bcftools view`, `less` | Annotation and filtering logic matter |
| GTF/GFF | Genome annotation features | `head`, `awk`, `grep` | Annotation version matters |
| BED | Genomic intervals | `head`, `bedtools` | Coordinate conventions matter |
| Count matrix | Feature-by-sample or feature-by-cell counts | R/Python, `head` | Must match metadata |
| Metadata/sample sheet | Sample labels and covariates | R/Python, SQL, `csvcut` | Wrong labels produce wrong analysis |

## Quick Inspection Commands

```bash
head tiny_metadata.tsv
head tiny_counts.tsv
head tiny_reads.fastq
head tiny_alignments.sam
grep -v '^#' tiny_variants.vcf | head
awk '$3 == "exon"' tiny_annotation.gtf
head tiny_regions.bed
```

## The One Question

For every file, ask:

```text
Is this raw data, aligned data, annotation, summarized counts, metadata, or a result?
```
