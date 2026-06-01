\name{run_similarity_graph_umap_workflow}
\alias{run_similarity_graph_umap_workflow}
\title{Similarity Matrix + Graph UMAP Workflow}
\description{
Run the end-to-end similarity/graph UMAP workflow using a single function call.
Filters spectra, computes a pairwise similarity matrix, builds a graph UMAP,
and optionally launches the Shiny spectrum viewer.
}
\usage{
run_similarity_graph_umap_workflow(
  input_spectrum_file = system.file(
    "extdata",
    "Posi_Ida_Chlamydomonas_1_spec.rds",
    package = "MSplusR"
  ),
  output_dir = file.path(tempdir(), "MSplusR_similarity_workflow"),
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = c("none", "idf_only"),
  similarity_method = c("cosine", "common_peaks"),
  edge_threshold = NULL,
  n_components = 10,
  launch_viewer = TRUE,
  app_title = "MSplusR: similarity + graph UMAP workflow"
)
}
\arguments{
  \item{input_spectrum_file}{Path to the input \code{.rds} file containing \code{X0}. By default, the bundled demo data are used.}
  \item{output_dir}{Directory where intermediate and output files are written.}
  \item{intensity_threshold}{Absolute intensity threshold.}
  \item{normalization_threshold}{Relative threshold after base-peak normalization.}
  \item{weighting_method}{Either \code{"none"} or \code{"idf_only"}.}
  \item{similarity_method}{Either \code{"common_peaks"} or \code{"cosine"}.}
  \item{edge_threshold}{Edge threshold for the graph. When \code{NULL} (default), set automatically: \code{0.3} for \code{"cosine"}, \code{3} for \code{"common_peaks"}.}
  \item{n_components}{Number of graph/SVD components passed to \code{process_graph_umap()}.}
  \item{launch_viewer}{Logical. If \code{TRUE}, launch the Shiny spectrum viewer after the workflow.}
  \item{app_title}{Title passed to the Shiny viewer.}
}
\details{
Internally this function calls \code{\link{process_similarity_matrix}},
\code{\link{process_graph_umap}}, and optionally \code{\link{create_shiny_umap_viewer}}.
}
\value{
A named list with the following elements:
\describe{
  \item{input_spectrum_file}{Path to the input file.}
  \item{output_dir}{Path to the output directory.}
  \item{similarity_file}{Path to the similarity matrix \code{.rds}.}
  \item{umap_file}{Path to the UMAP result \code{.rds}.}
  \item{subset_file}{Path to the subset spectra \code{.rds}.}
  \item{similarity_result}{Return value of \code{process_similarity_matrix()}.}
  \item{graph_result}{Return value of \code{process_graph_umap()}.}
}
}
\seealso{
\code{\link{run_pca_umap_workflow}},
\code{\link{run_similarity_graph_umap_masspp_workflow}}
}
\examples{
\dontrun{
res <- run_similarity_graph_umap_workflow(
  weighting_method = "idf_only",
  similarity_method = "common_peaks"
)
}
}
