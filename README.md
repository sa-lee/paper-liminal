
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Casting multiple shadows: interactive data visualisation with tours and embeddings

`liminal` aims to increase the effective use of embeddings by combining
them with interactive and dynamic graphics (via the vegawidget and shiny
packages) and with a technique from multivariate stastics called the
tour (via the tourr package). Briefly, a tour is a sequence of
interploated projections of multivariate data onto lower dimensional
space. The sequence is displayed as a dynamic visualisation, and enables
us to see the shadows the high dimensional data makes in a lower
dimensional view. By combining the tour with embedding algorithms, we
can see the following:

1.  whether distances in the embedding view are meaningful
2.  the local and global structure of the data
3.  identify ‘interesting’ shapes or points in the data

## Outline

  - review of embedding algorithms, interactive graphics, tours
  - technology
  - design
  - examples/benchmarks
      - Kevin moon
      - pdfsense
      - single cell
      - quick draw
