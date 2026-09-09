process ALIGN_MINIMAP2 {
  tag "${meta.id}"
  label 'process_high'

  publishDir "${params.outdir}/alignments/unsorted", mode: 'copy', enabled: params.save_intermediate_bam

  container 'quay.io/biocontainers/minimap2:2.28--he4a0461_3'

  input:
  tuple val(meta), path(fastq)
  path reference
  val preset
  val strand_mode

  output:
  tuple val(meta), path("${meta.id}.sam"), emit: sam

  script:
  def extra = strand_mode == 'directRNA' ? '-uf' : ''
  """
  minimap2 \
    -ax ${preset} ${extra} \
    -t ${task.cpus} \
    ${reference} \
    ${fastq} \
    > ${meta.id}.sam
  """
}
