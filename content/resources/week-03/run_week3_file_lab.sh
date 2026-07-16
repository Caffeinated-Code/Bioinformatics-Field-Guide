#!/usr/bin/env bash
set -euo pipefail

# Create one output folder so the original teaching files stay untouched.
mkdir -p results

echo "1. Inspect FASTQ"

# Show the first two FASTQ records. FASTQ records come in 4-line blocks:
# read ID, sequence, + separator, and base-quality string.
head -8 data/tiny_reads.fastq

# Count FASTQ lines and divide by 4 to estimate the number of reads.
awk 'END {print NR " lines; " NR/4 " reads"}' data/tiny_reads.fastq > results/tiny_fastq_read_count.txt
cat results/tiny_fastq_read_count.txt

echo
echo "2. Convert SAM to sorted indexed BAM"

# Convert text SAM into compressed binary BAM.
samtools view -bS data/tiny_alignments.sam > results/tiny.bam

# Sort alignments by genomic coordinate. Most BAM workflows expect this.
samtools sort results/tiny.bam -o results/tiny.sorted.bam

# Create a BAM index so tools can jump to regions without scanning the whole file.
samtools index results/tiny.sorted.bam

# Summarize how many alignments are assigned to each contig.
samtools idxstats results/tiny.sorted.bam > results/tiny.idxstats.tsv
cat results/tiny.idxstats.tsv

# Summarize mapped, unmapped, paired, duplicate, and other alignment categories.
samtools flagstat results/tiny.sorted.bam > results/tiny.flagstat.txt
head -8 results/tiny.flagstat.txt

# Convert BAM back to SAM-like text so beginners can inspect alignment columns.
samtools view results/tiny.sorted.bam > results/tiny.alignments.tsv
head -3 results/tiny.alignments.tsv

echo
echo "3. Filter alignments with SAM flags"

# Decode SAM flag 4. Flag 4 means the read is unmapped.
samtools flags 4 > results/sam_flag_unmapped.txt
cat results/sam_flag_unmapped.txt

# Count reads where flag 4 is present. This counts unmapped reads.
samtools view -c -f 4 results/tiny.sorted.bam > results/count_unmapped_reads.txt
printf "unmapped reads: "
cat results/count_unmapped_reads.txt

# Count reads where flag 4 is absent. This counts reads not marked unmapped.
samtools view -c -F 4 results/tiny.sorted.bam > results/count_mapped_reads.txt
printf "mapped reads: "
cat results/count_mapped_reads.txt

# Write only mapped alignments to a SAM-like text file.
samtools view -F 4 results/tiny.sorted.bam > results/mapped_reads.sam
head -3 results/mapped_reads.sam

echo
echo "4. Intersect BAM alignments with BED regions"

# Find reads whose alignment intervals overlap the regions in tiny_regions.bed.
# The -bed option writes BED-like text instead of binary BAM.
bedtools intersect \
  -a results/tiny.sorted.bam \
  -b data/tiny_regions.bed \
  -bed > results/reads_over_regions.bed
cat results/reads_over_regions.bed

echo
echo "5. Create bedGraph and bigWig coverage"

# Convert BAM alignments into a bedGraph coverage track.
bedtools genomecov \
  -ibam results/tiny.sorted.bam \
  -bg > results/tiny.coverage.bedgraph

# Sort bedGraph before converting to bigWig.
sort -k1,1 -k2,2n results/tiny.coverage.bedgraph > results/tiny.coverage.sorted.bedgraph
cat results/tiny.coverage.sorted.bedgraph

# Convert text bedGraph signal into indexed binary bigWig signal.
bedGraphToBigWig results/tiny.coverage.sorted.bedgraph data/tiny.chrom.sizes results/tiny.coverage.bw
ls -lh results/tiny.coverage.bw

echo
echo "6. Connect regions to annotation"

# Join BED regions to overlapping GTF annotation records.
bedtools intersect \
  -a data/tiny_regions.bed \
  -b data/tiny_annotation.gtf \
  -wa -wb > results/regions_overlapping_annotation.tsv
cat results/regions_overlapping_annotation.tsv

echo
echo "7. Keep a no-header VCF view for quick inspection"

# Remove VCF metadata/header lines so only variant records remain.
grep -v '^#' data/tiny_variants.vcf > results/variants.no_header.vcf
cat results/variants.no_header.vcf

echo
echo "Done. Key outputs:"
ls -1 results
