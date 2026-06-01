\name{process_similarity_matrix}
\alias{process_similarity_matrix}
\title{Build a Similarity Matrix from Spectral Data}
\description{
Filter spectral data, binarize it, optionally apply IDF-only weighting, and
compute a similarity matrix.
}
\usage{
process_similarity_matrix(
  input_file,
  output_file = "Z_common.rds",
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = c("none", "idf_only"),
  similarity_method = c("cosine", "common_peaks")
)
}
\arguments{
  \item{input_file}{
    Path to the input file containing \code{X0}.
  }
  \item{output_file}{
    Path to the output file where the similarity matrix will be saved.
  }
  \item{intensity_threshold}{
    Absolute intensity threshold. Values below this threshold are set to 0.
  }
  \item{normalization_threshold}{
    Relative intensity threshold after row-wise base-peak normalization.
  }
  \item{weighting_method}{
    Weighting applied after binarization. Use \code{"none"} or
    \code{"idf_only"}.
  }
  \item{similarity_method}{
    Similarity metric. Use \code{"common_peaks"} for weighted common-peak
    similarity or \code{"cosine"} for cosine similarity on the processed
    matrix.
  }
}
\details{
The function performs the following steps:
\itemize{
  \item Filters low-intensity values.
  \item Normalizes each spectrum by its maximum intensity.
  \item Removes values below the relative threshold.
  \item Binarizes the matrix.
  \item Optionally applies IDF-only weighting.
  \item Computes a similarity matrix using either weighted common peaks or
  cosine similarity.
}

For the current graph-based route, a practical initial setting is:
\itemize{
  \item \code{weighting_method = "idf_only"}
  \item \code{similarity_method = "common_peaks"}
}
}
\value{
A numeric similarity matrix.
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

similarity_file <- tempfile(fileext = ".rds")

Z <- process_similarity_matrix(
  input_file = spectra_file,
  output_file = similarity_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = "idf_only",
  similarity_method = "common_peaks"
)

dim(Z)
}
\seealso{
\code{\link{filter_intensity_matrix}}, \code{\link{process_graph_umap}}
}
\keyword{spectral}
\keyword{similarity}
\keyword{matrix}
