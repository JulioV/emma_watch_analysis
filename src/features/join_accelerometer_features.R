source("renv/activate.R")
library("tidyverse")

features_python  <- read_csv(snakemake@input[["features_python"]])
features_r  <- read_csv(snakemake@input[["features_r"]])
features <-  full_join(features_r, features_python, by=c("type", "axis"))

write_csv(features, snakemake@output[[1]])
