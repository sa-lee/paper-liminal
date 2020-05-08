## ----init-----------------------------------------------------------
library(scRNAseq)
library(scater)
library(scran)
sce <- MacoskoRetinaData()


## ----qc-------------------------------------------------------------
is.mito <- grepl("^MT-", rownames(sce))
qcstats <- perCellQCMetrics(sce, subsets=list(Mito=is.mito))
filtered <- quickPerCellQC(qcstats, percent_subsets="subsets_Mito_percent")
sce <- sce[, !filtered$discard]

## ----normalise-counts-----------------------------------------------
sce <- logNormCounts(sce)

## ----gene-selection-------------------------------------------------
dec <- modelGeneVar(sce) # fits mean-variance trend using `nls`.
hvg <- getTopHVGs(dec, prop=0.2) # selects ~20% of nrow(sce) that are HVGs

## ----pca------------------------------------------------------------
sce <- runPCA(sce, ncomponents = 50, subset_row = hvg)
# looking at elbow-plot looks like we get the first 10PCs explain most of the 
# variation
library(ggplot2)
ggplot(data.frame(x = 1:50,  y = attr(reducedDim(sce), "percentVar")), 
       aes(x,y)) + 
  geom_point() +
  labs(x = "Component", y =  "% Var Explained") +
  scale_x_continuous(breaks = seq(0, 50, by = 5))

## ----cluster--------------------------------------------------------
# the recommended workflow is to use graph based clustering on the principal 
# components
g <- buildSNNGraph(sce, use.dimred = 'PCA')
sce$cluster_membership <- factor(igraph::cluster_louvain(g)$membership)

# extract PCs to tour and perform tSNE on, keep cluster labels too
pc_df <- reducedDim(sce, "PCA")
pc_df <- dplyr::as_tibble(pc_df)
pc_df$cluster_membership <- sce$cluster_membership

dplyr::count(pc_df, cluster_membership)

## ---- tsne

