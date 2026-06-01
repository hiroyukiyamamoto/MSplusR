\name{run_pca_umap_masspp_workflow}
\alias{run_pca_umap_masspp_workflow}
\title{PCA + UMAP Workflow with Mass++ Viewer}
\description{
Run the PCA/UMAP workflow and open a UMAP viewer that sends clicked spectra
to Mass++ instead of displaying them in base R plots.
}
\usage{
run_pca_umap_masspp_workflow(
  input_spectrum_file = system.file(
    "extdata",
    "Posi_Ida_Chlamydomonas_1_spec.rds",
    package = "MSplusR"
  ),
  output_dir = file.path(tempdir(), "MSplusR_pca_masspp_workflow"),
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  binarize = TRUE,
  weighting_method = c("none", "idf_only"),
  pca_components = 10,
  umap_n_neighbors = 15,
  umap_min_dist = 0.01,
  scaling = FALSE,
  centering = TRUE,
  launch_masspp_viewer = TRUE,
  app_title = "MSplusR: PCA + UMAP to Mass++",
  base_url = "http://localhost:8191/"
)
}
\arguments{
  \item{input_spectrum_file}{Path to the input \code{.rds} file containing \code{X0}. By default, the bundled demo data are used.}
  \item{output_dir}{Directory where intermediate and output files are written.}
  \item{intensity_threshold}{Absolute intensity threshold.}
  \item{normalization_threshold}{Relative threshold after base-peak normalization.}
  \item{binarize}{Logical. If \code{TRUE}, binarize the intensity matrix before optional weighting.}
  \item{weighting_method}{Either \code{"none"} or \code{"idf_only"}.}
  \item{pca_components}{Maximum number of principal components to retain.}
  \item{umap_n_neighbors}{Number of neighbors passed to UMAP.}
  \item{umap_min_dist}{Minimum distance passed to UMAP.}
  \item{scaling}{Logical. If \code{TRUE}, autoscaling is applied before PCA.}
  \item{centering}{Logical. If \code{TRUE}, centering is applied before PCA.}
  \item{launch_masspp_viewer}{Logical. If \code{TRUE}, launch the Mass++-linked UMAP viewer after the workflow.}
  \item{app_title}{Title passed to the Shiny viewer.}
  \item{base_url}{Base URL of the Mass++ API (default: \code{"http://localhost:8191/"}).}
}
\details{
This function is identical to \code{\link{run_pca_umap_workflow}} except that it
opens the Mass++-linked viewer (\code{\link{create_masspp_umap_viewer}}) rather than
the standard Shiny viewer. Mass++ must be running and accessible at \code{base_url}
before launching the viewer.
}
\value{
The same named list returned by \code{\link{run_pca_umap_workflow}}.
}
\seealso{
\code{\link{run_pca_umap_workflow}},
\code{\link{run_similarity_graph_umap_masspp_workflow}}
}
\examples{
\dontrun{
res <- run_pca_umap_masspp_workflow(
  weighting_method = "idf_only",
  scaling = FALSE,
  centering = TRUE
)
}
}
