## ----init-----------------------------------------------------------
library(scater)
library(scran)
library(liminal)
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
sce <- runPCA(sce, ncomponents = 50, subset_row = hvg)
# looking at elbow-plot looks like we get the first ten PCs explain most of the 
# variation, with the elbow at five
var_explained <- tidy_var_explained(sce)
limn_xy(var_explained, x = component, y = var_explained)

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
tsne <- Rtsne::Rtsne(dplyr::select(pc_df, -cluster_membership),
                     pca = FALSE,
                     Y_init = clamp_sd(reducedDim(sce)[ , 1:2], sd = 1e-4)
                     perplexity = 30)


