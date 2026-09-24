######################################################
#                                                    #
# Lab 5: K-means clustering                          #
#                                                    #
# R/run_lab5.r                                       #
#                                                    #
# Run both implementations from R/lab5.r.            #
# Compare results, random starts, and scaling.       #
# Save the results and demonstration figure.         #
#                                                    #
######################################################

source(file.path("R", "lab5.r"))

# Setup. Keep all observations, but use only the two numeric features.
data <- read.csv(file.path("data-raw", "demonstration.csv"))
x <- as.matrix(data[, c("love", "hapiness")])

# These are the starting centers from the supplied demonstration.
initial_centers <- rbind(c(0.39, 0.39), c(0.40, 0.40), c(0.41, 0.41))
colnames(initial_centers) <- colnames(x)

# Tasks 1-2. Trace one step, then run the complete hand-coded algorithm.
first_step <- kmeans_step(x, initial_centers)
hand <- kmeans_hand(x, initial_centers, iter.max = 100L)

# Task 3. Use the same data, centers, and algorithm for a fair comparison.
builtin <- kmeans_function(x, initial_centers, iter.max = 100L)

# Cluster numbers are arbitrary. A one-to-one table means the partitions agree.
membership_table <- table(hand = hand$cluster, builtin = builtin$cluster)
stopifnot(
  hand$converged,
  all(rowSums(membership_table > 0) == 1L),
  all(colSums(membership_table > 0) == 1L),
  isTRUE(all.equal(hand$tot.withinss, builtin$tot.withinss))
)

# Task 4. Try random starting centers, then change the feature weights.
set.seed(123)
multiple_starts <- kmeans_function(
  x, centers = 3L, nstart = 25L, iter.max = 100L
)

x_scaled <- scale(x)
set.seed(123)
scaled_fit <- kmeans_function(
  x_scaled, centers = 3L, nstart = 25L, iter.max = 100L
)

# WCSS is comparable only for fits using the same input scale.
comparison <- data.frame(
  method = c("hand-coded Lloyd", "stats::kmeans Lloyd",
             "stats::kmeans Lloyd", "stats::kmeans Lloyd"),
  input_scale = c("original", "original", "original", "standardized"),
  initialization = c("supplied centers", "supplied centers",
                     "25 random starts", "25 random starts"),
  tot.withinss = c(hand$tot.withinss, builtin$tot.withinss,
                  multiple_starts$tot.withinss, scaled_fit$tot.withinss),
  iterations = c(hand$iter, builtin$iter, multiple_starts$iter, scaled_fit$iter)
)

assignments <- data.frame(
  row_id = seq_len(nrow(data)),
  data,
  hand_cluster = hand$cluster,
  function_cluster = builtin$cluster,
  multiple_start_cluster = multiple_starts$cluster,
  scaled_cluster = scaled_fit$cluster
)

dir.create("results", showWarnings = FALSE)
write.csv(comparison, file.path("results", "method_comparison.csv"),
          row.names = FALSE)
write.csv(hand$history, file.path("results", "objective_history.csv"),
          row.names = FALSE)
write.csv(assignments, file.path("results", "cluster_assignments.csv"),
          row.names = FALSE)

# A small plot
plot_clusters <- function(centers, cluster = NULL, title) {
  colors <- c("#D55E00", "#0072B2", "#009E73")
  point_colors <- if (is.null(cluster)) "grey65" else colors[cluster]
  plot(x[, 1], x[, 2], col = point_colors, pch = 16, cex = 0.65,
       xlim = c(0, 1), ylim = c(0, 1), asp = 1,
       xlab = "Love", ylab = "Happiness", main = title, las = 1)
  if (!is.null(centers)) {
    points(centers[, 1], centers[, 2], col = colors,
           pch = 4, cex = 1.8, lwd = 3)
  }
}

# Keep graphics devices inside a function so they close even if plotting fails.
save_figures <- function() {
  pdf(file.path("results", "kmeans_steps.pdf"),
      width = 12, height = 6)
  on.exit(dev.off(), add = TRUE)
  par(mfrow = c(2, 3), mar = c(4, 4, 3, 1), mgp = c(2.4, 0.7, 0))

  plot_clusters(initial_centers, title = "1. Initial centers")
  plot_clusters(initial_centers, first_step$cluster, "2. First assignment")
  plot_clusters(first_step$centers, first_step$cluster, "3. First center update")
  plot_clusters(hand$centers, hand$cluster, "4. Hand-coded Lloyd")
  plot_clusters(builtin$centers, builtin$cluster, "5. R's Lloyd function")
  plot(hand$history$iteration, hand$history$tot.withinss, type = "b",
       pch = 16, col = "#0072B2", xlab = "Completed iteration",
       ylab = "Within-cluster sum of squares", main = "6. Objective history",
       las = 1)
}

# Show every recorded iteration without running the algorithm again.
save_iteration_figures <- function() {
  pdf(file.path("results", "kmeans_iterations.pdf"),
      width = 12, height = 6, onefile = TRUE)
  on.exit(dev.off(), add = TRUE)
  par(mfrow = c(1, 2), mar = c(4, 4, 4, 1), mgp = c(2.4, 0.7, 0))

  plot_clusters(NULL, title = "Raw data")
  plot_clusters(initial_centers, title = "Initial centers")

  centers <- initial_centers
  for (iteration in seq_along(hand$steps)) {
    step <- hand$steps[[iteration]]

    # A: assign observations using the centers from the previous iteration.
    plot_clusters(centers, step$cluster,
                  paste("Iteration", iteration, "A: assignment"))
    assignment_wcss <- sum((x - centers[step$cluster, , drop = FALSE])^2)
    mtext(sprintf("WCSS = %.4f | Centers held fixed", assignment_wcss),
          side = 3, line = 0.3, cex = 0.85)

    # B: hold those assignments fixed and move each center to its cluster mean.
    plot_clusters(step$centers, step$cluster,
                  paste("Iteration", iteration, "B: center update"))
    mtext(sprintf("WCSS = %.4f | Assignments held fixed", step$tot.withinss),
          side = 3, line = 0.3, cex = 0.85)

    centers <- step$centers
  }
}

save_figures()
save_iteration_figures()

cat("Method comparison (compare WCSS only within the same scale):\n")
print(comparison, row.names = FALSE, digits = 7)
cat("\nHand-coded centers and cluster sizes:\n")
print(hand$centers)
print(hand$size)
cat("\nHand-coded versus function assignments:\n")
print(membership_table)
cat("\nSource labels versus fitted clusters (labels were not inputs):\n")
print(table(source = data$cluster, fitted = hand$cluster))
cat("\nSaved three CSV files, kmeans_steps.png, and kmeans_iterations.pdf in results/.\n")
