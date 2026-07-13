# Week 3 Resources: Bioinformatics File Types

These files support the Week 3 guide: "The Bioinformatics File Types You Must Know."

## Quick Start

```bash
cd content/resources/week-03
conda env create -f environment.yml
conda activate bfg-week3-files
bash run_week3_file_lab.sh
```

The script creates a `results/` folder with a sorted/indexed BAM, interval overlaps, bedGraph coverage, and a bigWig track.

## Files

| File | Purpose |
|---|---|
| `environment.yml` | Conda environment with samtools, bedtools, UCSC bigWig utilities, and seqkit |
| `run_week3_file_lab.sh` | Hands-on tutorial script that connects all file types |
| `file-format-atlas.md` | Saveable file-format reference |
| `public_data_manifest.tsv` | Public source map for finding real examples of each file type |
| `data/tiny_reads.fastq` | Tiny FASTQ example |
| `data/tiny_alignments.sam` | Tiny SAM example |
| `data/tiny_variants.vcf` | Tiny VCF example |
| `data/tiny_annotation.gtf` | Tiny GTF example |
| `data/tiny_regions.bed` | Tiny BED example |
| `data/tiny.chrom.sizes` | Tiny chromosome-size file for bedGraph to bigWig conversion |
| `data/tiny_counts.tsv` | Tiny count matrix |
| `data/tiny_metadata.tsv` | Tiny sample metadata |

These files are intentionally tiny. They are public-data-style teaching files curated to mirror common records from resources such as SRA/ENA, GENCODE, ClinVar/dbSNP, ENCODE, and UCSC Genome Browser tracks. They are for inspection practice, not biological inference.

## Expected Outputs

After running the lab, expect:

| Output | Meaning |
|---|---|
| `results/tiny.sorted.bam` | Coordinate-sorted alignment file |
| `results/tiny.sorted.bam.bai` | BAM index for fast region lookup |
| `results/tiny.idxstats.tsv` | Alignment counts by contig |
| `results/tiny.flagstat.txt` | Alignment summary |
| `results/reads_over_regions.bed` | Reads that overlap BED intervals |
| `results/tiny.coverage.sorted.bedgraph` | Text coverage signal |
| `results/tiny.coverage.bw` | Browser-ready bigWig signal track |
| `results/regions_overlapping_annotation.tsv` | BED regions joined to GTF annotation |
| `results/variants.no_header.vcf` | Quick VCF inspection view |

## Public Source Pattern

For a real project, the same file types often come from:

| File type | Common public source |
|---|---|
| FASTQ | NCBI SRA, ENA, DDBJ |
| BAM/CRAM | ENCODE, 1000 Genomes, published supplementary repositories |
| VCF | ClinVar, dbSNP, gnomAD, 1000 Genomes |
| GTF/GFF | GENCODE, Ensembl, RefSeq |
| BED/narrowPeak/broadPeak | ENCODE, UCSC table browser, peak-calling outputs |
| bedGraph/bigWig | ENCODE, UCSC Genome Browser track hubs |
| Count matrix and metadata | GEO, Single Cell Portal, CELLxGENE, author repositories |
