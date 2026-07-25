metadata <- read.delim("metadata_design_examples.tsv", stringsAsFactors = TRUE)

show_design <- function(title, formula, rows) {
  cat("\n", title, "\n", sep = "")
  cat(strrep("-", nchar(title)), "\n", sep = "")
  subset_metadata <- droplevels(metadata[rows, ])
  if (all(subset_metadata$condition %in% c("control", "treated"))) {
    subset_metadata$condition <- factor(subset_metadata$condition, levels = c("control", "treated"))
  }
  if (all(subset_metadata$condition %in% c("before", "after"))) {
    subset_metadata$condition <- factor(subset_metadata$condition, levels = c("before", "after"))
  }
  print(subset_metadata[, c("sample_id", "condition", "batch", "patient")], row.names = FALSE)
  cat("\nDesign formula: ", deparse(formula), "\n", sep = "")
  print(model.matrix(formula, data = subset_metadata))
}

simple_rows <- metadata$sample_id %in% c(
  "control_rep1", "control_rep2", "control_rep3",
  "treated_rep1", "treated_rep2", "treated_rep3"
)

paired_rows <- metadata$sample_id %in% c(
  "patient01_before", "patient01_after",
  "patient02_before", "patient02_after",
  "patient03_before", "patient03_after"
)

show_design(
  "Simple condition-only design",
  ~ condition,
  simple_rows
)

show_design(
  "Batch-adjusted design",
  ~ batch + condition,
  simple_rows
)

show_design(
  "Paired patient design",
  ~ patient + condition,
  paired_rows
)

cat("\nTakeaway\n--------\n")
cat("The design formula becomes a design matrix. DESeq2 tests coefficients from this matrix.\n")
cat("If the formula does not match the experiment, the p-values answer the wrong question.\n")
