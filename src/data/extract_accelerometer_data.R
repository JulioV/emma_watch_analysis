source("renv/activate.R")
library("R.matlab")
library("tidyverse")
library("dplyr")

matlab_data <- readMat(snakemake@input[[1]])
repetition_times <- read.csv(snakemake@input[[2]])
pid <- snakemake@params[["pid"]]
session <- snakemake@params[["session"]]
day <- snakemake@params[["day"]]
repetition <- snakemake@params[["repetition"]]

repetition_time <- repetition_times %>% 
  filter(pid == !!pid & day == !!day & session == !!session & repetition == !!repetition)

start <- repetition_time[["start"]]
end <- repetition_time[["end"]]

if(repetition == 3){
  write_csv(tibble(start = !!start,end = !!end, seconds = nrow(matlab_data$taskstream)/128, samples = nrow(matlab_data$taskstream)), snakemake@output[[2]])
}else{
  write_csv(tibble(start = NA,end = NA, seconds = NA, samples = NA), snakemake@output[[2]])
}

if(!is.na(start) & !is.na(end) & end > start){
  acc_data <- as_tibble(matlab_data$taskstream) %>%
    mutate(t = (row_number() - 1) * abs(matlab_data$tasktimestream[2] - matlab_data$tasktimestream[1])/ 1000000)%>%
    filter(t >= start & t <=end) %>% 
    select(t,
          x = V1,
          y = V2,
          z = V3)
  if(max(acc_data$t) < end-1) #discard incomplete repetitions (1 second tolerance)
    acc_data <- tibble(t=numeric(), x=numeric(), y=numeric(), z=numeric())
} else{
  acc_data <- tibble(t=numeric(), x=numeric(), y=numeric(), z=numeric())
}

write_csv(acc_data, snakemake@output[[1]])