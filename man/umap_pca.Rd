\name{umap_pca}
\docType{data}
\alias{umap_pca}
\title{UMAP Results from PCA Analysis of Spectral Data}
\description{
This dataset contains the UMAP results obtained after performing PCA on filtered spectral data. It represents a low-dimensional embedding of the spectral data that can be used for visualization or clustering.
}
\usage{
data(umap_pca)
}
\format{
An RDS file containing a matrix named \code{umap_result}:
\describe{
  \item{Rows:}{Samples or spectra.}
  \item{Columns:}{UMAP dimensions (usually 2 or more).}
  \item{Values:}{UMAP coordinates for each sample in the reduced-dimensional space.}
}
}
\details{
This dataset was created by first applying PCA to filtered spectral data (\code{X}) and then using the resulting PCA scores as input for UMAP dimensionality reduction. The UMAP embedding represents the spectral data in a low-dimensional space, preserving its local and global structure.
}
\source{
Derived from PCA analysis of \code{subset_spectra_pca.rds}, which was filtered from the original spectral data (\code{Posi_Ida_Chlamydomonas_1_spec.rds}).
}
\examples{
# Load the UMAP results
file_path <- system.file("extdata", "umap_pca.rds", package = "YourPackageName")
load(file_path)

# View the structure of the UMAP result
str(umap_result)

# Example: Visualize the UMAP result
plot(umap_result, pch = 16, col = "blue", 
     xlab = "UMAP 1", ylab = "UMAP 2", main = "UMAP Projection")
}
\seealso{
\code{\link[uwot]{umap}}, \code{\link[stats]{prcomp}}, \code{\link[irlba]{irlba}}
}
\keyword{datasets}
\keyword{UMAP}
\keyword{PCA}
\keyword{metabolomics}
\keyword{dimensionality reduction}
