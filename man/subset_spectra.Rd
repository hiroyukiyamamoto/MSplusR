\name{subset_spectra}
\docType{data}
\alias{subset_spectra}
\title{Subset of Spectral Data Used in Graph-Based Analysis}
\description{
This dataset contains a subset of spectral data used for graph-based UMAP analysis. The subset was filtered based on graph adjacency matrix connectivity, retaining only the spectra connected in the graph.
}
\usage{
data(subset_spectra)
}
\format{
An RDS file containing a matrix named \code{subset_spectra}:
\describe{
  \item{Rows:}{Samples or spectra.}
  \item{Columns:}{m/z bins representing mass-to-charge ratios.}
  \item{Values:}{Intensity values for each m/z bin in each sample.}
}
}
\details{
This dataset was created by filtering the original spectral data (\code{X0}) based on the graph adjacency matrix (\code{Z}). Spectra that were not connected to any other spectra in the graph were removed. The resulting subset was used for UMAP dimensionality reduction in conjunction with graph-based similarity measures.
}
\source{
Derived from the original spectral data (\code{Posi_Ida_Chlamydomonas_1_spec.rds}) using the graph adjacency matrix (\code{Z_common.rds}) for filtering.
}
\examples{
# Load the subset spectral data
file_path <- system.file("extdata", "subset_spectra.rds", package = "YourPackageName")
load(file_path)

# View the structure of the dataset
str(subset_spectra)

# Example: Visualize a single spectrum
spectrum <- subset_spectra[1, ]
mz <- as.numeric(sub("\\-.*", "", colnames(subset_spectra)))  # Extract m/z values
plot(mz, spectrum, type = "h", col = "blue", 
     xlab = "m/z", ylab = "Intensity", main = "Spectrum for Sample 1")
}
\seealso{
\code{\link[uwot]{umap}}, \code{\link[base]{load}}, \code{\link[Matrix]{Matrix}}
}
\keyword{datasets}
\keyword{spectral}
\keyword{graph}
\keyword{UMAP}
\keyword{metabolomics}
