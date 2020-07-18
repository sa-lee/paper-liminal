## ----init-----------------------------------------------------------
suppressPackageStartupMessages(library(scater))
suppressPackageStartupMessages(library(scran))
library(liminal)
library(ggplot2)
source(here::here("scripts", "helpers.R"))

sce <- scRNAseq::MacoskoRetinaData(ensembl = TRUE)
# annotation ensembl database
anno_db <- AnnotationHub::AnnotationHub()[["AH73905"]] 
anno <- AnnotationDbi::select(anno_db, 
               keys=rownames(sce), 
               keytype="GENEID", columns=c("SYMBOL", "SEQNAME", "GENEBIOTYPE"))
rowData(sce) <- anno[match(rownames(sce), anno$GENEID), ]


## ----qc-------------------------------------------------------------
is.mito <- grepl("^mt-", rowData(sce)$SYMBOL)
qcstats <- perCellQCMetrics(sce, subsets=list(Mito=is.mito))
filtered <- quickPerCellQC(qcstats, percent_subsets="subsets_Mito_percent")
sce <- sce[, !filtered$discard]

## ----normalise-counts-----------------------------------------------
sce <- logNormCounts(sce)

## ----gene-selection-------------------------------------------------
dec <- modelGeneVar(sce) # fits mean-variance trend using `nls`.
hvg <- getTopHVGs(dec, prop=0.1) # selects ~10% of nrow(sce) that are HVGs



## ----pca------------------------------------------------------------
sce <- runPCA(sce, ncomponents = 25, subset_row = hvg)
# looking at elbow-plot looks like we get the first five PCs explain most of the 
# variation
var_explained <- tidy_var_explained(sce)
ggplot(var_explained, aes(x = component, y = var_explained)) +
  geom_point()

## ----cluster--------------------------------------------------------
# the recommended workflow is to use graph based clustering on the principal 
# components
g <- buildSNNGraph(sce, use.dimred = 'PCA')
colData(sce)$cluster_membership <- factor(igraph::cluster_louvain(g)$membership)

# extract PCs to tour and perform tSNE on, keep cluster labels too
pc_df <- reducedDim(sce, "PCA")
pc_df <- dplyr::as_tibble(pc_df)
pc_df$cluster_membership <- colData(sce)$cluster_membership
pc_df$inx <- seq_len(nrow(pc_df))

table(colData(sce)$cluster_membership)

## ---- tsne
tsne <- Rtsne::Rtsne(reducedDim(sce, "PCA"),
                     pca = FALSE,
                     perplexity = 30)

tsne_df <- tidy_tsne(tsne, list(cluster_membership = pc_df$cluster_membership))


library(dplyr)
set.seed(119460)
tour_data <- pc_df %>% 
  group_by(cluster_membership) %>% 
  sample_frac(size = 0.1) %>% 
  ungroup()

embed_data <-  tsne_df %>% 
  slice(tour_data$inx)

limn_tour_link(embed_data, 
               dplyr::select(tour_data, PC1:PC5, cluster_membership),
               embed_color = cluster_membership,
               tour_color = cluster_membership
)

# ---

markers <- findMarkers(sce, 
                       groups = colData(sce)$cluster_membership,
                       direction = "up",
                       lfc = 1,
                       pval.type = "some")

marker_genes <- markers[[2]]

sub_sce <- sce[rownames(sce) %in% rownames(marker_genes)[1:10]]

exprs <- t(logcounts(sub_sce))
colnames(exprs) <- rowData(sub_sce)$SYMBOL

tour_marker <- dplyr::bind_cols(
  dplyr::as_tibble(as.matrix(exprs)),
  cluster_membership = colData(sub_sce)$cluster_membership
) %>% 
  janitor::clean_names() %>% 
  slice(tour_data$inx)

limn_tour(tour_marker, 1:10, color = cluster_membership)
