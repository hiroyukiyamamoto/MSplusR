\name{filter_intensity_matrix}
\alias{filter_intensity_matrix}
\title{Filter and Normalize Spectral Intensity Data}
\description{
This function filters a spectral intensity matrix, applies normalization, and saves the processed data to a file. It is designed for preprocessing spectral data before further analysis.
}
\usage{
filter_intensity_matrix(input_file, output_file = "X_filtered.rds", 
                        intensity_threshold = 1000, normalization_threshold = 0.01)
}
\arguments{
  \item{input_file}{
    Path to the \code{.rds} file containing the spectral intensity matrix (\code{X0}).
  }
  \item{output_file}{
    Path to the output \code{.rds} file where the processed matrix will be saved. Default is \code{"X_filtered.rds"}.
  }
  \item{intensity_threshold}{
    A numeric value specifying the intensity threshold. Intensity values below this threshold are set to \code{0}. Default is \code{1000}.
  }
  \item{normalization_threshold}{
    A numeric value specifying the normalization threshold. After row-wise normalization, values below this threshold are set to \code{0}. Default is \code{0.01}.
  }
}
\details{
The function performs the following preprocessing steps:
\itemize{
  \item Removes noise by setting intensity values below \code{intensity_threshold} to \code{0}.
  \item Normalizes each row (spectrum) by its maximum intensity.
  \item Sets normalized intensity values below \code{normalization_threshold} to \code{0}.
  \item Converts all non-zero values in the matrix to \code{1}.
}
The processed matrix is saved to the specified output file.
}
\value{
Returns the processed intensity matrix as a numeric matrix.
}
\author{
Hiroyuki Yamamoto
}
\examples{
# Example usage:
# Define input and output file paths
input_file <- system.file("extdata", "example_spectrum.rds", package = "YourPackageName")
output_file <- tempfile(fileext = ".rds")  # Temporary file for demonstration

# Filter and normalize the intensity matrix
result <- filter_intensity_matrix(
  input_file = input_file,
  output_file = output_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01
)

# View the processed matrix
print(result)

# Note: Replace `YourPackageName` with the actual name of your package, and ensure
# that the file `example_spectrum.rds` is included in your package's `inst/extdata` directory.
}
\seealso{
\code{\link[base]{save}}, \code{\link[base]{load}}
}
\keyword{spectral}
\keyword{filtering}
\keyword{normalization}
\keyword{preprocessing}
