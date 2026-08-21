#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FASTQ_QC } from './modules/local/fastq_qc'
include { ALIGN_MINIMAP2 } from './modules/local/align_minimap2'
include { SORT_INDEX_BAM } from './modules/local/sort_index_bam'
include { ALIGNMENT_QC } from './modules/local/alignment_qc'
include { ISOFORM_COLLAPSE_PLACEHOLDER } from './modules/local/isoform_collapse_placeholder'

workflow {
  if (params.help) {
    log.info """
    Custom ONT long-read teaching pipeline

    Required:
      --input       CSV with columns: sample,fastq,protocol,condition
      --reference   genome FASTA for minimap2

    Optional:
      --annotation  GTF/GFF for downstream isoform comparison/collapse
      --outdir      output directory

    Example:
      nextflow run main.nf -profile docker -params-file params.local.yml -resume
    """
    return
  }

  if (!params.reference) {
    error "Missing --reference. Provide a genome FASTA path."
  }

  Channel
    .fromPath(params.input, checkIfExists: true)
    .splitCsv(header: true)
    .map { row ->
      tuple(
        [ id: row.sample, protocol: row.protocol, condition: row.condition ],
        file(row.fastq, checkIfExists: true)
      )
    }
    .set { ch_reads }

  ch_reference = Channel.value(file(params.reference, checkIfExists: true))
  ch_annotation = params.annotation ? Channel.value(file(params.annotation, checkIfExists: true)) : Channel.value([])

  FASTQ_QC(ch_reads)

  ALIGN_MINIMAP2(
    ch_reads,
    ch_reference,
    params.minimap2_preset,
    params.strand_mode
  )

  SORT_INDEX_BAM(ALIGN_MINIMAP2.out.bam)

  ALIGNMENT_QC(SORT_INDEX_BAM.out.bam)

  ISOFORM_COLLAPSE_PLACEHOLDER(
    SORT_INDEX_BAM.out.bam,
    ch_annotation
  )
}
