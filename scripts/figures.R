# pull screenshots together using cowplot
library(ggplot2)
library(cowplot)

draw_screenshot <- function(file, scale = 1) {
  ggdraw() + 
    draw_image(here::here("img", file), scale = scale)
}

enframe_screenshot <- function(lst) {
  plot_grid(plotlist = lst, 
            nrow = 2, 
            labels = "auto",
            align = "hv",
            axis = "tblr" )
}

case_fig <- function(case, scale = 1) {
  files <- list.files(here::here("img"), 
                      pattern = ".png$")
  
  files <- files[grep(paste0("^", case), files)]

  enframe_screenshot(lapply(files, draw_screenshot, scale = scale))
}

cases <- c("gaussian", 
           "hierarchical", 
           "trees-01", 
           "trees-02", 
           "mouse-02")

for (case in cases) {
  fout <- paste0("liminal-screenshot-", case, ".png")
  pout <- case_fig(case)
  ggsave2(here::here("img", fout), plot = pout,
          height = 6, 
          width = 4)
}

# special case for `mouse-01`

mpout <- function() {
  files <- list.files(here::here("img"), 
                      pattern = ".png$")
  
  files <- files[grep(paste0("^", "mouse-01"), files)]
  lapply(files, draw_screenshot, scale = 1)
}

frames <- mpout()

pout <- plot_grid(plotlist = ,
          nrow = 4, align = "hv", axis = "tblr", 
          labels = "auto")

ggsave2(here::here("img", "liminal-screenshot-mouse-01.png"),
        plot = pout,
        height = 8,
        width = 4)

