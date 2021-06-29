Dear editor and reviewers,

We would like to thank for your thorough reviews of our manuscript and
appreciate your constructive criticisms.

In the following response, I would like to address each of your comments
and highlight the amendments we have made to the manuscript and the liminal software.

# Reviewer A

> Unfortunately, I was not able to run the provided code. My guess is that there is some incompatibility with the newest R-version 4-0-3. Please check!

This was a problem with a newer version of the tourr package causing liminal
to not animate the tour correctly. It has been fixed and the liminal package is now 
available on CRAN and has been tested against several versions of R on multiple
operating systems.

## Major remarks 

> The manuscript is well written and presents the approach in a balanced way. Despite
this, the goal and primary focus of the paper gets not always clear as it it switches focus
between presenting an enhancement of NLDR methods, presenting a better alternative to
NLDR methods for certain tasks (clustering) and describing the general functionality of
interactions with grand tour representations. A revision should clarify the goals of the
manuscript.
> Secondly, the relevance of having a cluster orientation task at hand seems relevant for
some arguments but not for others. Here also, the authors should clearly provide guidance
to the reader on which data and research contexts are essential for certain conclusions.

I have added comments to the abstract and throughout the manuscript
to clarify that the goal of the liminal interface is to both correct an embedding
(as shown in case study 2) and for clustering (case study 3). The discussion
also clarifies the goals of the method.

> Thirdly, the term high-dimensional data has gained fairly specfic meaning in some
contexts. Please clarify whether you use the term in its rather broad sense or whether you
want to allude particularly to small-N-large-p situations and their resulting conditions.

This has been clarified in the introduction. 

> Fourthly, the manuscript has been enhanced by links to video sequences of tour ani-
mations for the case studies. While these videos add a lot to the static description in the
papers, additional explanations to the videos (voice-over or captions) would further ease
the understanding of the animations and hence improve further the manuscript.

Thank you for the suggestion, I have now added descriptions and
captions and descriptions to all videos.

> Minor remarks 

These have all been amended in the text.


# Reviewer B

> For example, the various clusters came pre-colored.  I would like to see a little more about how the analyst would identify these clusters, especially in a case such as your tree example where it doesn't appear that you would have the coloring/clustering you have without a priori knowledge of the different branches.  Is it possible to create that clustering starting from the tour or the embedding?

This is possible, but we considered it out of scope for the paper to go into
specifics of how one would perform a cluster analysis. 
I've added some sentences to the main text about how one might go about using
the interface to generate clusters manually..  The GGobi book by the last author of the manuscript details how one might spin and brush using a tour, to 
build up a cluster analysis manually. 


> Would it be worthwhile to link a pairwise scatterplot matrix for all or a subset of the original variables or components so as to be able to relate clusters and other features via brushing back to those variables for interpretation?  I guess the biplot in Figure 7 may be intended to show something similar?  Is it possible to expand and clarify your results from this figure a bit for those of us who are not genomics specialists?

I have expanded what specific terms mean in the main text, to clarify the purposes
of this type of analysis and the graphic. Essentially marker genes are of interest
to biologists for determining signatures that represent cells. The biplot
on this view was intended to show how the relative expression of each gene could
differentiate between possible cell types (clusters). We didn't use a
scatterplot matrix here because it would be difficult to read with the large number
of variables. As the liminal interface is a shiny app, it could be hooked up to
other visualisations by the user.

Yours Sincerely,

Dr Stuart Lee