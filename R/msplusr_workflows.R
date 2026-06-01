run_pca_umap_workflow <- function(
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
) {
  weighting_method <- match.arg(weighting_method)

  if (!nzchar(input_spectrum_file) || !file.exists(input_spectrum_file)) {
    stop("Input spectrum file was not found: ", input_spectrum_file)
  }

  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  filtered_file <- file.path(output_dir, "filtered_spectra.rds")
  umap_file <- file.path(output_dir, "umap_pca.rds")
  subset_file <- file.path(output_dir, "subset_spectra_pca.rds")

  filter_result <- filter_intensity_matrix(
    input_file = input_spectrum_file,
    output_file = filtered_file,
    intensity_threshold = intensity_threshold,
    normalization_threshold = normalization_threshold,
    binarize = binarize,
    weighting_method = weighting_method,
    return_idf = TRUE
  )

  pca_result <- pca_umap_analysis(
    input_spectrum_file = input_spectrum_file,
    input_filtered_file = filtered_file,
    output_umap_file = umap_file,
    output_subset_file = subset_file,
    pca_components = pca_components,
    umap_n_neighbors = umap_n_neighbors,
    umap_min_dist = umap_min_dist,
    scaling = scaling,
    centering = centering
  )

  if (isTRUE(launch_viewer)) {
    create_shiny_umap_viewer(
      umap_file = umap_file,
      spectra_file = subset_file,
      app_title = app_title
    )
  }

  list(
    input_spectrum_file = input_spectrum_file,
    output_dir = output_dir,
    filtered_file = filtered_file,
    umap_file = umap_file,
    subset_file = subset_file,
    filter_result = filter_result,
    pca_result = pca_result
  )
}

run_similarity_graph_umap_workflow <- function(
  input_spectrum_file = system.file(
    "extdata",
    "Posi_Ida_Chlamydomonas_1_spec.rds",
    package = "MSplusR"
  ),
  output_dir = file.path(tempdir(), "MSplusR_similarity_workflow"),
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = c("none", "idf_only"),
  similarity_method = c("cosine", "common_peaks"),
  edge_threshold = NULL,
  n_components = 10,
  launch_viewer = TRUE,
  app_title = "MSplusR: similarity + graph UMAP workflow"
) {
  weighting_method <- match.arg(weighting_method)
  similarity_method <- match.arg(similarity_method)

  if (!nzchar(input_spectrum_file) || !file.exists(input_spectrum_file)) {
    stop("Input spectrum file was not found: ", input_spectrum_file)
  }

  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  similarity_file <- file.path(output_dir, "similarity_matrix.rds")
  umap_file <- file.path(output_dir, "umap_graph.rds")
  subset_file <- file.path(output_dir, "subset_spectra_graph.rds")

  similarity_result <- process_similarity_matrix(
    input_file = input_spectrum_file,
    output_file = similarity_file,
    intensity_threshold = intensity_threshold,
    normalization_threshold = normalization_threshold,
    weighting_method = weighting_method,
    similarity_method = similarity_method
  )

  graph_result <- process_graph_umap(
    input_spectrum_file = input_spectrum_file,
    input_similarity_file = similarity_file,
    output_umap_file = umap_file,
    output_subset_file = subset_file,
    edge_threshold = edge_threshold,
    n_components = n_components
  )

  if (isTRUE(launch_viewer)) {
    create_shiny_umap_viewer(
      umap_file = umap_file,
      spectra_file = subset_file,
      app_title = app_title
    )
  }

  list(
    input_spectrum_file = input_spectrum_file,
    output_dir = output_dir,
    similarity_file = similarity_file,
    umap_file = umap_file,
    subset_file = subset_file,
    similarity_result = similarity_result,
    graph_result = graph_result
  )
}

run_pca_umap_masspp_workflow <- function(
  input_spectrum_file = system.file(
    "extdata",
    "Posi_Ida_Chlamydomonas_1_spec.rds",
    package = "MSplusR"
  ),
  output_dir = file.path(tempdir(), "MSplusR_pca_masspp_workflow"),
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  binarize = TRUE,
  weighting_method = c("none", "idf_only"),
  pca_components = 10,
  umap_n_neighbors = 15,
  umap_min_dist = 0.01,
  scaling = FALSE,
  centering = TRUE,
  launch_masspp_viewer = TRUE,
  app_title = "MSplusR: PCA + UMAP to Mass++",
  base_url = "http://localhost:8191/"
) {
  workflow_result <- run_pca_umap_workflow(
    input_spectrum_file = input_spectrum_file,
    output_dir = output_dir,
    intensity_threshold = intensity_threshold,
    normalization_threshold = normalization_threshold,
    binarize = binarize,
    weighting_method = match.arg(weighting_method),
    pca_components = pca_components,
    umap_n_neighbors = umap_n_neighbors,
    umap_min_dist = umap_min_dist,
    scaling = scaling,
    centering = centering,
    launch_viewer = FALSE,
    app_title = app_title
  )

  if (isTRUE(launch_masspp_viewer)) {
    create_masspp_umap_viewer(
      umap_file = workflow_result$umap_file,
      spectra_file = workflow_result$subset_file,
      app_title = app_title,
      base_url = base_url
    )
  }

  workflow_result
}

run_similarity_graph_umap_masspp_workflow <- function(
  input_spectrum_file = system.file(
    "extdata",
    "Posi_Ida_Chlamydomonas_1_spec.rds",
    package = "MSplusR"
  ),
  output_dir = file.path(tempdir(), "MSplusR_similarity_masspp_workflow"),
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = c("none", "idf_only"),
  similarity_method = c("cosine", "common_peaks"),
  edge_threshold = NULL,
  n_components = 10,
  launch_masspp_viewer = TRUE,
  app_title = "MSplusR: similarity + graph UMAP to Mass++",
  base_url = "http://localhost:8191/"
) {
  workflow_result <- run_similarity_graph_umap_workflow(
    input_spectrum_file = input_spectrum_file,
    output_dir = output_dir,
    intensity_threshold = intensity_threshold,
    normalization_threshold = normalization_threshold,
    weighting_method = match.arg(weighting_method),
    similarity_method = match.arg(similarity_method),
    edge_threshold = edge_threshold,
    n_components = n_components,
    launch_viewer = FALSE,
    app_title = app_title
  )

  if (isTRUE(launch_masspp_viewer)) {
    create_masspp_umap_viewer(
      umap_file = workflow_result$umap_file,
      spectra_file = workflow_result$subset_file,
      app_title = app_title,
      base_url = base_url
    )
  }

  workflow_result
}
