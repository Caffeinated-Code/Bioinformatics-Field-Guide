---
title: "Foundation Models in Bioinformatics"
subtitle: "What is useful, what is hype, and what needs better benchmarks"
week: 12
audience: ["practitioner", "researcher", "industry"]
reading_time: "7 minutes"
asset: "Foundation model evidence map"
---

# Foundation Models in Bioinformatics

**Takeaway:** Foundation models may become useful infrastructure for biology, but their value depends on task-specific evidence, strong baselines, interpretability, and realistic benchmarks.

## What Is A Foundation Model?

A foundation model is a large model trained on broad data so it can be adapted to many downstream tasks.

In bioinformatics, foundation models are being explored for:

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
- privacy and access restrictions

A model can learn patterns without learning the biology you care about.

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
- biologically meaningful metrics

If a model only beats weak baselines, the result is not enough.

Recent benchmark work has repeatedly shown that foundation models can be impressive in some settings and underwhelming in others. For example, DNA foundation model benchmarks emphasize the need for diverse genomic tasks and fair evaluation, while single-cell benchmark studies have found that simple or highly variable gene baselines can remain competitive in zero-shot settings.

## Interpretability Needs Discipline

Attention maps, embeddings, and gene importance scores can be useful, but they are not automatically biological explanations.

Ask:

- Does the explanation survive perturbation?
- Does it match known biology?
- Does it predict new biology?
- Does it beat a simpler explanation?
- Can an experimentalist act on it?

Interpretability without validation is storytelling.

## A Practical Evidence Map

| Claim | What would make it convincing? |
|---|---|
| better embeddings | strong baselines on independent datasets |
| better cell annotation | expert-reviewed labels and realistic references |
| better perturbation prediction | held-out perturbations, cell types, and donors |
| better variant interpretation | clinically relevant benchmarks and calibration |
| better biological insight | testable hypotheses validated beyond the model |

## Common Mistakes

- Assuming bigger models are automatically better.
- Treating pretraining as proof of biological understanding.
- Ignoring data leakage.
- Comparing against weak baselines.
- Overclaiming interpretability.
- Forgetting that deployment cost matters.
- Treating a benchmark win as clinical readiness.

## Save This: Foundation Model Review Checklist

| Check | Question |
|---|---|
| task | What exact biological or computational task is tested? |
| baseline | Is the baseline strong and current? |
| split | Is there leakage across donors, batches, cell types, or datasets? |
| metric | Does the metric match the biological question? |
| evidence | Does the model help beyond a simpler method? |
| interpretability | Are explanations validated? |
| deployment | Are cost, access, privacy, and reproducibility addressed? |

## What To Watch Next

The next useful wave will not be models that merely sound general. It will be models that prove usefulness on specific biological tasks, under realistic validation, against strong baselines, with enough transparency for scientists to trust and inspect.

## Credits and References

- Foundation models in bioinformatics review: https://pmc.ncbi.nlm.nih.gov/articles/PMC11900445/
- Single-cell foundation models review: https://www.nature.com/articles/s12276-025-01547-5
- Benchmarking DNA foundation models: https://www.nature.com/articles/s41467-025-65823-8
- BioLLM standardized framework: https://www.cell.com/patterns/fulltext/S2666-3899(25)00174-6
- Biology-driven benchmark of single-cell foundation models: https://pmc.ncbi.nlm.nih.gov/articles/PMC12492631/
- Awesome single-cell foundation model papers: https://github.com/OmicsML/awesome-foundation-model-single-cell-papers
- Hugging Face model hub: https://huggingface.co/models
- Papers with Code: https://paperswithcode.com/
