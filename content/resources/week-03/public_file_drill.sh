#!/usr/bin/env bash
set -eu

# This script downloads small public examples and inspects them from the outside in.
# Generated downloads stay in public_examples/ and are ignored by Git.
mkdir -p public_examples

size_bytes() {
  # macOS uses stat -f%z; GNU/Linux uses stat -c%s.
  if stat -f%z "$1" >/dev/null 2>&1; then
    stat -f%z "$1"
  else
    stat -c%s "$1"
  fi
}

download() {
  local url="$1"
  local out="$2"

  # Download only if the file does not already exist.
  if [ ! -s "$out" ]; then
    curl -L --fail --retry 3 -o "$out" "$url"
  fi

  # Print the file path and size so readers know the download completed.
  printf "%-42s %12s bytes\n" "$out" "$(size_bytes "$out")"
}

echo "Download small public examples"

# FASTQ from ENA/SRA. This is a real sequencing read file.
download "https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR155/007/SRR1553607/SRR1553607_1.fastq.gz" \
  "public_examples/SRR1553607_1.fastq.gz"

# UCSC public example files for alignment, variant, interval, annotation, and signal formats.
download "https://genome.ucsc.edu/goldenPath/help/examples/samExample.sam" \
  "public_examples/ucsc.samExample.sam"
download "https://genome.ucsc.edu/goldenPath/help/examples/bamExample.bam" \
  "public_examples/ucsc.bamExample.bam"
download "https://genome.ucsc.edu/goldenPath/help/examples/bamExample.bam.bai" \
  "public_examples/ucsc.bamExample.bam.bai"
download "https://genome.ucsc.edu/goldenPath/help/examples/cramExample.cram" \
  "public_examples/ucsc.cramExample.cram"
download "https://genome.ucsc.edu/goldenPath/help/examples/cramExample.cram.crai" \
  "public_examples/ucsc.cramExample.cram.crai"
download "https://genome.ucsc.edu/goldenPath/help/examples/vcfExample.vcf.gz" \
  "public_examples/ucsc.vcfExample.vcf.gz"
download "https://genome.ucsc.edu/goldenPath/help/examples/vcfExample.vcf.gz.tbi" \
  "public_examples/ucsc.vcfExample.vcf.gz.tbi"
download "https://genome.ucsc.edu/goldenPath/help/examples/bedExample2.bed" \
  "public_examples/ucsc.bedExample2.bed"
download "https://genome.ucsc.edu/goldenPath/help/examples/bigGenePredExample4.gtf" \
  "public_examples/ucsc.bigGenePredExample4.gtf"
download "https://genome.ucsc.edu/goldenPath/help/examples/bigWigExample2.bw" \
  "public_examples/ucsc.bigWigExample2.bw"

echo
echo "FASTQ checks"

# Test gzip integrity. No output means the compressed FASTQ is readable.
gzip -t public_examples/SRR1553607_1.fastq.gz

# Show the first two FASTQ records.
gzip -cd public_examples/SRR1553607_1.fastq.gz | head -8

# Count lines and reads. FASTQ line count should be divisible by 4.
gzip -cd public_examples/SRR1553607_1.fastq.gz | awk 'END {print NR " lines; " NR/4 " reads"}'

echo
echo "SAM checks"

# Count lines, then show the header/first records.
wc -l public_examples/ucsc.samExample.sam
head -5 public_examples/ucsc.samExample.sam

echo
echo "BAM checks"

# Validate BAM structure. No output means quickcheck did not find a problem.
samtools quickcheck -v public_examples/ucsc.bamExample.bam

# Show BAM header, alignment summary, and first alignment records.
samtools view -H public_examples/ucsc.bamExample.bam | head
samtools flagstat public_examples/ucsc.bamExample.bam | head
samtools view public_examples/ucsc.bamExample.bam | head -3

echo
echo "SAM flag examples on BAM"

# Decode flag 4, then count unmapped, mapped, and primary mapped reads.
samtools flags 4
samtools view -c -f 4 public_examples/ucsc.bamExample.bam
samtools view -c -F 4 public_examples/ucsc.bamExample.bam
samtools view -c -F 260 public_examples/ucsc.bamExample.bam

echo
echo "CRAM checks"

# Validate CRAM structure, then confirm CRAM and CRAI index files exist.
samtools quickcheck -v public_examples/ucsc.cramExample.cram
ls -lh public_examples/ucsc.cramExample.cram public_examples/ucsc.cramExample.cram.crai

echo
echo "VCF checks"

# Show metadata, the main VCF header columns, and the first variant rows.
bcftools view -h public_examples/ucsc.vcfExample.vcf.gz | grep '^##' | head
bcftools view -h public_examples/ucsc.vcfExample.vcf.gz | grep '^#CHROM' | cut -f1-10
bcftools view -H public_examples/ucsc.vcfExample.vcf.gz | cut -f1-10 | head -3

echo
echo "BED checks"

# Count interval records and show the first few BED lines.
wc -l public_examples/ucsc.bedExample2.bed
head -5 public_examples/ucsc.bedExample2.bed

echo
echo "GTF checks"

# Count annotation records, show the first few lines, and print a compact first feature.
wc -l public_examples/ucsc.bigGenePredExample4.gtf
head -5 public_examples/ucsc.bigGenePredExample4.gtf
awk 'BEGIN{FS=OFS="\t"} $0 !~ /^#/ {print $1,$3,$4,$5,$9; exit}' public_examples/ucsc.bigGenePredExample4.gtf

echo
echo "bigWig checks"

# bigWig is binary, so inspect it with bigWigInfo instead of head.
bigWigInfo public_examples/ucsc.bigWigExample2.bw
