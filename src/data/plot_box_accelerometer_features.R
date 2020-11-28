source("renv/activate.R")
library("tidyverse")
library("purrr")
library("stringr")
library("gridExtra")

feature_files  <- snakemake@input[["feature_files"]]
measurement_type  <- snakemake@params[["type"]]

features_of_all_participants <- tibble(filename = feature_files) %>% # create a data frame
  mutate(file_contents = map(filename, ~ read.csv(., stringsAsFactors = F, colClasses = c(local_date = "character"))),
         pid = paste(str_match(filename, ".*features_join_(.*)_(.*)_(.*)_[a|b|c|d].csv")[,2], str_match(filename, ".*features_join_(.*)_(.*)_(.*)_[a|b|c|d].csv")[,4], sep="_"),
         session = str_match(filename, ".*features_join_(.*)_(.*)_(.*)_(.*).csv")[,3],
         condition = str_match(filename, ".*features_join_(.*)_(.*)_(.*)_(.*).csv")[,5]) %>%
  unnest(cols = c(file_contents)) %>%
  select(-filename)

features_long <- features_of_all_participants %>% pivot_longer(cols = c(-type, -axis, -condition, -pid, -session), names_to = "feature", values_to = "value")
features_complete <- features_long  %>% complete(pid, nesting(type, axis, condition, feature), fill = list("value" = NA))
features_complete <- features_complete %>%  filter(type == measurement_type)


box <- ggplot(features_complete %>% filter(!is.na(value)), aes(x=condition, y=value, color = condition)) + 
  geom_boxplot() +
  geom_dotplot(binaxis='y', stackdir='center', dotsize=0.5, fill = "black", stroke = 0) +
  facet_grid(feature ~ axis, scales = "free")

ggsave(filename = snakemake@output[[1]], box, height = 40, dpi=600)