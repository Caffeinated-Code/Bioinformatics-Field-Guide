counts <- data.frame(
  gene_id = c("GENE_LONG_HIGH", "GENE_SHORT_HIGH", "GENE_LOW", "GENE_ZERO_HEAVY"),
  length_bp = c(4000, 1000, 2000, 1500),
  control_1 = c(1200, 600, 12, 0),
  control_2 = c(900, 700, 15, 1),
  treated_1 = c(2400, 650, 20, 0),
  treated_2 = c(2600, 800, 18, 2),
  check.names = FALSE
)

sample_cols <- c("control_1", "control_2", "treated_1", "treated_2")
length_kb <- counts$length_bp / 1000
library_sizes <- colSums(counts[, sample_cols])

round_sample_columns <- function(x, digits = 2) {
  x[, sample_cols] <- round(x[, sample_cols], digits)
  x
}

fpkm <- counts
fpkm[, sample_cols] <- sweep(
  sweep(counts[, sample_cols], 1, length_kb, "/"),
  2,
  library_sizes / 1e6,
  "/"
)

rpk <- sweep(counts[, sample_cols], 1, length_kb, "/")
tpm <- counts
tpm[, sample_cols] <- sweep(rpk, 2, colSums(rpk) / 1e6, "/")

size_factors <- library_sizes / exp(mean(log(library_sizes)))
normalized <- counts
normalized[, sample_cols] <- sweep(counts[, sample_cols], 2, size_factors, "/")

log_normalized <- normalized
log_normalized[, sample_cols] <- log2(log_normalized[, sample_cols] + 1)

z_scores <- log_normalized
z_scores[, sample_cols] <- t(scale(t(log_normalized[, sample_cols])))

cat("\nRaw counts\n----------\n")
print(counts, row.names = FALSE)
cat("\nLibrary sizes\n-------------\n")
print(library_sizes)
cat("\nApproximate size factors\n------------------------\n")
print(round(size_factors, 3))
cat("\nFPKM\n----\n")
print(round_sample_columns(fpkm), row.names = FALSE)
cat("\nTPM\n---\n")
print(round_sample_columns(tpm), row.names = FALSE)
cat("\nDESeq2-style normalized counts, simplified\n------------------------------------------\n")
print(round_sample_columns(normalized), row.names = FALSE)
cat("\nlog2(normalized count + 1)\n--------------------------\n")
print(round_sample_columns(log_normalized), row.names = FALSE)
cat("\nPer-gene z-scores from log-normalized counts\n--------------------------------------------\n")
print(round_sample_columns(z_scores), row.names = FALSE)
