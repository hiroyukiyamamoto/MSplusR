\name{filter_intensity_matrix}
\alias{filter_intensity_matrix}
\title{Filter, Binarize, and Optionally Apply IDF Weighting}
\description{
Filter a spectral intensity matrix, normalize each spectrum by its base peak,
optionally binarize the matrix, and optionally apply IDF-only weighting.
}
\usage{
filter_intensity_matrix(
  input_file,
  output_file = "X_filtered.rds",
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  binarize = TRUE,
  weighting_method = c("none", "idf_only"),
  return_idf = FALSE
)
}
\arguments{
  \item{input_file}{
    Path to the input file containing \code{X0}. The object is loaded with
    \code{load()}.
  }
  \item{output_file}{
    Path to the output file where the processed matrix will be saved.
  }
  \item{intensity_threshold}{
    Absolute intensity threshold. Values below this threshold are set to 0.
  }
  \item{normalization_threshold}{
    Relative intensity threshold after row-wise base-peak normalization.
    Values below this threshold are set to 0.
  }
  \item{binarize}{
    Logical. If \code{TRUE}, all non-zero values are replaced with 1.
  }
  \item{weighting_method}{
    Weighting applied after filtering. Use \code{"none"} for plain filtered
    data or \code{"idf_only"} for inverse document frequency weighting.
  }
  \item{return_idf}{
    Logical. If \code{TRUE}, return a list containing the processed matrix and
    IDF-related vectors.
  }
}
\details{
The function performs the following steps:
\itemize{
  \item Sets values below \code{intensity_threshold} to 0.
  \item Normalizes each spectrum by its maximum intensity.
  \item Sets values below \code{normalization_threshold} to 0.
  \item Optionally binarizes the matrix.
  \item Optionally applies IDF-only weighting using
  \code{log((N + 1) / (df + 1)) + 1}.
}
The processed matrix is saved with \code{save()} and can therefore be loaded
later with \code{load()}.

For the current recommended PCA workflow, a typical setting is:
\itemize{
  \item \code{binarize = TRUE}
  \item \code{weighting_method = "idf_only"}
  \item \code{intensity_threshold = 1000}
  \item \code{normalization_threshold = 0.01}
}
}
\value{
If \code{return_idf = FALSE}, a numeric matrix.

If \code{return_idf = TRUE}, a list with:
\itemize{
  \item \code{X}: processed matrix
  \item \code{df}: document frequency vector, or \code{NULL}
  \item \code{idf}: IDF vector, or \code{NULL}
  \item \code{weighting_method}: selected weighting method
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

# Recommended preprocessing for the PCA + UMAP route
res <- filter_intensity_matrix(
  input_file = spectra_file,
  output_file = filtered_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  binarize = TRUE,
  weighting_method = "idf_only",
  return_idf = TRUE
)

str(res)
}
\seealso{
\code{\link{process_similarity_matrix}}, \code{\link{pca_umap_analysis}}
}
\keyword{spectral}
\keyword{filtering}
\keyword{normalization}
\keyword{preprocessing}
