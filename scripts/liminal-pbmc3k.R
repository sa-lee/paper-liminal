## ---- include = FALSE------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----setup-----------------------------------------
library(TENxPBMCData)
library(scater)
library(scran)

pbmc3k <- TENxPBMCData("pbmc3k")
pbmc3k


## ----qc--------------------------------------------
is.mito <- grep("MT", rowData(pbmc3k)$Symbol_TENx)
stats <- perCellQCMetrics(pbmc3k, subsets=list(Mito=is.mito))
high.mito <- isOutlier(stats$subsets_Mito_percent, nmads=3, type="higher")
pbmc3k <- pbmc3k[,!high.mito]


## --------------------------------------------------
pbmc3k <- logNormCounts(pbmc3k)


## --------------------------------------------------
dec3k <- modelGeneVar(pbmc3k)
chosen.hvgs <- which(dec3k$bio > 0)


## --------------------------------------------------
set.seed(2099)
pbmc3k <- runPCA(pbmc3k, 
                 ncomponents = 15,
                 subset_row = chosen.hvgs,
                 BSPARAM = BiocSingular::RandomParam(),
                 name = "pca")

set.seed(1999)
pbmc3k <- runTSNE(pbmc3k,
                  subset_row = chosen.hvgs,
                  perplexity = 30,
                  name = "tsne")


## --------------------------------------------------
g <- buildSNNGraph(pbmc3k, k=15, use.dimred = 'pca')
clust <- igraph::cluster_louvain(g)
pbmc3k$cluster <- factor(igraph::membership(clust))



## ----flatten---------------------------------------
tsne_tbl <- data.frame(
  tsne_x = reducedDim(pbmc3k, "tsne")[,1],
  tsne_y = reducedDim(pbmc3k, "tsne")[,2],
  cluster = pbmc3k$cluster
)

express <- t(logcounts(pbmc3k)[chosen.hvgs,])
colnames(express) <- rowData(pbmc3k)[chosen.hvgs, "Symbol_TENx"]
express <- as.data.frame(express)
tsne_tbl <- dplyr::bind_cols(
  tsne_tbl,
  express
)


## --------------------------------------------------
library(liminal)
limn_xy(tsne_tbl, x= tsne_x, y = tsne_y, color = cluster)


## --------------------------------------------------
limn_xycol(tsne_tbl, 
           x = tsne_x, y = tsne_y, 
           colors = c(CD79A, MS4A1, CD8A, CD8B, LYZ))


## ---- eval = FALSE---------------------------------
## limn_tbl <- dplyr::bind_cols(
##   as.data.frame(reducedDim(pbmc3k, "pca")),
##   cluster = pbmc3k$cluster
## )
## limn_tour(limn_tbl, PC1:PC10, color = cluster)


## ---- eval = FALSE---------------------------------
## limn_tour_xylink(dplyr::select(limn_tbl, PC1:PC10, cluster),
##                  tsne_tbl,
##                  x_color = cluster,
##                  y_color = cluster
## )

