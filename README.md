
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Casting multiple shadows: interactive data visualisation with tours and embeddings

> There has been a rapid uptake in the use of non-linear dimensionality
> reduction (NLDR) methods such as t-distributed stochastic neighbour
> embedding (t-SNE) in the natural sciences as part of cluster
> orientation and dimension reduction workflows. The appropriate use of
> these methods is made difficult by their complex parameterisations and
> the multitude of decisions required to balance the preservation of
> local and global structure in the resulting visualisation. We present
> visual diagnostics for the pragmatic usage of NLDR methods by
> combining them with a technique called the tour. A tour is a sequence
> of interpolated linear projections of multivariate data onto a lower
> dimensional space. The sequence is displayed as a dynamic
> visualisation, allowing a user to see the shadows the high-dimensional
> data casts in a lower dimensional view. By linking the tour to a view
> obtained from an NLDR method, we can preserve global structure and
> through user interactions like linked brushing observe where the NLDR
> view may be misleading. We display several case studies from both
> simulated and real data from single cell transcriptomics, that shows
> our approach is useful for cluster orientation tasks. The
> implementation of our framework is available as an R package called
> **liminal** available at <https://github.com/sa-lee/liminal>.

## Reproducibility

Package dependencies for the case studies can be installed with the
**BiocManager** package

``` r
# install.packages("BiocManager")
BiocManager::install("sa-lee/paper-liminal")
```

## Repo Structure

The case studies that produce the videos and still images found in the
paper can be reproduced in R via running the files found in the
`scripts` directory.

    R> .
    R> ├── DESCRIPTION
    R> ├── README.Rmd
    R> ├── README.md
    R> ├── data
    R> │   └── qd.rds
    R> ├── img
    R> ├── paper-liminal.Rproj
    R> ├── paper.Rmd
    R> ├── paper.tex
    R> ├── scripts
    R> │   ├── figures.R
    R> │   ├── helpers.R
    R> │   ├── liminal-gaussian.R
    R> │   ├── liminal-mouse.R
    R> │   ├── liminal-quickdraw.R
    R> │   └── liminal-trees.R
    R> ├── template
    R> │   ├── JDSSV_editorialprocess.tex
    R> │   └── jdssv_template.tex
    R> └── video
    R>     ├── liminal-gaussian.mov
    R>     ├── liminal-hierachical.mov
    R>     ├── liminal-mouse-01.mov
    R>     ├── liminal-mouse-02.mov
    R>     ├── liminal-trees-01.mov
    R>     └── liminal-trees-02.mov
