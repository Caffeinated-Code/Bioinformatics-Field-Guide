process SQANTI3_ANNOTATION {
  tag "${meta.id}"
  label 'process_high'

  publishDir "${params.outdir}/sqanti3", mode: 'copy'

  // Pin this in nextflow.config or params.local.yml after choosing a tested SQANTI3 release.
  container "${params.sqanti3_container}"

  input:
  tuple val(meta), path(isoforms_gtf)
  path annotation_gtf
  path genome_fasta
  val extra_args

  output:
  tuple val(meta), path("${meta.id}_sqanti3"), emit: sqanti3_dir

  script:
  """
  mkdir -p ${meta.id}_sqanti3

  sqanti3_qc.py \
    ${isoforms_gtf} \
    ${annotation_gtf} \
    ${genome_fasta} \
    --dir ${meta.id}_sqanti3 \
    --output ${meta.id} \
    ${extra_args}
  """
}
