\name{create_masspp_session}
\alias{create_masspp_session}
\alias{send_scan_to_masspp}
\title{Mass++ API Integration Helpers}
\description{
Create a Mass++ sample session and send a single mass spectrum to the local
Mass++ API.
}
\usage{
create_masspp_session(base_url = "http://localhost:8191/")

send_scan_to_masspp(
  mz,
  intensity,
  sample_id = NULL,
  base_url = "http://localhost:8191/",
  ms_level = 2,
  precursor_mz = -1,
  rt = 0,
  centroid_mode = TRUE,
  min_mz = NULL,
  max_mz = NULL,
  flush_index = 0,
  wait_sec = 0
)
}
\arguments{
  \item{base_url}{Mass++ API base URL.}
  \item{mz}{Numeric vector of m/z values.}
  \item{intensity}{Numeric vector of peak intensities.}
  \item{sample_id}{Existing Mass++ sample/session ID. If \code{NULL}, a new one is created.}
  \item{ms_level}{MS level to send to Mass++.}
  \item{precursor_mz}{Precursor m/z value. Use \code{-1} for MS1-style scans.}
  \item{rt}{Retention time in seconds.}
  \item{centroid_mode}{Logical flag indicating centroid mode.}
  \item{min_mz}{Minimum display m/z. If \code{NULL}, computed from \code{mz}.}
  \item{max_mz}{Maximum display m/z. If \code{NULL}, computed from \code{mz}.}
  \item{flush_index}{Index argument passed to \code{/io_flush}.}
  \item{wait_sec}{Optional wait time in seconds after sending.}
}
\value{
For \code{create_masspp_session()}, a character sample/session ID.

For \code{send_scan_to_masspp()}, a list containing the sample ID and the
raw Mass++ API responses for \code{io_add_scan} and \code{io_flush}.
}
\details{
These helpers assume that the local Mass++ API is available at
\code{http://localhost:8191/}.

\code{create_masspp_session()} creates a new sample/session on the Mass++ side.
\code{send_scan_to_masspp()} sends a single spectrum defined by \code{mz} and
\code{intensity}. For repeated transfer, you can reuse the returned
\code{sample_id}.
}
\examples{
\dontrun{
session_id <- create_masspp_session()

send_scan_to_masspp(
  mz = c(100, 150, 200),
  intensity = c(1000, 500, 250),
  sample_id = session_id,
  ms_level = 2,
  precursor_mz = 300.1234,
  rt = 123.4
)

# Send an MS1-style scan to a new session
send_scan_to_masspp(
  mz = c(100, 150, 200),
  intensity = c(1000, 500, 250),
  ms_level = 1,
  precursor_mz = -1,
  rt = 0
)
}
}
