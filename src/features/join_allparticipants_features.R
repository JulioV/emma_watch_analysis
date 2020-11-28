source("renv/activate.R")
library("tidyverse")

feature_files  <- snakemake@input[["feature_files"]]
features_of_all_participants <- tibble(filename = feature_files) %>% # create a data frame
  mutate(file_contents = map(filename, ~ read.csv(., stringsAsFactors = F, colClasses = c(local_date = "character"))),
         pid = paste(str_match(filename, ".*features_join_(.*)_(.*)_(.*)_[a|b|c|d]_(.*).csv")[,2], sep="_"),
         session = str_match(filename, ".*features_join_(.*)_(.*)_(.*)_(.*)_(.*).csv")[,3],
         day = str_match(filename, ".*features_join_(.*)_(.*)_(.*)_(.*)_(.*).csv")[,4],
         condition = str_match(filename, ".*features_join_(.*)_(.*)_(.*)_(.*)_(.*).csv")[,5],
         repetition = str_match(filename, ".*features_join_(.*)_(.*)_(.*)_(.*)_(.*).csv")[,6]) %>%
  unnest(cols = c(file_contents)) %>%
  select(-filename) %>% 
  # Get session mean features
  group_by(type, axis,pid,session,day,condition) %>% 
  summarise_all(list(~mean(., na.rm = TRUE), repetitions=~sum(!is.na(.)))) %>% 
  select(-repetition_mean) %>% 
  rename(repetitions = mean_repetitions) %>% # rename it so we keep it
  select(-contains("_repetitions")) %>% 
  ungroup() %>% 
  # Complete missing cases
  complete(type, axis, pid, condition) %>% 
  arrange(pid, type,condition,axis)
write_csv(features_of_all_participants, snakemake@output[[1]])
