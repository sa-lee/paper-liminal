Dear editor and reviewers,

We would like to thank for your thorough reviews of our manuscript and
appreciate your constructive criticisms.

In the following response, I would like to address each of your comments
and highlight the amendments we have made to the manuscript and the liminal software.

# Reviewer A

> Unfortunately, I was not able to run the provided code. My guess is that there is some incompatibility with the newest R-version 4-0-3. Please check!

This was a problem with a newer version of the tourr package causing liminal
to not animate the tour correctly. It has been fixed and the package is now 
available on CRAN and has been tested against several versions of R.

> Minor remarks 

These have all been amended in the text.


# Reviewer B

> For example, the various clusters came pre-colored.  I would like to see a little more about how the analyst would identify these clusters, especially in a case such as your tree example where it doesn't appear that you would have the coloring/clustering you have without a priori knowledge of the different branches.  Is it possible to create that clustering starting from the tour or the embedding?

- spin and brush (GGobi book)
- add a few sentences



> Would it be worthwhile to link a pairwise scatterplot matrix for all or a subset of the original variables or components so as to be able to relate clusters and other features via brushing back to those variables for interpretation?  I guess the biplot in Figure 7 may be intended to show something similar?  Is it possible to expand and clarify your results from this figure a bit for those of us who are not genomics specialists?


