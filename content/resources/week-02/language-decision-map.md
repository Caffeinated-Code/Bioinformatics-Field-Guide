# Bioinformatics Language Decision Map

Use this as a quick guide when choosing what to learn or use for a project.

| Task | Start with | Good enough when you can... |
|---|---|---|
| Navigate folders and inspect large files | Bash | Use paths, `head`, `wc`, `grep`, pipes, and command help safely |
| Clean metadata and automate repetitive work | Python | Read a table, clean columns, write a script, and save outputs |
| Run statistical genomics workflows | R | Join metadata, run a documented package, and explain the model input |
| Check sample sheets and study metadata | SQL | Filter, group, join, and find duplicated or missing sample labels |
| Re-run analyses across many samples | Nextflow or Snakemake | Define inputs, outputs, software environment, and reproducible steps |

## Simple Rule

- Use Bash to move.
- Use Python to build.
- Use R to model.
- Use SQL to check metadata.
- Use workflow tools to repeat.

## Four-Week Starter Plan

| Week | Goal | Tiny project |
|---|---|---|
| 1 | Bash | Count rows, inspect FASTA or FASTQ-like files, summarize sample names |
| 2 | Python | Read a metadata table, clean columns, make one plot |
| 3 | R | Read a count matrix, join metadata, make a basic expression plot |
| 4 | SQL | Create two small tables and join samples to annotations |

## Self-Check

Before adding a new language or tool, ask:

1. What problem am I trying to solve?
2. What are the inputs and outputs?
3. Could I explain the tool's role in one sentence?
4. Can I rerun the same step tomorrow and get the same result?
