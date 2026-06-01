\name{create_masspp_umap_viewer}
\alias{create_masspp_umap_viewer}
\title{UMAP Viewer That Sends Clicked Spectra to Mass++}
\description{
Launch a Shiny + plotly UMAP viewer and send clicked spectra to Mass++ through
the local Mass++ API.
}
\usage{
create_masspp_umap_viewer(
  umap_file,
  spectra_file,
  app_title = "UMAP to Mass++ Viewer",
  base_url = "http://localhost:8191/",
  default_ms_level = 2,
  centroid_mode = TRUE,
  wait_sec = 0
)
}
\arguments{
  \item{umap_file}{Path to the saved UMAP result file containing \code{umap_result}.}
  \item{spectra_file}{Path to the saved subset spectra file containing \code{subset_spectra}.}
  \item{app_title}{Title shown in the Shiny app.}
  \item{base_url}{Mass++ API base URL.}
  \item{default_ms_level}{MS level sent to Mass++.}
  \item{centroid_mode}{Logical. Passed to \code{send_scan_to_masspp()}.}
  \item{wait_sec}{Optional wait time after each send.}
}
\details{
This viewer is intended for users who want to inspect the UMAP projection in
R while opening selected spectra in Mass++ for detailed confirmation.
}
\value{
A Shiny app object.
}
\examples{
\dontrun{
library(MSplusR)

res <- run_pca_umap_workflow(
  weighting_method = "idf_only",
  scaling = FALSE,
  centering = TRUE,
  launch_viewer = FALSE
)

create_masspp_umap_viewer(
  umap_file = res$umap_file,
  spectra_file = res$subset_file
)
}
}
