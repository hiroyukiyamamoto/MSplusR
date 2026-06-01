\name{run_similarity_graph_umap_masspp_workflow}
\alias{run_similarity_graph_umap_masspp_workflow}
\title{Similarity Matrix + Graph UMAP Workflow with Mass++ Viewer}
\description{
Run the similarity/graph UMAP workflow and open a UMAP viewer that sends
clicked spectra to Mass++ instead of displaying them in base R plots.
}
\usage{
run_similarity_graph_umap_masspp_workflow(
  input_spectrum_file = system.file(
    "extdata",
    "Posi_Ida_Chlamydomonas_1_spec.rds",
    package = "MSplusR"
  ),
  output_dir = file.path(tempdir(), "MSplusR_similarity_masspp_workflow"),
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = c("none", "idf_only"),
  similarity_method = c("cosine", "common_peaks"),
  edge_threshold = NULL,
  n_components = 10,
  launch_masspp_viewer = TRUE,
  app_title = "MSplusR: similarity + graph UMAP to Mass++",
  base_url = "http://localhost:8191/"
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
  \item{launch_masspp_viewer}{Logical. If \code{TRUE}, launch the Mass++-linked UMAP viewer after the workflow.}
  \item{app_title}{Title passed to the Shiny viewer.}
  \item{base_url}{Base URL of the Mass++ API (default: \code{"http://localhost:8191/"}).}
}
\details{
This function is identical to \code{\link{run_similarity_graph_umap_workflow}} except
that it opens the Mass++-linked viewer (\code{\link{create_masspp_umap_viewer}}) rather
than the standard Shiny viewer. Mass++ must be running and accessible at \code{base_url}
before launching the viewer.
}
\value{
The same named list returned by \code{\link{run_similarity_graph_umap_workflow}}.
}
\seealso{
\code{\link{run_similarity_graph_umap_workflow}},
\code{\link{run_pca_umap_masspp_workflow}}
}
\examples{
\dontrun{
res <- run_similarity_graph_umap_masspp_workflow(
  weighting_method = "idf_only",
  similarity_method = "common_peaks"
)
}
}
