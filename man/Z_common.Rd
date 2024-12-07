\name{Z_common}
\docType{data}
\alias{Z_common}
\title{Graph Adjacency Matrix Based on Common Peaks in Spectral Data}
\description{
This dataset contains a graph adjacency matrix representing similarities between spectra based on the number of common peaks. The matrix is used for graph-based clustering, dimensionality reduction, or visualization of spectral data.
}
\usage{
data(Z_common)
}
\format{
An RDS file containing a sparse matrix named \code{Z_sparse} or a dense matrix named \code{Z}:
\describe{
  \item{Rows:}{Spectra or samples.}
  \item{Columns:}{Spectra or samples (same as rows).}
  \item{Values:}{Non-negative integers representing the number of common peaks between pairs of spectra. A value of \code{0} indicates no connection.}
}
}
\details{
This adjacency matrix was derived from spectral intensity data (\code{X}) by calculating the number of common peaks between spectra. Peaks were considered common if their intensities exceeded a threshold. The adjacency matrix is symmetric, with diagonal elements set to \code{0}.
}
\source{
Derived from spectral intensity data (\code{X_pca.rds}) for metabolomics analysis of \emph{Chlamydomonas reinhardtii}.
}
\examples{
# Load the graph adjacency matrix
file_path <- system.file("extdata", "Z_common.rds", package = "YourPackageName")
load(file_path)

# View the structure of the adjacency matrix
str(Z)

# Example: Visualize the graph structure
library(igraph)
graph <- graph.adjacency(as.matrix(Z), mode = "undirected", weighted = TRUE)
plot(graph, vertex.size = 5, vertex.label = NA, edge.width = E(graph)$weight,
     main = "Graph Representation of Spectral Similarity")
}
\seealso{
\code{\link[Matrix]{Matrix}}, \code{\link[igraph]{graph.adjacency}}
}
\keyword{datasets}
\keyword{graph}
\keyword{spectral}
\keyword{similarity}
\keyword{metabolomics}
