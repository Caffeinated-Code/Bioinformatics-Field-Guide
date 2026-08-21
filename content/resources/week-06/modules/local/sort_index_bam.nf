process SORT_INDEX_BAM {
  tag "${meta.id}"
  label 'process_medium'

  publishDir "${params.outdir}/alignments", mode: 'copy'

  container 'quay.io/biocontainers/samtools:1.20--h50ea8bc_1'

  input:
  tuple val(meta), path(sam)

  output:
  tuple val(meta), path("${meta.id}.sorted.bam"), path("${meta.id}.sorted.bam.bai"), emit: bam

  script:
  """
  samtools sort \
    -@ ${task.cpus} \
    -o ${meta.id}.sorted.bam \
    ${sam}

  samtools index \
    -@ ${task.cpus} \
    ${meta.id}.sorted.bam
  """
}
