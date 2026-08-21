process ISOFORM_COLLAPSE_PLACEHOLDER {
  tag "${meta.id}"
  label 'process_medium'

  publishDir "${params.outdir}/isoforms", mode: 'copy'

  input:
  tuple val(meta), path(bam), path(bai)
  path annotation

  output:
  tuple val(meta), path("${meta.id}.isoform_collapse_plan.txt"), emit: plan

  script:
  def annotation_note = annotation ? "Annotation file: ${annotation}" : "Annotation file: not provided"
  """
  cat > ${meta.id}.isoform_collapse_plan.txt <<'EOF'
Sample: ${meta.id}
BAM: ${bam}
${annotation_note}

This teaching placeholder marks the handoff to an isoform discovery/collapse step.
Possible next tools:
- StringTie2 long-read mode
- IsoQuant
- FLAIR
- TALON
- SQANTI3 for annotation, QC, and curation after transcript models are built
- custom splice-junction-first isoform collapse engine

For a custom ONT isoform collapse algorithm:
1. Parse spliced BAM CIGAR operations.
2. Extract exon blocks and intron chains.
3. Correct junction wobble within a small tolerance.
4. Hash corrected intron chains.
5. Cluster fuzzy TSS/TES endpoints inside each intron-chain bucket.
6. Require minimum read support.
7. Export GFF3, BED12, read assignments, and QC metrics.
8. Run SQANTI3 on collapsed transcript models before publishing novel isoforms.
EOF
  """
}
