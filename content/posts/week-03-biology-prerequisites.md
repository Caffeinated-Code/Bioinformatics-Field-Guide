---
title: "What Biology Do You Need for Bioinformatics?"
subtitle: "A practical map for computational learners"
week: 3
audience: ["beginner", "career-switcher", "practitioner"]
reading_time: "7 minutes"
asset: "Biology prerequisite map"
---

# What Biology Do You Need for Bioinformatics?

**Takeaway:** You do not need a full biology degree to start bioinformatics, but you do need a working map of DNA, RNA, proteins, cells, experiments, and biological uncertainty.

## Prerequisites

Read Week 1 for setup and Week 2 for programming languages. This post explains the biology side of the same foundation.

## The Biology You Actually Use

Bioinformatics is not just coding on biological files. The analysis only matters if it respects the experiment that produced the data.

Start with five ideas:

| Concept | Why it matters |
|---|---|
| DNA | Stores genetic sequence and variation |
| RNA | Reflects gene expression and regulation |
| Protein | Carries out many cellular functions |
| Cell type | Determines biological context |
| Experiment | Determines what your data can and cannot answer |

## DNA: The Reference Is Not the Person

DNA analysis often starts with a reference genome, but the reference is a coordinate system, not a perfect truth. Reads are aligned to it, variants are called against it, and annotations are layered on top of it.

Learn:
- chromosomes
- genes
- exons and introns
- variants
- reference genomes
- genome annotations

The practical question is often: where is this signal in the genome, and how confident are we?

## RNA: Expression Is Context

RNA-seq measures RNA abundance, often as a proxy for gene expression. But expression depends on tissue, cell type, time, condition, batch, and protocol.

Learn:
- transcription
- splicing
- gene expression
- count matrices
- normalization
- differential expression

The practical question is often: which genes changed, in which samples, and under what assumptions?

## Proteins: Closer to Function, Harder to Predict

Proteins do much of the work in cells. Sequence changes can affect protein structure, binding, localization, and function. Proteomics and protein prediction are increasingly important, especially with AI-based structure and function tools.

Learn:
- amino acids
- domains
- motifs
- post-translational modification
- protein families
- structure-function relationships

The practical question is often: does this molecular change plausibly alter function?

## Cells: The Unit of Context

Single-cell and spatial methods remind us that tissue is not one thing. A tumor, organ, or culture can contain many cell states and cell types.

Learn:
- cell type
- cell state
- differentiation
- immune cells
- tumor microenvironment
- spatial organization

The practical question is often: which cells are driving the pattern?

## Experiments: Data Has a Biography

Every dataset has a backstory:
- How were samples collected?
- What platform was used?
- How many replicates exist?
- What batches exist?
- What controls exist?
- What metadata is missing?

If you ignore the experiment, your analysis can be elegant and wrong.

## Common Mistakes

- Treating gene names as stable and universal.
- Forgetting that annotations change over time.
- Assuming RNA changes equal protein changes.
- Ignoring batch effects.
- Confusing correlation with mechanism.
- Overinterpreting a single dataset.

## What Experts Still Debate

Experts often disagree about how much biology a computational analyst must know before contributing. A useful standard is this: you should understand enough biology to know when your result is surprising, impossible, underpowered, or biologically uninteresting.

## Research Gap

There is a need for better "biology for computational people" maps that connect concepts directly to file types, workflows, and analysis decisions.

## Original Asset

Create a biology prerequisite map with four tracks:
- Genome track.
- Transcriptome track.
- Protein/function track.
- Cell and tissue context track.

Each concept should link to a future post and one recommended reference.

## Credits and References

- NCBI Bookshelf: https://www.ncbi.nlm.nih.gov/books/
- Ensembl genome browser: https://www.ensembl.org/
- UCSC Genome Browser: https://genome.ucsc.edu/
- Gene Ontology Consortium: https://geneontology.org/
- UniProt: https://www.uniprot.org/

## Expert Review Checklist

- Add a diagram connecting biology concepts to common file types.
- Confirm terminology is beginner-safe but scientifically accurate.
- Add recommended beginner references before publication.
