# Bioinformatics Field Guide

**Bioinformatics Field Guide** is a practical, reproducible learning resource for bioinformatics. It is built for readers who want to move from setup and command-line confidence into real sequencing files, public data, and analysis decisions without getting lost in scattered tutorials.

[Read the published site](https://caffeinated-code.github.io/Bioinformatics-Field-Guide/) · [Open the content folder](content/) · [Use the resources](content/resources/)

## Why This Exists

Bioinformatics is full of invisible failure points: mismatched genome builds, confusing file formats, missing metadata, fragile environments, and tools that work only when every prerequisite is just right.

This project turns those rough edges into guided, testable lessons:

- short articles with plain-language explanations
- runnable commands with expected outputs
- tiny datasets for safe practice
- reproducible Conda, Docker, notebook, and script resources
- GitHub Discussions for reader questions and corrections

## Published Guides

| No. | Guide | What readers practice | Resources |
|---:|---|---|---|
| 01 | [Set Up Your Laptop For Bioinformatics](https://caffeinated-code.github.io/Bioinformatics-Field-Guide/week-01-laptop-setup-for-bioinformatics.html) | Conda, Docker, JupyterLab, VS Code, Ollama, BioChatter | [Week 1 resources](content/resources/week-01/) |
| 02 | [What Programming Languages Should A Bioinformatician Know?](https://caffeinated-code.github.io/Bioinformatics-Field-Guide/week-02-languages-for-bioinformatics.html) | Bash, Python, R, SQL, notebooks, AI-assisted learning | [Week 2 resources](content/resources/week-02/) |
| 03 | [The Bioinformatics File Types You Must Know](https://caffeinated-code.github.io/Bioinformatics-Field-Guide/week-03-bioinformatics-file-types.html) | FASTQ, SAM/BAM/CRAM, VCF, GTF/GFF, BED, bedGraph, bigWig, metadata | [Week 3 resources](content/resources/week-03/) |

Only published guides are listed here. Draft and future articles are intentionally hidden from this landing page until they are ready.

## Start Here

If you are new to bioinformatics:

1. Start with **Week 1** to set up a working environment.
2. Use **Week 2** to understand when to use Bash, Python, R, and SQL.
3. Spend extra time on **Week 3** because file literacy is where many real projects succeed or fail.

If you already work in bioinformatics, jump directly to Week 3 and run the file-format lab.

## Repository Structure

```text
content/
  posts/       Published article source files and drafts
  resources/   Conda files, notebooks, scripts, tiny datasets, and tutorial assets
assets/        Site CSS and JavaScript
templates/     Shared article template
```

## Reader Feedback

Each article supports GitHub-powered discussion through giscus. If something is unclear, incorrect, or missing, open a discussion from the article footer or suggest an edit through GitHub.

## Status

Published through **Week 3**. Future guides will be added only after review, testing, and cleanup.
