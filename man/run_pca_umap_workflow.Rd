\name{run_pca_umap_workflow}
\alias{run_pca_umap_workflow}
\title{PCA + UMAP Workflow}
\description{
Run the recommended end-to-end PCA/UMAP workflow using a single function call.
Filters the intensity matrix, computes PCA and UMAP, and optionally launches the
Shiny spectrum viewer.
}
\usage{
run_pca_umap_workflow(
  input_spectrum_file = system.file(
    "extdata",
    "Posi_Ida_Chlamydomonas_1_spec.rds",
    package = "MSplusR"
  ),
  output_dir = file.path(tempdir(), "MSplusR_pca_workflow"),
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  binarize = TRUE,
  weighting_method = c("none", "idf_only"),
  pca_components = 10,
  umap_n_neighbors = 15,
  umap_min_dist = 0.01,
  scaling = FALSE,
  centering = TRUE,
  launch_viewer = TRUE,
  app_title = "MSplusR: PCA + UMAP workflow"
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
  \item{launch_viewer}{Logical. If \code{TRUE}, launch the Shiny spectrum viewer after the workflow.}
  \item{app_title}{Title passed to the Shiny viewer.}
}
\details{
The current recommended settings are:
\itemize{
  \item \code{weighting_method = "idf_only"}
  \item \code{scaling = FALSE}
  \item \code{centering = TRUE}
}

Internally this function calls \code{\link{filter_intensity_matrix}},
\code{\link{pca_umap_analysis}}, and optionally \code{\link{create_shiny_umap_viewer}}.
}
\value{
A named list with the following elements:
\describe{
  \item{input_spectrum_file}{Path to the input file.}
  \item{output_dir}{Path to the output directory.}
  \item{filtered_file}{Path to the filtered spectra \code{.rds}.}
  \item{umap_file}{Path to the UMAP result \code{.rds}.}
  \item{subset_file}{Path to the subset spectra \code{.rds}.}
  \item{filter_result}{Return value of \code{filter_intensity_matrix()}.}
  \item{pca_result}{Return value of \code{pca_umap_analysis()}.}
}
}
\seealso{
\code{\link{run_similarity_graph_umap_workflow}},
\code{\link{run_pca_umap_masspp_workflow}}
}
\examples{
\dontrun{
res <- run_pca_umap_workflow(
  weighting_method = "idf_only",
  scaling = FALSE,
  centering = TRUE
)
}
}
