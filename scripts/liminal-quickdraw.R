## ----init--------------------------------------------------------------------
library(dplyr)
library(liminal)
# remotes::install_github("huizezhang-sherry/quickdraw")
library(quickdraw)
source(here::here("scripts", "helpers.R"))

## ----check-cache--------------------------------------------------------------
has_run <- file.exists(here::here("data", "qd.rds"))

## ----download-categories-----------------------------------------------------
if (!has_run) {
  animals <- c("cat", "dog", "octopus", "spider", "whale")
  # download and cache
  for (a in animals) {
    qd_download(a)
    qd_download_bitmap(a)
  }
  # read and slice sample meta
  set.seed(4099)
  slabs <- lapply(animals, slice_image_meta)
  row_nums <- lapply(slabs, function(slab) slab[["row_number"]])
  # extract bitmaps as matrices
  bits <- mapply(slice_bitmap, 
                 a = animals, 
                 row_number = row_nums, 
                 SIMPLIFY = FALSE)
  # bind as a single data frame
  slabs <- dplyr::bind_rows(slabs)
  bits <- dplyr::bind_rows(bits)
  drawings <- dplyr::bind_cols(slabs, bits)
  # save results
  saveRDS(drawings, file = here::here("data/qd.rds"))
}

## ----load-cache--------------------------------------------------------------
drawings <- readRDS(here::here("data/qd.rds"))


# normalise the pixel intensities for each image by centering each
# image by their average pixel intensity 
px_mat <- as.matrix(select(drawings, starts_with("px")))
px_means <- rowMeans(px_mat)
px_norm <- sweep(px_mat, 1, px_means)

# Sphere the images by taking the SVD of covariance matrix
# this removes covariance between pixels
# px_cov <- tcrossprod(px_norm) / ncol(px_norm)
# svals <- svd(px_cov)
# px_rot <-
#   diag(1 / (sqrt(svals$d) + 1e-5)) %*%
#   crossprod(svals$u, px_norm)


colnames(px_norm) <- paste0("norm_", colnames(px_norm))

drawings <- bind_cols(drawings, as_tibble(px_norm))

# default t-SNE does not split the categories
set.seed(5099)
tsne <- Rtsne::Rtsne(select(drawings, starts_with("norm_px")),
                     pca_center = FALSE, 
                     normalize = FALSE)
tsne_df <- tidy_tsne(tsne, list(animal = drawings$word))

# cat-dog gradient is spread through the other animal categories
limn_xy(tsne_df, x = x , y = y, color = animal)


# try the PCA initialisation trick
qd_pca <- prcomp(select(drawings, starts_with("norm_px")),
                 center = FALSE)

# bind the PCs to the drawings
drawings_pcs <- bind_cols(drawings,as_tibble(qd_pca$x))

# PCA plot, blobby like the tSNE view
limn_xy(drawings_pcs, x = PC1, y = PC2, color = word)

qd_var_explained <- tidy_var_explained(qd_pca)

# a lot of variability left unexplained by PCA, 
limn_xy(qd_var_explained, x = component, y = var_explained)

# look at tour, looks like each category forms a face of cube?
limn_tour(drawings_pcs, PC1:PC20, color = word)

rf_data <- select(drawings, word, starts_with("norm_px")) %>% 
  mutate(word = factor(word)) %>% 
  as.data.frame()
rf <- randomForest::randomForest(word ~ . , data = rf_data)

# try tSNE again this time scaling initialising at first two PCs
y_init <- clamp_sd(as.matrix(select(drawings_pcs, PC1, PC2)), 
                   sd = 1e-4)

qd_tsne <- Rtsne::Rtsne(
  select(drawings_pcs, starts_with("norm_px")),
  pca_center = FALSE,
  Y_init = y_init,
  perplexity = 5,
  max_iter = 5000
)

qd_tsne_df <- tidy_tsne(qd_tsne, list(animal = drawings$word))

limn_xy(qd_tsne_df, x = x , y = y, color = animal)

# limn_tour_xylink(x = select(drawings_pcs, PC1:PC20, animal = word),
#                  y = qd_tsne_df,
#                  x_color = animal, 
#                  y_color = animal)


# # try a projection pursuit guided tour
# pda_inx <- tourr::guided_tour(tourr::pda_pp(drawings_pcs$word), d = 2)
# limn_tour(drawings_pcs, PC1:PC10, color = word, pda_inx)

