\name{create_shiny_umap_viewer}
\alias{create_shiny_umap_viewer}
\title{Interactive UMAP and Spectrum Viewer with Shiny}
\description{
This function launches a Shiny application for visualizing UMAP results alongside MS/MS spectra. The application includes an interactive scatter plot of the UMAP projection and the ability to view spectra for selected points with a history of up to three selections.
}
\usage{
create_shiny_umap_viewer(umap_file, spectra_file, app_title = "UMAP and MS/MS Spectrum Viewer with History")
}
\arguments{
  \item{umap_file}{
    Path to the \code{.rds} file containing the UMAP results (\code{umap_result}).
  }
  \item{spectra_file}{
    Path to the \code{.rds} file containing the subset of spectra data (\code{subset_spectra}).
  }
  \item{app_title}{
    Title of the Shiny application. Default is \code{"UMAP and MS/MS Spectrum Viewer with History"}.
  }
}
\details{
The function creates an interactive Shiny application that allows users to explore UMAP results and corresponding MS/MS spectra. Features include:
\itemize{
  \item An interactive UMAP scatter plot generated with Plotly.
  \item Hover and click functionality to view details of selected points.
  \item A history of up to three most recently selected spectra, displayed as line plots.
}
The \code{umap_file} should contain the UMAP results as a matrix, with each row corresponding to a sample. The \code{spectra_file} should contain a matrix of spectral data with rows representing samples and columns representing intensity values for specific m/z bins.

In practice, this function is typically called after either:
\itemize{
  \item \code{pca_umap_analysis()} for the PCA route, or
  \item \code{process_graph_umap()} for the similarity / graph route.
}
}
\value{
This function does not return a value. It launches a Shiny application in the default web browser.
}
\author{
Hiroyuki Yamamoto
}
\examples{
\dontrun{
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
  weighting_method = "idf_only"
)

pca_umap_analysis(
  input_spectrum_file = spectra_file,
  input_filtered_file = filtered_file,
  output_umap_file = umap_file,
  output_subset_file = subset_file,
  scaling = FALSE,
  centering = TRUE
)

create_shiny_umap_viewer(
  umap_file = umap_file,
  spectra_file = subset_file,
  app_title = "UMAP Viewer Example"
)
}
}
\seealso{
\code{\link[shiny]{shinyApp}}, \code{\link[plotly]{plotly}}
}
\keyword{UMAP}
\keyword{spectrum}
\keyword{visualization}
\keyword{Shiny}
