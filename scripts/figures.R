# pull screenshots together using cowplot
library(ggplot2)
library(cowplot)

draw_screenshot <- function(file) {
  ggdraw() + 
    draw_image(here::here("img", file), scale = 0.8) +
    theme_void()
}

enframe_screenshot <- function(lst) {
  plot_grid(plotlist = lst, 
            ncol = 2, 
            labels = "auto",
            align = "hv",
            axis = "t" )
}

case_fig <- function(case) {
  files <- list.files(here::here("img"), 
                      pattern = ".png$")
  
  files <- files[grep(paste0("^", case), files)]

  enframe_screenshot(lapply(files, draw_screenshot))
}

cases <- c("gaussian", 
           "hierarchical", 
           "trees-01", 
           "trees-02", 
           "mouse-01",
           "mouse-02")

for (case in cases) {
  fout <- paste0("liminal-screenshot-", case, ".png")
  pout <- case_fig(case)
  
  ggsave2(here::here("img", fout), plot = pout)
  
}
