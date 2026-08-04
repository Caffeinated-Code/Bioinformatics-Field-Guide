# nf-core/rnaseq Output Folder Map

Exact folders depend on parameters, aligner, pseudo-aligner, and pipeline version. Use this as a practical orientation map, not a promise that every run has every folder.

| Folder or file | What it usually means | First thing to inspect |
|---|---|---|
| `multiqc/` | Combined QC report across tools and samples | `multiqc_report.html` |
| `fastqc/` | Raw or trimmed read QC reports | per-base quality, adapter content, duplication |
| `fastp/` or `trimgalore/` | Trimming reports if trimming is enabled | reads retained and adapter removal |
| `star_salmon/` | STAR alignment plus Salmon quantification outputs | mapping summaries and merged count files |
| `salmon/` | Salmon quantification outputs when pseudoalignment is used | quantification summaries and matrices |
| `rseqc/` | RNA-seq QC metrics such as strandedness and gene body coverage | strandedness and coverage patterns |
| `qualimap/` | BAM-level alignment QC when enabled | mapping distribution and assignment |
| `pipeline_info/` | Nextflow reports, software versions, parameters, execution traces | versions, timeline, trace, report |
| `work/` | Nextflow task cache and intermediate files | do not treat as final output |

## Files Worth Saving

```text
multiqc_report.html
pipeline_info/
merged count matrices
samplesheet.csv
params file or exact command
Nextflow version
pipeline version
container profile
reference FASTA and GTF/GFF source
```

## Files Not To Panic About

```text
work/
.nextflow/
.nextflow.log
temporary task directories
```

These files are useful for debugging and `-resume`, but they are not the main scientific deliverables.
