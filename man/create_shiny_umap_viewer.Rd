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
}
\value{
This function does not return a value. It launches a Shiny application in the default web browser.
}
\author{
Hiroyuki Yamamoto
}
\examples{
# Example usage:
# Define paths to input files
umap_file <- system.file("extdata", "example_umap.rds", package = "YourPackageName")
spectra_file <- system.file("extdata", "example_spectra.rds", package = "YourPackageName")

# Launch the Shiny application
create_shiny_umap_viewer(
  umap_file = umap_file,
  spectra_file = spectra_file,
  app_title = "UMAP Viewer Example"
)

# Note: Replace `YourPackageName` with the name of your package, and ensure
# that the files `example_umap.rds` and `example_spectra.rds` are included
# in your package's `inst/extdata` directory.
}
\seealso{
\code{\link[shiny]{shinyApp}}, \code{\link[plotly]{plotly}}
}
\keyword{UMAP}
\keyword{spectrum}
\keyword{visualization}
\keyword{Shiny}
