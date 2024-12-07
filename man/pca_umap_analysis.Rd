\name{pca_umap_analysis}
\alias{pca_umap_analysis}
\title{PCA and UMAP Analysis for Spectral Data}
\description{
This function performs PCA and UMAP dimensionality reduction on spectral data. It filters the input data, computes principal components, applies UMAP, and saves the results to files.
}
\usage{
pca_umap_analysis(input_spectrum_file, input_filtered_file, 
                  output_umap_file = "umap_pca.rds", 
                  output_subset_file = "subset_spectra_pca.rds", 
                  pca_components = 10)
}
\arguments{
  \item{input_spectrum_file}{
    Path to the \code{.rds} file containing the original spectral data matrix (\code{X0}).
  }
  \item{input_filtered_file}{
    Path to the \code{.rds} file containing the filtered spectral data matrix (\code{X}).
  }
  \item{output_umap_file}{
    Path to the \code{.rds} file where the UMAP result will be saved. Default is \code{"umap_pca.rds"}.
  }
  \item{output_subset_file}{
    Path to the \code{.rds} file where the subset of the spectral data will be saved. Default is \code{"subset_spectra_pca.rds"}.
  }
  \item{pca_components}{
    Number of principal components to retain during PCA. Default is \code{10}.
  }
}
\details{
This function performs the following steps:
\itemize{
  \item Removes rows where all intensity values are \code{0}.
  \item Selects columns with non-zero standard deviation for PCA.
  \item Scales the data and computes principal components using the \code{irlba} package.
  \item Applies UMAP to the PCA scores for further dimensionality reduction.
  \item Extracts the subset of spectral data corresponding to the filtered rows.
  \item Saves the UMAP result and the subset of spectral data to the specified output files.
}
}
\value{
A list containing:
\itemize{
  \item \code{umap_result}: A matrix with the UMAP embedding.
  \item \code{subset_spectra}: A matrix with the subset of the spectral data used in the analysis.
}
}
\author{
Hiroyuki Yamamoto
}
\examples{
# Example usage:
# Define paths to input and output files
input_spectrum_file <- system.file("extdata", "example_spectrum.rds", package = "YourPackageName")
input_filtered_file <- system.file("extdata", "example_filtered.rds", package = "YourPackageName")
output_umap_file <- tempfile(fileext = ".rds")  # Temporary file for UMAP result
output_subset_file <- tempfile(fileext = ".rds")  # Temporary file for subset spectra

# Perform PCA and UMAP analysis
result <- pca_umap_analysis(
  input_spectrum_file = input_spectrum_file,
  input_filtered_file = input_filtered_file,
  output_umap_file = output_umap_file,
  output_subset_file = output_subset_file,
  pca_components = 10
)

# View results
print(result$umap_result)
print(result$subset_spectra)

# Note: Replace `YourPackageName` with the actual name of your package, and ensure
# that the files `example_spectrum.rds` and `example_filtered.rds` are included
# in your package's `inst/extdata` directory.
}
\seealso{
\code{\link[irlba]{irlba}}, \code{\link[uwot]{umap}}
}
\keyword{PCA}
\keyword{UMAP}
\keyword{dimensionality reduction}
\keyword{spectral}
