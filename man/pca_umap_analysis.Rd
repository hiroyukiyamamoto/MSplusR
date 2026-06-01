\name{pca_umap_analysis}
\alias{pca_umap_analysis}
\title{PCA and UMAP Analysis for Spectral Data}
\description{
Perform PCA and UMAP dimensionality reduction on filtered spectral data.
}
\usage{
pca_umap_analysis(
  input_spectrum_file,
  input_filtered_file,
  output_umap_file = "umap_pca.rds",
  output_subset_file = "subset_spectra_pca.rds",
  pca_components = 10,
  umap_n_neighbors = 15,
  umap_min_dist = 0.01,
  scaling = FALSE,
  centering = TRUE
)
}
\arguments{
  \item{input_spectrum_file}{
    Path to the input file containing the original spectral matrix \code{X0}.
  }
  \item{input_filtered_file}{
    Path to the input file containing the filtered matrix \code{X}.
  }
  \item{output_umap_file}{
    Path to the output file where the UMAP result will be saved.
  }
  \item{output_subset_file}{
    Path to the output file where the retained spectra subset will be saved.
  }
  \item{pca_components}{
    Maximum number of principal components to retain.
  }
  \item{umap_n_neighbors}{
    Number of neighbors passed to \code{uwot::umap()}.
  }
  \item{umap_min_dist}{
    Minimum distance passed to \code{uwot::umap()}.
  }
  \item{scaling}{
    Logical. If \code{TRUE}, autoscaling is applied before PCA. The default is
    \code{FALSE}.
  }
  \item{centering}{
    Logical. If \code{TRUE}, mean centering is applied before PCA.
  }
}
\details{
The function removes all-zero spectra, removes zero-variance columns, performs
PCA with \code{irlba}, and then applies UMAP to the PCA scores.

The default is \code{scaling = FALSE}, which corresponds to no autoscaling.
For the current recommended workflow, this function is typically used after
\code{filter_intensity_matrix(..., weighting_method = "idf_only")}.
}
\value{
A list containing:
\itemize{
  \item \code{umap_result}: UMAP embedding
  \item \code{subset_spectra}: retained subset of \code{X0}
  \item \code{pca_scores}: PCA score matrix used for UMAP
  \item \code{settings}: a list of analysis settings
}
}
\author{
Hiroyuki Yamamoto
}
\examples{
# Bundled demo data
spectra_file <- system.file(
  "extdata",
  "Posi_Ida_Chlamydomonas_1_spec.rds",
  package = "MSplusR"
)

filtered_file <- tempfile(fileext = ".rds")
umap_file <- tempfile(fileext = ".rds")
subset_file <- tempfile(fileext = ".rds")

filter_intensity_matrix(
  input_file = spectra_file,
  output_file = filtered_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  binarize = TRUE,
  weighting_method = "idf_only"
)

res <- pca_umap_analysis(
  input_spectrum_file = spectra_file,
  input_filtered_file = filtered_file,
  output_umap_file = umap_file,
  output_subset_file = subset_file,
  pca_components = 10,
  scaling = FALSE,
  centering = TRUE
)

str(res$umap_result)
}
\seealso{
\code{\link[irlba]{irlba}}, \code{\link[uwot]{umap}},
\code{\link{filter_intensity_matrix}}
}
\keyword{PCA}
\keyword{UMAP}
\keyword{dimensionality reduction}
\keyword{spectral}
