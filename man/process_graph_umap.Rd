\name{process_graph_umap}
\alias{process_graph_umap}
\title{Graph-based UMAP Dimensionality Reduction}
\description{
This function performs dimensionality reduction using a graph adjacency matrix derived from a similarity matrix of spectral data. The results include a UMAP embedding and a subset of the spectra used in the analysis.
}
\usage{
process_graph_umap(input_spectrum_file, input_similarity_file,
                   output_umap_file = "umap_graph.rds",
                   output_subset_file = "subset_spectra.rds",
                   edge_threshold = NULL, n_components = 10)
}
\arguments{
  \item{input_spectrum_file}{
    The file path to the input \code{.rds} file containing the spectral data matrix (\code{X0}).
  }
  \item{input_similarity_file}{
    The file path to the input \code{.rds} file containing the similarity matrix (\code{Z}).
  }
  \item{output_umap_file}{
    The file path where the UMAP result will be saved. Default is \code{"umap_graph.rds"}.
  }
  \item{output_subset_file}{
    The file path where the subset of spectra will be saved. Default is \code{"subset_spectra.rds"}.
  }
  \item{edge_threshold}{
    Threshold for retaining edges in the graph adjacency matrix. Edges with similarity below this value are removed.
    When \code{NULL} (default), the threshold is set automatically based on the similarity method stored in
    \code{input_similarity_file}: \code{0.3} for \code{"cosine"}, \code{3} for \code{"common_peaks"}.
  }
  \item{n_components}{
    The number of components (dimensions) to retain in the UMAP embedding. Default is \code{10}.
  }
}
\details{
This function processes a spectral data matrix (\code{X0}) and a similarity matrix (\code{Z}) to compute a graph adjacency matrix. The steps are as follows:
\itemize{
  \item The diagonal elements of \code{Z} are set to 0.
  \item Connections in the graph adjacency matrix (\code{W}) are determined by \code{edge_threshold} (auto-detected from the similarity method if \code{NULL}).
  \item Singular Value Decomposition (SVD) is applied to compute eigenvectors of the adjacency matrix.
  \item UMAP is used for dimensionality reduction on the eigenvectors.
  \item Spectral data (\code{X0}) corresponding to connected nodes is extracted as a subset.
}
The function saves the UMAP result and the subset of spectra to the specified output files.
}
\value{
A list containing the following elements:
\itemize{
  \item \code{umap_result}: A matrix containing the UMAP embedding.
  \item \code{subset_spectra}: A matrix containing the subset of spectra used in the analysis.
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

similarity_file <- tempfile(fileext = ".rds")
umap_file <- tempfile(fileext = ".rds")
subset_file <- tempfile(fileext = ".rds")

process_similarity_matrix(
  input_file = spectra_file,
  output_file = similarity_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = "idf_only",
  similarity_method = "common_peaks"
)

result <- process_graph_umap(
  input_spectrum_file = spectra_file,
  input_similarity_file = similarity_file,
  output_umap_file = umap_file,
  output_subset_file = subset_file,
  n_components = 10
)

str(result$umap_result)
}
\seealso{
\code{\link[uwot]{umap}} for UMAP dimensionality reduction.
}
\keyword{spectral}
\keyword{graph}
\keyword{umap}
\keyword{dimensionality reduction}
