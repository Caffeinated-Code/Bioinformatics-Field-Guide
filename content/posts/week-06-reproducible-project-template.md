---
title: "The Bioinformatics Project Template"
subtitle: "Folder structure, README, Git, Conda, and reproducibility"
week: 6
audience: ["practitioner", "researcher", "industry"]
reading_time: "7 minutes"
asset: "GitHub-ready project template"
---

# The Bioinformatics Project Template

**Takeaway:** A reproducible bioinformatics project is one where another person can find the data, understand the analysis, recreate the environment, rerun the code, and check the results.

## Prerequisites

Read Week 1 for setup, Week 2 for languages, and Week 5 for file types.

## Why Project Structure Matters

Bioinformatics projects fail quietly when files are scattered, package versions are forgotten, and analysis steps live only in notebook history. A good structure reduces memory load and makes review easier.

## A Simple Template

```text
project-name/
  README.md
  environment.yml
  .gitignore
  data/
    raw/
    processed/
  metadata/
  notebooks/
  scripts/
  results/
  figures/
  docs/
```

This structure works for small projects and can grow into a pipeline later.

## What Goes Where

| Folder | Purpose |
|---|---|
| `data/raw/` | Original input data, never edited by hand |
| `data/processed/` | Cleaned or transformed data |
| `metadata/` | Sample sheets and data dictionaries |
| `notebooks/` | Exploration and explanation |
| `scripts/` | Reusable code |
| `results/` | Tables produced by analysis |
| `figures/` | Plots and diagrams |
| `docs/` | Notes, methods, and decisions |

## The README Should Answer Five Questions

1. What is the biological question?
2. What data is used?
3. How do I set up the environment?
4. How do I run the analysis?
5. Where are the main results?

If the README cannot answer those questions, the project is not ready for someone else.

## Environment Files

Use an environment file so package versions are visible:

```yaml
name: bioinfo-project
channels:
  - conda-forge
  - bioconda
dependencies:
  - python=3.12
  - pandas
  - numpy
  - matplotlib
  - fastqc
```

This is not perfect reproducibility, but it is much better than "it worked on my laptop."

## Git Without Overcomplication

Use Git for code, documentation, and small metadata files. Do not commit large raw sequencing files unless there is a specific reason and the repository is designed for it.

Commit:
- scripts
- notebooks
- README files
- environment files
- small example data
- figures when useful

Do not usually commit:
- huge FASTQ or BAM files
- private human data
- temporary files
- credentials

## Common Mistakes

- Keeping final results only in a notebook.
- Using file names like `final_final_v3.csv`.
- Forgetting sample metadata.
- Committing private or protected data.
- Reusing the same environment for every project.
- Having no record of why parameters were chosen.

## What Experts Still Debate

Some groups prefer notebooks, others prefer scripts, and production teams prefer workflow systems. The practical answer is layered: notebooks for exploration, scripts for repeated logic, workflows for repeated execution.

## Research Gap

There is a need for more discipline-specific project templates. RNA-seq, single-cell, variant analysis, and spatial omics each need slightly different metadata fields, QC reports, and output conventions.

## Original Asset

Release a GitHub-ready starter template with:
- README scaffold.
- `environment.yml`.
- `.gitignore`.
- folder structure.
- example sample sheet.
- minimal Python and R sanity-check scripts.

## Credits and References

- Git: https://git-scm.com/
- Conda documentation: https://docs.conda.io/
- Bioconda documentation: https://bioconda.github.io/
- Nextflow: https://www.nextflow.io/
- Snakemake: https://snakemake.readthedocs.io/

## Expert Review Checklist

- Create the actual template before publication.
- Test setup from a clean folder.
- Add data privacy warning.
