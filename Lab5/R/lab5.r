######################################################
#                                                    #
# Lab 5: K-means clustering                          #
#                                                    #
# R/lab5.r                                           #
#                                                    #
# In-class reference implementations for:            #
#   Tasks 1-2. hand-coded Lloyd algorithm            #
#   Task 3. stats::kmeans()                          #
#                                                    #
######################################################

# x has two numeric columns: love and hapiness.
# Each row of centers is one starting centroid.


# Task 1. One assignment step followed by one center update

kmeans_step <- function(x, centers) {
  k <- nrow(centers)
  distances <- matrix(0, nrow = nrow(x), ncol = k)

  # Squared distances give the same nearest center as distances.
  for (j in seq_len(k)) {
    distances[, j] <- (x[, 1] - centers[j, 1])^2 +
                      (x[, 2] - centers[j, 2])^2
  }

  # which.min() chooses the first center when distances tie.
  cluster <- apply(distances, 1, which.min)

  for (j in seq_len(k)) {
    members <- x[cluster == j, , drop = FALSE]
    if (nrow(members) == 0L) {
      stop("Empty cluster: choose different starting centers.", call. = FALSE)
    }
    centers[j, ] <- colMeans(members)
  }

  list(
    cluster = cluster,
    centers = centers,
    tot.withinss = sum((x - centers[cluster, , drop = FALSE])^2)
  )
}


# Task 2. Repeat until the assignments stop changing

kmeans_hand <- function(x, centers, iter.max = 100L) {
  stopifnot(
    is.matrix(x), is.numeric(x), nrow(x) > 0L, ncol(x) == 2L,
    is.matrix(centers), is.numeric(centers), ncol(centers) == 2L,
    nrow(centers) >= 1L, nrow(centers) <= nrow(x),
    all(is.finite(x)), all(is.finite(centers)),
    length(iter.max) == 1L, is.finite(iter.max),
    iter.max >= 1L, iter.max == floor(iter.max)
  )

  previous_cluster <- integer(nrow(x))
  objective <- numeric(iter.max)
  steps <- vector("list", iter.max)  # Keep assignments and centers for plotting.
  converged <- FALSE

  for (iteration in seq_len(iter.max)) {
    fit <- kmeans_step(x, centers)
    objective[iteration] <- fit$tot.withinss
    steps[[iteration]] <- fit

    if (all(fit$cluster == previous_cluster)) {
      converged <- TRUE
      break
    }

    previous_cluster <- fit$cluster
    centers <- fit$centers
  }

  if (!converged) {
    warning("Iteration limit reached; increase iter.max.", call. = FALSE)
  }

  fit$size <- tabulate(fit$cluster, nbins = nrow(centers))
  fit$iter <- iteration
  fit$converged <- converged
  fit$steps <- steps[seq_len(iteration)]
  fit$history <- data.frame(
    iteration = seq_len(iteration),
    tot.withinss = objective[seq_len(iteration)]
  )
  fit
}


# Task 3. K-means with R's function

# Use Lloyd's algorithm to match the hand-coded implementation.
# centers can be a matrix of starting centers or the number of clusters.
kmeans_function <- function(x, centers, nstart = 1L, iter.max = 100L) {
  stats::kmeans(
    x,
    centers = centers,
    nstart = nstart,
    iter.max = iter.max,
    algorithm = "Lloyd"
  )
}
