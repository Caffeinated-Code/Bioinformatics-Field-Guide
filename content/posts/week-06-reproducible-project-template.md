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

## Why Structure Matters

Bioinformatics projects fail quietly when files are scattered, package versions are forgotten, and important decisions live only in notebook history.

A good project structure reduces memory load. It also makes the work easier to review, reuse, hand off, and defend.

## The Simple Template

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

This structure works for small projects and can grow into a workflow later.

## What Goes Where

| Folder | Purpose |
|---|---|
| `data/raw/` | Original input data, never edited by hand |
| `data/processed/` | Cleaned, filtered, or transformed data |
| `metadata/` | Sample sheets, data dictionaries, covariates |
| `notebooks/` | Exploration, explanation, and figures |
| `scripts/` | Reusable code |
| `results/` | Tables produced by analysis |
| `figures/` | Plots and diagrams |
| `docs/` | Methods notes, assumptions, decisions |

The rule: raw data stays raw. Every transformation should be reproducible.

## The README Should Answer Five Questions

1. What is the biological question?
2. What data is used?
3. How do I set up the environment?
4. How do I run the analysis?
5. Where are the main results?

If the README cannot answer those questions, the project is not ready for another person.

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

Use Git for code, documentation, environment files, small example data, and figures when useful.

Usually commit:

- scripts
- notebooks
- README files
- environment files
- small example data
- small result tables

Usually do not commit:

- huge FASTQ or BAM files
- protected human data
- temporary files
- credentials
- raw collaborator data

## A Useful `.gitignore`

```text
.DS_Store
__pycache__/
.ipynb_checkpoints/
data/raw/
data/large/
*.bam
*.fastq
*.fastq.gz
*.vcf.gz
*.log
.env
```

This keeps accidental clutter and sensitive files out of the repo.

## Save This: Minimum Reproducibility Checklist

| Check | Why it matters |
|---|---|
| README explains the question | prevents tool-first analysis |
| raw data is separated | protects original input |
| metadata is versioned | preserves sample meaning |
| environment is recorded | makes setup inspectable |
| scripts are reusable | avoids notebook-only logic |
| results are labeled | prevents mystery outputs |
| assumptions are written down | helps reviewers trust the work |

## Common Mistakes

- Keeping final results only in a notebook.
- Naming files `final_final_v3.csv`.
- Forgetting sample metadata.
- Committing private or protected data.
- Reusing the same environment for every project.
- Having no record of why parameters were chosen.

## What To Watch Next

Notebooks, scripts, and workflows all have a place. A practical pattern is:

```text
notebooks for exploration -> scripts for repeated logic -> workflows for repeated execution
```

Do not make the project more complex than the question requires. Do make it clear enough that another person can inspect it.

## Credits and References

- Git: https://git-scm.com/
- Conda documentation: https://docs.conda.io/
- Bioconda documentation: https://bioconda.github.io/
- Nextflow: https://www.nextflow.io/
- Snakemake: https://snakemake.readthedocs.io/
- The Turing Way: https://the-turing-way.netlify.app/
