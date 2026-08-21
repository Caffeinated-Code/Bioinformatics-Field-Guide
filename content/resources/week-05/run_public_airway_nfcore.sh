#!/usr/bin/env bash
set -euo pipefail

# Public RNA-seq tutorial runner for the Himes et al. airway dataset subset.
# This script intentionally uses a small four-run subset for learning.
# It can still download multiple FASTQ files and run a real pipeline, so check
# disk space and compute resources before launching.

PROFILE="${1:-docker}"
OUTDIR_FETCH="${2:-results/fetchngs/airway_subset}"
OUTDIR_RNASEQ="${3:-results/rnaseq/airway_subset}"

ACCESSIONS="content/resources/week-05/public_airway_accessions.txt"

echo "Step 1: Fetch public FASTQ files and an nf-core/rnaseq-compatible samplesheet"
nextflow run nf-core/fetchngs \
  --input "${ACCESSIONS}" \
  --outdir "${OUTDIR_FETCH}" \
  --nf_core_pipeline rnaseq \
  -profile "${PROFILE}" \
  -resume

echo
echo "Step 2: Run nf-core/rnaseq on the fetched FASTQ files"
echo "Edit content/resources/week-05/airway_rnaseq_params.yml first if your references are elsewhere."
nextflow run nf-core/rnaseq \
  -profile "${PROFILE}" \
  -params-file content/resources/week-05/airway_rnaseq_params.yml \
  --input "${OUTDIR_FETCH}/samplesheet/samplesheet.csv" \
  --outdir "${OUTDIR_RNASEQ}" \
  -resume

echo
echo "Start interpretation here:"
echo "${OUTDIR_RNASEQ}/multiqc/star_salmon/multiqc_report.html"
echo "${OUTDIR_RNASEQ}/pipeline_info/"
