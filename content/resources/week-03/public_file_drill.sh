#!/usr/bin/env bash
set -eu

mkdir -p public_examples

size_bytes() {
  if stat -f%z "$1" >/dev/null 2>&1; then
    stat -f%z "$1"
  else
    stat -c%s "$1"
  fi
}

download() {
  local url="$1"
  local out="$2"
  if [ ! -s "$out" ]; then
    curl -L --fail --retry 3 -o "$out" "$url"
  fi
  printf "%-34s %12s bytes\n" "$out" "$(size_bytes "$out")"
}

echo "Download small public examples"

download "https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR155/007/SRR1553607/SRR1553607_1.fastq.gz" \
  "public_examples/SRR1553607_1.fastq.gz"
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
gzip -t public_examples/SRR1553607_1.fastq.gz
gzip -cd public_examples/SRR1553607_1.fastq.gz | head -8
gzip -cd public_examples/SRR1553607_1.fastq.gz | awk 'END {print NR " lines; " NR/4 " reads"}'

echo
echo "SAM checks"
wc -l public_examples/ucsc.samExample.sam
head -5 public_examples/ucsc.samExample.sam

echo
echo "BAM checks"
samtools quickcheck -v public_examples/ucsc.bamExample.bam
samtools view -H public_examples/ucsc.bamExample.bam | head
samtools flagstat public_examples/ucsc.bamExample.bam | head
samtools view public_examples/ucsc.bamExample.bam | head -3

echo
echo "SAM flag examples on BAM"
samtools flags 4
samtools view -c -f 4 public_examples/ucsc.bamExample.bam
samtools view -c -F 4 public_examples/ucsc.bamExample.bam
samtools view -c -F 260 public_examples/ucsc.bamExample.bam

echo
echo "CRAM checks"
samtools quickcheck -v public_examples/ucsc.cramExample.cram
ls -lh public_examples/ucsc.cramExample.cram public_examples/ucsc.cramExample.cram.crai

echo
echo "VCF checks"
bcftools view -h public_examples/ucsc.vcfExample.vcf.gz | grep '^##' | head
bcftools view -h public_examples/ucsc.vcfExample.vcf.gz | grep '^#CHROM' | cut -f1-10
bcftools view -H public_examples/ucsc.vcfExample.vcf.gz | cut -f1-10 | head -3

echo
echo "BED checks"
wc -l public_examples/ucsc.bedExample2.bed
head -5 public_examples/ucsc.bedExample2.bed

echo
echo "GTF checks"
wc -l public_examples/ucsc.bigGenePredExample4.gtf
head -5 public_examples/ucsc.bigGenePredExample4.gtf
awk 'BEGIN{FS=OFS="\t"} $0 !~ /^#/ {print $1,$3,$4,$5,$9; exit}' public_examples/ucsc.bigGenePredExample4.gtf

echo
echo "bigWig checks"
bigWigInfo public_examples/ucsc.bigWigExample2.bw
