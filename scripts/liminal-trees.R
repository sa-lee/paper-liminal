## ----init-----------------------------------------------------------
library(liminal)
dim(fake_trees)
library(cowplot)
library(ggplot2)

tree_img <- ggdraw() + 
  draw_image(here::here("img", "tree.png"), scale = 0.8) +
  draw_figure_label("Tree Structure", position = "bottom.right") +
  theme_void()


## ----pc-view--------------------------------------------------------
pcs  <- prcomp(fake_trees[, -ncol(fake_trees)])
# var explained
summary(pcs)$importance[3,1:12]

## ----pca-xy---------------------------------------------------------
fake_trees <- dplyr::bind_cols(fake_trees, as.data.frame(pcs$x))

pca_xy <- ggplot(fake_trees, aes(x = PC1, y = PC2, color = branches)) +
  geom_point() +
  scale_color_manual(values = limn_pal_tableau10()) +
  labs(caption = "PCA") +
  theme(aspect.ratio = 1) +
  theme_void() 

## ----tsne-xy--------------------------------------------------------
set.seed(2099)
tsne <- Rtsne::Rtsne(dplyr::select(fake_trees, dplyr::starts_with("dim")))

tsne_df <- data.frame(tsneX = tsne$Y[,1],
                      tsneY = tsne$Y[,2],
                      branches = fake_trees$branches)

tsne_xy  <- ggplot(tsne_df, aes(x = tsneX, y = tsneY, color = branches)) +
  geom_point() +
  scale_color_manual(values = limn_pal_tableau10()) + 
  guides(color = FALSE) +
  labs(caption = "tSNE") +
  theme(aspect.ratio = 1) +
  theme_void() 

## ----tour----------------------------------------------------------

# now together
limn_tour_link(
  tour_data = dplyr::select(fake_trees, PC1:PC12, branches),
  embed_data = tsne_df,
  embed_color = branches,
  tour_color = branches
)



## ----pca-init--------------------------------------------------------
tsne_v2 <- Rtsne::Rtsne(
  dplyr::select(fake_trees, dplyr::starts_with("dim")),
  Y_init = clamp_sd(as.matrix(dplyr::select(fake_trees, PC1,PC2)), sd = 1e-4),
  perplexity = 100
)



tsne_v2_df <- data.frame(
  tsneX = tsne_v2$Y[,1], 
  tsneY = tsne_v2$Y[,2], 
  branches = fake_trees$branches
)

tsne_xy_v2  <- ggplot(tsne_v2_df, aes(x = tsneX, y = tsneY, color = branches)) +
  geom_point() +
  scale_color_manual(values = limn_pal_tableau10()) + 
  guides(color = FALSE) +
  labs(caption = "tSNE (PCA initialised)") +
  theme(aspect.ratio = 1) +
  theme_void() 


clean_fig <- plot_grid(
  tree_img, 
  pca_xy,
  tsne_xy,
  tsne_xy_v2,
  ncol = 2, 
  labels = "auto"
)

ggsave2(here::here("img", "tree-view.png"), plot = clean_fig)

## --arrange---------

limn_tour_link(
  tour_data = dplyr::select(fake_trees, PC1:PC12, branches),
  embed_data = tsne_v2_df,
  tour_color = branches,
  embed_color = branches
)

