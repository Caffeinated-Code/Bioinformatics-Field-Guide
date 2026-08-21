process ALIGNMENT_QC {
  tag "${meta.id}"
  label 'process_low'

  publishDir "${params.outdir}/alignment_qc", mode: 'copy'

  container 'quay.io/biocontainers/samtools:1.20--h50ea8bc_1'

  input:
  tuple val(meta), path(bam), path(bai)

  output:
  tuple val(meta), path("${meta.id}.flagstat.txt"), path("${meta.id}.idxstats.txt"), emit: qc

  script:
  """
  samtools flagstat ${bam} > ${meta.id}.flagstat.txt
  samtools idxstats ${bam} > ${meta.id}.idxstats.txt
  """
}
