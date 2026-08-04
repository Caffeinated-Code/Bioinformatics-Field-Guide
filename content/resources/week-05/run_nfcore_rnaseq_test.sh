#!/usr/bin/env bash
set -euo pipefail

# This runs the official nf-core/rnaseq test profile.
# It is meant to verify that Nextflow, containers, and the pipeline can talk to each other.
# It is not a biological analysis of a real experiment.

OUTDIR="${1:-results/week-05-nfcore-rnaseq-test}"
PROFILE="${2:-docker}"

echo "Running nf-core/rnaseq test profile"
echo "Output directory: ${OUTDIR}"
echo "Container/profile: ${PROFILE}"

nextflow run nf-core/rnaseq \
  -profile "test,${PROFILE}" \
  --outdir "${OUTDIR}" \
  -resume

echo
echo "Done. Start by opening:"
echo "${OUTDIR}/multiqc/star_salmon/multiqc_report.html"
echo
echo "Then inspect pipeline metadata:"
echo "${OUTDIR}/pipeline_info/"
