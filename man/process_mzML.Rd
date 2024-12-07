\name{process_mzML}
\alias{process_mzML}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Process mzML Data and Bin Spectra Intensities}
\description{
This function processes mzML files by extracting MS2 spectra, binning intensity values over a specified m/z range, and saving the resulting matrix to a file.
}
\usage{
process_mzML(mzfile, mzrange = NULL, bin_width = 0.01, output_file = "processed_spectrum.rds")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mzfile}{
    The file path to the mzML file to be processed.
  }
  \item{mzrange}{
    A numeric vector specifying the m/z range. If NULL, the range is calculated automatically from the mzML data.
  }
  \item{bin_width}{
    The width of the bins for m/z values. Default is 0.01.
  }
  \item{output_file}{
    The file path where the resulting matrix will be saved. Default is "processed_spectrum.rds".
  }
}
\details{
The function reads an mzML file and extracts only the MS2 spectra. It then bins the intensities over the specified m/z range, creating a matrix where rows represent spectra and columns represent intensity values in each bin. The processed data is saved to a file specified by the user.
}
\value{
A numeric matrix containing binned intensities. Rows correspond to precursor m/z values of MS2 spectra, and columns correspond to binned m/z ranges.
}
\references{
Yamamoto H., and others. (2024). "Development of advanced tools for mass spectrometry-based metabolomics." (Hypothetical reference for illustration).
}
\author{
Hiroyuki Yamamoto
}
\examples{
# Example usage of process_mzML
mzfile <- "path/to/your/mzMLfile.mzML"
result <- process_mzML(mzfile, bin_width = 0.01, output_file = "processed_data.rds")

# View the resulting matrix
head(result)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ mass spectrometry }
\keyword{ metabolomics }
\keyword{ multivariate }
