source("renv/activate.R")
library("tidyverse")
library("mhealthtools")

acc_data <- read_csv(snakemake@input[[1]])
if(nrow(acc_data) == 0){
        features <- tibble(type=numeric(),axis=numeric(),mean=numeric(),complexity=numeric(),roughness=numeric(),rugosity=numeric(),mobility=numeric(),mean.frequency=numeric(),entropy.frequency=numeric(),energy1.0=numeric(),energy1.5=numeric(),energy2.0=numeric(),energy2.5=numeric(),energy3.0=numeric(),energy3.5=numeric())
} else {
        features <- accelerometer_features(acc_data, derived_kinematics = T)
        features <- features$extracted_features %>% 
                        select(type = measurementType, axis, mean = mean.tm, complexity = complexity.tm, roughness = rough.tm, rugosity = rugo.tm, mobility = mobility.tm, mean.frequency = mn.fr, entropy.frequency =  sh.fr, 
                                energy1.0 = EnergyInBand1,energy1.5 = EnergyInBand1_5,energy2.0 = EnergyInBand2, energy2.5 = EnergyInBand2_5, energy3.0 = EnergyInBand3, energy3.5 = EnergyInBand3_5 ) %>% 
                        filter(type %in% c("acceleration", "jerk"))
}
write_csv(features, snakemake@output[[1]])