\name{Posi_Ida_Chlamydomonas_1_spec}
\docType{data}
\alias{Posi_Ida_Chlamydomonas_1_spec}
\title{Example Spectral Data for Metabolomics Analysis}
\description{
  This dataset contains example spectral intensity data for metabolomics analysis. It is derived from measurements of \emph{Chlamydomonas reinhardtii} using positive ion mode data acquisition.
}
\usage{
  data(Posi_Ida_Chlamydomonas_1_spec)
}
\format{
  An RDS file containing a matrix named \code{X0} with spectral intensity data:
    \describe{
      \item{Rows:}{Samples or spectra.}
      \item{Columns:}{m/z bins representing mass-to-charge ratios.}
      \item{Values:}{Intensity values for each m/z bin in each sample.}
    }
}
\details{
  This dataset is used as an example for metabolomics data preprocessing, dimensionality reduction, and visualization. Each row corresponds to a spectrum, and each column represents a specific m/z range with its corresponding intensity values.
}
\source{
  Experimental data from metabolomics analysis of \emph{Chlamydomonas reinhardtii}.
}
\examples{
  # Load the data
  file_path <- system.file("extdata", "Posi_Ida_Chlamydomonas_1_spec.rds", package = "YourPackageName")
  load(file_path)
  
  # View the structure of the dataset
  str(X0)
  
  # Example: Summarize the data
  summary(X0)
}
\keyword{datasets}
\keyword{metabolomics}
\keyword{spectral}
