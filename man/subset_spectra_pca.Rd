\name{subset_spectra_pca}
\docType{data}
\alias{subset_spectra_pca}
\title{Subset of Spectral Data Used for PCA and UMAP Analysis}
\description{
This dataset contains a subset of spectral data that was used for PCA and UMAP analysis. The subset was derived by filtering out rows (spectra) with all intensity values equal to zero and retaining relevant columns based on variability.
}
\usage{
data(subset_spectra_pca)
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
This dataset is a subset of the original spectral data (\code{X0}) obtained after preprocessing steps, such as:
\itemize{
  \item Removing rows where all intensity values are \code{0}.
  \item Filtering columns with zero variance.
}
The resulting matrix was used for PCA to calculate principal components and subsequently for UMAP dimensionality reduction.
}
\source{
Derived from the original spectral data (\code{Posi_Ida_Chlamydomonas_1_spec.rds}) used in metabolomics analysis of \emph{Chlamydomonas reinhardtii}.
}
\examples{
# Load the subset spectral data
file_path <- system.file("extdata", "subset_spectra_pca.rds", package = "YourPackageName")
load(file_path)

# View the structure of the dataset
str(subset_spectra)

# Example: Summarize the data
summary(subset_spectra)
}
\seealso{
\code{\link[stats]{prcomp}}, \code{\link[uwot]{umap}}, \code{\link[base]{load}}
}
\keyword{datasets}
\keyword{metabolomics}
\keyword{spectral}
