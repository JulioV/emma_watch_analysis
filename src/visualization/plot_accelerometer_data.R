source("renv/activate.R")
library("tidyverse")
library("plotly")
library("htmlwidgets")

acc_data <- read.csv(snakemake@input[[1]])
lineplot <- plot_ly(acc_data, x = ~t, y = ~x, name = 'x', type = 'scatter', mode = 'lines') 
lineplot <- lineplot %>% add_trace(y = ~y, name = 'y', mode = 'lines') 
lineplot <- lineplot %>% add_trace(y = ~z, name = 'z', mode = 'lines')

timestamp_diff = diff(acc_data$t)
histogram <- plot_ly(x = timestamp_diff, type = "histogram")

htmlwidgets::saveWidget(as_widget(lineplot), paste0(getwd(), "/", snakemake@output[["lineplot"]]))
# htmlwidgets::saveWidget(as_widget(histogram), paste0(getwd(), "/", snakemake@output[["histogram"]]))