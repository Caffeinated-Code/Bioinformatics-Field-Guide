#!/usr/bin/env bash
set -euo pipefail

mkdir -p results

echo "1. Inspect FASTQ"
head data/tiny_reads.fastq

echo
echo "2. Convert SAM to sorted indexed BAM"
samtools view -bS data/tiny_alignments.sam > results/tiny.bam
samtools sort results/tiny.bam -o results/tiny.sorted.bam
samtools index results/tiny.sorted.bam
samtools idxstats results/tiny.sorted.bam > results/tiny.idxstats.tsv
samtools flagstat results/tiny.sorted.bam > results/tiny.flagstat.txt

echo
echo "3. Intersect BAM alignments with BED regions"
bedtools intersect \
  -a results/tiny.sorted.bam \
  -b data/tiny_regions.bed \
  -bed > results/reads_over_regions.bed

echo
echo "4. Create bedGraph and bigWig coverage"
bedtools genomecov \
  -ibam results/tiny.sorted.bam \
  -bg > results/tiny.coverage.bedgraph
sort -k1,1 -k2,2n results/tiny.coverage.bedgraph > results/tiny.coverage.sorted.bedgraph
bedGraphToBigWig results/tiny.coverage.sorted.bedgraph data/tiny.chrom.sizes results/tiny.coverage.bw

echo
echo "5. Connect regions to annotation"
bedtools intersect \
  -a data/tiny_regions.bed \
  -b data/tiny_annotation.gtf \
  -wa -wb > results/regions_overlapping_annotation.tsv

echo
echo "6. Keep a no-header VCF view for quick inspection"
grep -v '^#' data/tiny_variants.vcf > results/variants.no_header.vcf

echo
echo "Done. Key outputs:"
ls -1 results
