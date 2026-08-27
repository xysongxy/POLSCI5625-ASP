######################################################
#                                                    #
# Lab1: Basic function and project directory         #
#                                                    #
# tests/lab1_test.r                                  #
#                                                    #
# A simple test script                               #
#   1. Load the lab1.r script                        #
#   2. Laod the data                                 #
#   3. Calculate the sample mean                     #
#   4. Run the test                                  #
#                                                    #
######################################################

# 1. Load the lab1.r script

functions_path <- file.path("R", "lab1.r")

if (!file.exists(functions_path)) {
  stop(
    paste0(
      "Cannot find '", functions_path, "'. ",
      "Set the working directory to the Lab1 project folder and try again."
    ),
    call. = FALSE
  )
}

source("R/lab1.r")

# 2. Read the data and compute the sample mean

data_path <- file.path("data-raw", "lab1.csv")

if (!file.exists(data_path)) {
  stop(
    paste0(
      "Cannot find '", data_path, "'. ",
      "Save the simulated data in the Lab1/data folder first."
    ),
    call. = FALSE
  )
}

dat <- read.csv("data-raw/lab1.csv")

# 3. Draw a random sample

n <- 500
seed <- 123

sample_one <- draw_sample(
  pop = dat,
  n = n,
  seed = seed
)

mean_educ <- compute_sample_mean(
  sample = sample_one,
  variable = "educ"
)

mean_income <- compute_sample_mean(
  sample = sample_one,
  variable = "income"
)

cat("Sample size:", nrow(sample_one), "\n")
cat("Mean of education level:", mean_educ, "\n")
cat("Mean of income:", mean_income, "\n")

# 4. Test 1 - Identity/Reproducibility

sample_two <- draw_sample(
  pop = dat,
  n = n,
  seed = seed
)

stopifnot(identical(sample_one, sample_two))
cat("PASS: the same seed produces an identical sample.\n")

# 5. Test 2 - Impossible sample size

error <- tryCatch(
  {
    draw_sample(
      pop = dat,
      n = nrow(dat) + 1,
      seed = seed
    )
    NA_character_
  },
  error = function(e) {
    conditionMessage(e)
  }
)

stopifnot(
  !is.na(error),
  grepl("cannot exceed population size", error, fixed = TRUE)
)

cat("PASS: an oversized sample returns an informative error.\n")
cat("Error message:", error, "\n")

# 6. Save the selected sample

write.csv(sample_one, file = "data/sample_500.csv", row.names = FALSE)
