# Bioinformatics File Format Atlas

Use this when you receive a file and need to ask, "What am I looking at?"

| File | Represents | Inspect with | Watch out for |
|---|---|---|---|
| FASTQ / FASTQ.GZ | Raw sequencing reads and base qualities | `zcat`, `head`, `seqkit`, FastQC | Do not edit by hand |
| SAM | Text alignments | `head`, `samtools view` | Very large text files |
| BAM | Binary alignments | `samtools view`, `samtools flagstat`, IGV | Sort and index before region queries |
| CRAM | Reference-compressed alignments | `samtools view` | Needs compatible reference genome |
| VCF / VCF.GZ | Genetic variants and genotypes | `bcftools view`, `less` | Annotation and filtering logic matter |
| GTF/GFF | Genome annotation features | `head`, `awk`, `grep` | Annotation version matters |
| BED | Genomic intervals | `head`, `bedtools` | 0-start, half-open intervals |
| bedGraph | Genomic intervals plus signal values | `head`, IGV | Must be sorted for bigWig conversion |
| bigWig | Indexed binary signal track | IGV, UCSC Genome Browser | Not meant for manual editing |
| Count matrix | Feature-by-sample or feature-by-cell counts | R/Python, `head` | Must match metadata |
| Metadata/sample sheet | Sample labels and covariates | R/Python, SQL, `csvcut` | Wrong labels produce wrong analysis |

## Coordinate Conventions

| Format | Convention | Example |
|---|---|---|
| BED | 0-based, half-open | `chr1 100 200` |
| bedGraph | 0-based, half-open | `chr1 100 200 7` |
| VCF | 1-based position | `chr1 101` |
| GTF/GFF | 1-based, closed | exon from `101` to `200` |
| Browser search box | usually 1-based, closed | `chr1:101-200` |

## Quick Inspection Commands

```bash
head tiny_metadata.tsv
head tiny_counts.tsv
head tiny_reads.fastq
head tiny_alignments.sam
grep -v '^#' tiny_variants.vcf | head
awk '$3 == "exon"' tiny_annotation.gtf
head tiny_regions.bed
head tiny.chrom.sizes
```

## The One Question

For every file, ask:

```text
Is this raw data, aligned data, annotation, summarized counts, metadata, or a result?
```
