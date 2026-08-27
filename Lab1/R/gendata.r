######################################################
#                                                    #
# Lab1: Basic function and project directory         #
#                                                    #
# R/gendata.r                                        #
#                                                    #
# Generate a dataframe containing 10,000 observations#
#                                                    #
######################################################


set.seed(123)

n <- 10000

df <- data.frame(
  educ = rpois(n, lambda = 12),
  income = round(
    rlnorm(n, meanlog = log(50000), sdlog = 0.5),
    digits = 2
  )
)

df$educ <- pmin(pmax(df$educ, 0), 20)

write.csv(df, file = "./data-raw/lab1.csv", row.names = FALSE)
