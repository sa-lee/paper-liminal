## ----init--------------------------------------------------------------------
library(liminal)
# remotes::install_github("huizezhang-sherry/quickdraw")
library(quickdraw)

# downsample the number of images to have 500 images in each category
slice_image_meta <- function(a, size = 500L) {
  res <- qd_read(a)
  nr <- nrow(res)
  slice <- sample.int(nr, size)
  slab <- res[slice, , drop = FALSE]
  slab[["row_number"]] <- slice
  slab
}

slice_bitmap <- function(a, row_number) {
  res <- qd_read_bitmap(a)
  colnames(res) <- paste0("px", seq_len(ncol(res)))
  tibble::as_tibble(res[row_number, , drop = FALSE])
} 

tidy_tsne <- function(model, data) {
  enframe <- as.data.frame(model[["Y"]])
  colnames(enframe) <- c("x", "y", "z")[seq_len(ncol(enframe))]
  dplyr::bind_cols(enframe, data)
} 


## ----check-cache--------------------------------------------------------------
has_run <- file.exists(here::here("data/qd.rds"))

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

# default t-SNE does not split the categories
set.seed(5099)
tsne <- Rtsne::Rtsne(dplyr::select(drawings, dplyr::starts_with("px")))
tsne_df <- tidy_tsne(tsne, list(animal = drawings$word))

# cat-dog gradient is spread through the other animal categories
limn_xy(tsne_df, x = x , y = y, color = animal)

# try the PCA initialisation trick
qd_pca <- prcomp(dplyr::select(drawings, dplyr::starts_with("px")),
                 center = TRUE)

# bind the PCs to the drawings
drawings_pcs <- dplyr::bind_cols(drawings,dplyr::as_tibble(qd_pca$x))

# PCA plot, blobby like the tSNE view
limn_xy(drawings_pcs, x = PC1, y = PC2, color = word)

qd_var_explained <- data.frame(
  component = seq_len(length(qd_pca$sdev)),
  sd = qd_pca$sdev,
  var_explained = qd_pca$sdev^2 / sum(qd_pca$sdev^2),
  cum_var_explained = cumsum(qd_pca$sdev^2) / sum(qd_pca$sdev^2)
)

# a lot of variability unexplained by PCA, need quite a few PCs
limn_xy(qd_var_explained, x = component, y = cum_var_explained)


# try tSNE again this time scaling initialising at first two PCs
y_init <- clamp_sd(as.matrix(dplyr::select(drawings_pcs, PC1, PC2)), 
                   sd = 1e-4)

qd_tsne <- Rtsne::Rtsne(
  dplyr::select(drawings, dplyr::starts_with("px")),
  Y_init = y_init
)

qd_tsne_df <- tidy_tsne(qd_tsne, list(animal = drawings$word))

limn_xy(qd_tsne_df, x = x , y = y, color = animal)



limn_tour_xylink(x = dplyr::select(drawings_pcs, PC1:PC20, animal = word),
                 y = qd_tsne_df,
                 x_color = animal, 
                 y_color = animal)

