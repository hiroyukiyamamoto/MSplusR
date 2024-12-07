\name{X_pca}
\docType{data}
\alias{X_pca}
\title{Filtered and Normalized Spectral Data for PCA}
\description{
This dataset contains filtered and normalized spectral data prepared for PCA analysis. The data was preprocessed to remove noise, normalize intensities, and apply a threshold to retain relevant features.
}
\usage{
data(X_pca)
}
\format{
An RDS file containing a matrix named \code{X}:
\describe{
  \item{Rows:}{Samples or spectra.}
  \item{Columns:}{m/z bins representing mass-to-charge ratios.}
  \item{Values:}{Binary values (\code{0} or \code{1}), indicating the presence or absence of signal intensity in each m/z bin.}
}
}
\details{
The dataset was derived from the original spectral data (\code{Posi_Ida_Chlamydomonas_1_spec.rds}) through the following preprocessing steps:
\itemize{
  \item Intensity values below a specified threshold (\code{1000}) were set to \code{0} to remove noise.
  \item Each spectrum (row) was normalized by dividing by its maximum intensity.
  \item Normalized intensity values below \code{0.01} were set to \code{0}.
  \item Remaining non-zero values were converted to \code{1}, resulting in a binary matrix.
}
The resulting matrix is suitable for PCA and other dimensionality reduction techniques.
}
\source{
Filtered and normalized from \code{Posi_Ida_Chlamydomonas_1_spec.rds}, experimental spectral data from metabolomics analysis of \emph{Chlamydomonas reinhardtii}.
}
\examples{
# Load the filtered spectral data
file_path <- system.file("extdata", "X_pca.rds", package = "YourPackageName")
load(file_path)

# View the structure of the filtered data
str(X)

# Example: Summarize the filtered data
summary(X)

# Example: Perform PCA
library(irlba)
result <- irlba(scale(X), nv = 10)
plot(result$v, main = "PCA on Filtered Spectral Data")
}
\seealso{
\code{\link[stats]{prcomp}}, \code{\link[base]{scale}}, \code{\link[irlba]{irlba}}
}
\keyword{datasets}
\keyword{PCA}
\keyword{spectral}
\keyword{metabolomics}
\keyword{preprocessing}
