---
title: "Foundation Models in Bioinformatics"
subtitle: "What is useful, what is hype, and what needs better benchmarks"
week: 12
status: "draft"
audience: ["practitioner", "researcher", "industry"]
reading_time: "7 minutes"
asset: "Foundation model research-gap map"
---

# Foundation Models in Bioinformatics

**Takeaway:** Foundation models may become useful infrastructure for biology, but their value depends on task-specific evidence, strong baselines, interpretability, and realistic benchmarks.

## Prerequisites

Read Week 10 for single-cell context and Week 11 for paper-reading discipline.

## What Is a Foundation Model?

A foundation model is a large model trained on broad data so it can be adapted to many downstream tasks. In bioinformatics, foundation models are being explored for:
- DNA sequence
- RNA expression
- proteins
- single-cell data
- spatial omics
- drug discovery
- multimodal biological data

The promise is reuse: train once on large biological data, then adapt to many biological questions.

## Why Biology Is Harder Than Text

Biological data is noisy, incomplete, expensive, and deeply context-dependent. A word in a sentence is not the same kind of object as a gene in a cell, a variant in a genome, or a protein in a pathway.

Key challenges:
- batch effects
- sparse measurements
- changing annotations
- weak labels
- tissue specificity
- limited ground truth
- confounded benchmarks

## Where Foundation Models Might Help

They may be useful for:
- representation learning
- variant effect prediction
- protein structure or function tasks
- cell type annotation
- perturbation response prediction
- multimodal integration
- search and retrieval over biological knowledge

But "might help" is not the same as "already better."

## The Benchmark Problem

A foundation model should be compared against:
- simple baselines
- established methods
- smaller task-specific models
- independent datasets
- realistic external validation

If a model only beats weak baselines, the result is not enough.

## Interpretability Needs Discipline

Attention maps, embeddings, and gene importance scores can be useful, but they are not automatically biological explanations. Interpretability claims need validation.

Ask:
- Does the explanation survive perturbation?
- Does it match known biology?
- Does it predict new biology?
- Does it beat a simpler explanation?

## Common Mistakes

- Assuming bigger models are automatically better.
- Treating pretraining as proof of biological understanding.
- Ignoring data leakage.
- Comparing against weak baselines.
- Overclaiming interpretability.
- Forgetting that deployment cost matters.

## What Experts Still Debate

Experts debate whether scale, architecture, biological inductive bias, curated datasets, multimodal training, or better evaluation will matter most. The answer may differ across genomics, transcriptomics, proteomics, and drug discovery.

## Research Gap

The field needs task-specific, transparent, continuously updated benchmarks that compare foundation models against strong classical and domain-specific baselines. For single-cell models, it is especially important to test whether learned representations improve biological conclusions, not just embedding aesthetics.

## Original Asset

Create a foundation model research-gap map:
- model family
- training data type
- claimed tasks
- strongest evidence
- weakest evidence
- baseline quality
- interpretability status
- open benchmark need

## Credits and References

- Foundation models in bioinformatics review: https://academic.oup.com/nsr/article/12/4/nwaf028/7979309
- Single-cell foundation models review: https://www.nature.com/articles/s12276-025-01547-5
- Curated single-cell foundation model papers: https://github.com/OmicsML/awesome-foundation-model-single-cell-papers
- Hugging Face model hub: https://huggingface.co/models
- Papers with Code: https://paperswithcode.com/

## Expert Review Checklist

- Re-check recent papers before publication.
- Add a comparison table of major model families.
- Avoid claims that imply legal, clinical, or translational readiness without evidence.
