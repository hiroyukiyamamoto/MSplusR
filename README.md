# MSplusR

`MSplusR` is an R package designed as an extension to Mass++, providing tools for processing, analyzing, and visualizing metabolomics spectral data. It bridges the functionality of Mass++ with R's robust analytical and visualization capabilities, enabling seamless integration of spectral data processing workflows.

## Features

- **Data Preprocessing**: Tools for filtering and normalizing spectral data.
- **Dimensionality Reduction**: PCA and UMAP for reducing data dimensions and visualizing patterns in spectral data.
- **Graph-Based Analysis**: Creation of graph adjacency matrices for exploring relationships between spectra.
- **Interactive Visualization**: Shiny-based applications for exploring UMAP results and spectra interactively.

## Installation

You can install `MSplusR` from source using the `devtools` package:

```R
# Install from source
devtools::install_local("path_to_package_directory")
