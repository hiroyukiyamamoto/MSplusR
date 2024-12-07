\name{process_similarity_matrix}
\alias{process_similarity_matrix}
\title{Process Similarity Matrix from Spectral Data}
\description{
This function filters intensity data from a spectral matrix, normalizes it, and computes a similarity matrix based on common peaks between spectra. The resulting matrix is saved to a file.
}
\usage{
process_similarity_matrix(input_file, output_file = "Z_common.rds", 
                          intensity_threshold = 1000, 
                          normalization_threshold = 0.01)
}
\arguments{
  \item{input_file}{
    The file path to the input \code{.rds} file containing the spectral data matrix (\code{X0}).
  }
  \item{output_file}{
    The file path where the resulting similarity matrix will be saved. Default is \code{"Z_common.rds"}.
  }
  \item{intensity_threshold}{
    A numeric value for the intensity threshold below which values are set to 0 (noise filtering). Default is 1000.
  }
  \item{normalization_threshold}{
    A numeric value for the normalization threshold. Values below this threshold (relative to the maximum intensity of each spectrum) are set to 0. Default is 0.01.
  }
}
\details{
This function processes a spectral data matrix (\code{X0}) loaded from the input file. 
The steps are as follows:
\itemize{
  \item Values below \code{intensity_threshold} are set to 0.
  \item Each spectrum is normalized by its maximum intensity.
  \item Values below \code{normalization_threshold} after normalization are set to 0.
  \item Non-zero values in the matrix are replaced with 1.
  \item A similarity matrix is computed as the number of common peaks between spectra.
}
The similarity matrix is saved to the specified output file.
}
\value{
A numeric similarity matrix where each element represents the number of common peaks between two spectra.
}
\author{
Hiroyuki Yamamoto
}
\examples{
# Example usage:
# Define input and output file paths
input_file <- system.file("extdata", "example_spec.rds", package = "YourPackageName")
output_file <- tempfile(fileext = ".rds")  # Temporary file for demonstration

# Process similarity matrix
result <- process_similarity_matrix(
  input_file = input_file,
  output_file = output_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01
)

# View the resulting similarity matrix
print(result)

# Note: Replace `YourPackageName` with the actual name of your package,
# and ensure the example_spec.rds file is included in your package's extdata directory.
}
\seealso{
\code{\link[Matrix]{Matrix}} for sparse matrix operations.
}
\keyword{spectral}
\keyword{similarity}
\keyword{matrix}
