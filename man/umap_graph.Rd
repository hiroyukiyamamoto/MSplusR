\name{umap_graph}
\docType{data}
\alias{umap_graph}
\title{UMAP Results from Graph-Based Spectral Data Analysis}
\description{
This dataset contains the UMAP results obtained using a graph-based approach for dimensionality reduction on spectral data. The graph adjacency matrix was used to define relationships between spectra, and UMAP was applied to the graph structure.
}
\usage{
data(umap_graph)
}
\format{
An RDS file containing a matrix named \code{umap_result}:
\describe{
  \item{Rows:}{Samples or spectra.}
  \item{Columns:}{UMAP dimensions (typically 2 or more).}
  \item{Values:}{UMAP coordinates for each sample in the reduced-dimensional space.}
}
}
\details{
This dataset was created by constructing a graph adjacency matrix (\code{Z}) based on shared spectral peaks between samples. UMAP was then applied to the graph's structure to generate a low-dimensional embedding that preserves the graph relationships. This method is particularly useful for identifying clusters or patterns in the spectral data.
}
\source{
Derived from the graph adjacency matrix (\code{Z_common.rds}) and spectral data (\code{Posi_Ida_Chlamydomonas_1_spec.rds}) for metabolomics analysis of \emph{Chlamydomonas reinhardtii}.
}
\examples{
# Load the UMAP result
file_path <- system.file("extdata", "umap_graph.rds", package = "YourPackageName")
load(file_path)

# View the structure of the UMAP result
str(umap_result)

# Example: Visualize the UMAP embedding
plot(umap_result, pch = 16, col = "blue",
     xlab = "UMAP 1", ylab = "UMAP 2", main = "Graph-Based UMAP Projection")
}
\seealso{
\code{\link[uwot]{umap}}, \code{\link[Matrix]{Matrix}}, \code{\link[base]{load}}
}
\keyword{datasets}
\keyword{UMAP}
\keyword{graph}
\keyword{spectral}
\keyword{metabolomics}
\keyword{dimensionality reduction}
