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
