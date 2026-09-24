######################################################
#                                                    #
# Lab 5: K-means clustering tests                    #
#                                                    #
# tests/lab5_test.r                                  #
#                                                    #
######################################################

source(file.path("R", "lab5.r"))

# An example with known centers and a known objective.
toy <- rbind(c(0, 0), c(0, 2), c(8, 0), c(8, 2))
toy_centers <- rbind(c(0, 0), c(8, 0))
toy_fit <- kmeans_hand(toy, toy_centers)
stopifnot(
  toy_fit$converged,
  all(toy_fit$cluster == c(1L, 1L, 2L, 2L)),
  isTRUE(all.equal(toy_fit$centers, rbind(c(0, 1), c(8, 1)))),
  toy_fit$tot.withinss == 4
)
cat("PASS: known centers, memberships, and within-cluster sum of squares.\n")

# An equidistant observation belongs to the first center, never cluster 0.
tie_data <- rbind(c(0, 0), c(1, 0), c(2, 0))
tie_fit <- kmeans_step(tie_data, rbind(c(0, 0), c(2, 0)))
stopifnot(all(tie_fit$cluster == c(1L, 1L, 2L)))
cat("PASS: distance ties receive exactly one cluster.\n")

empty_message <- tryCatch(
  kmeans_step(toy, rbind(c(0, 0), c(100, 100))),
  error = function(e) conditionMessage(e)
)
stopifnot(is.character(empty_message),
          grepl("Empty cluster", empty_message, fixed = TRUE))

limited <- suppressWarnings(kmeans_hand(toy, toy_centers, iter.max = 1L))
stopifnot(!limited$converged, limited$iter == 1L)
cat("PASS: empty clusters and iteration limits are reported.\n")

# The supplied demonstration should reach the same partition as R's Lloyd fit.
data <- read.csv(file.path("data-raw", "demonstration.csv"))
x <- as.matrix(data[, c("love", "hapiness")])
initial_centers <- rbind(c(0.39, 0.39), c(0.40, 0.40), c(0.41, 0.41))
colnames(initial_centers) <- colnames(x)
hand <- kmeans_hand(x, initial_centers)
builtin <- stats::kmeans(x, centers = initial_centers,
                         iter.max = 100L, algorithm = "Lloyd")
agreement <- table(hand$cluster, builtin$cluster)

stopifnot(
  nrow(x) == 500L,
  hand$converged,
  all(hand$cluster %in% 1:3),
  all(hand$size > 0L),
  sum(hand$size) == nrow(x),
  all(diff(hand$history$tot.withinss) <= 1e-10),
  isTRUE(all.equal(hand$tot.withinss, builtin$tot.withinss,
                   tolerance = 1e-10)),
  all(rowSums(agreement > 0) == 1L),
  all(colSums(agreement > 0) == 1L)
)

# Independently check every returned center and the final nearest assignments.
for (j in 1:3) {
  stopifnot(isTRUE(all.equal(
    unname(hand$centers[j, ]),
    unname(colMeans(x[hand$cluster == j, , drop = FALSE]))
  )))
}
final_distances <- sapply(1:3, function(j) {
  rowSums(sweep(x, 2, hand$centers[j, ], "-")^2)
})
stopifnot(all(hand$cluster == max.col(-final_distances, ties.method = "first")))
cat("PASS: the objective decreases and the final fit agrees with R's Lloyd fit.\n")

# Saved plotting states must describe the same sequence as the fitted model.
stopifnot(length(hand$steps) == hand$iter)
old_centers <- initial_centers
previous_wcss <- Inf
for (iteration in seq_along(hand$steps)) {
  step <- hand$steps[[iteration]]
  assignment_wcss <- sum((x - old_centers[step$cluster, , drop = FALSE])^2)
  stopifnot(
    assignment_wcss <= previous_wcss + 1e-10,
    step$tot.withinss <= assignment_wcss + 1e-10,
    isTRUE(all.equal(step$tot.withinss, hand$history$tot.withinss[iteration]))
  )
  old_centers <- step$centers
  previous_wcss <- step$tot.withinss
}
stopifnot(identical(tail(hand$steps, 1)[[1]]$cluster, hand$cluster),
          identical(old_centers, hand$centers))
cat("PASS: saved iteration plots follow both decreasing-objective steps.\n")

# Seeded random-start fits are reproducible.
set.seed(123)
random_one <- kmeans_function(scale(x), centers = 3L, nstart = 25L,
                              iter.max = 100L)
set.seed(123)
random_two <- kmeans_function(scale(x), centers = 3L, nstart = 25L,
                              iter.max = 100L)
stopifnot(
  identical(random_one$cluster, random_two$cluster),
  isTRUE(all.equal(random_one$tot.withinss, random_two$tot.withinss))
)
cat("PASS: random starts are reproducible with a fixed seed.\n")
cat("All Lab 5 tests passed.\n")
