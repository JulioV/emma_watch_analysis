# Analysis for APDM data from the Emma Watch study

## Installation

- Install Python 3.7 or older
- Install R 4.0 or newer
- Install conda or miniconda
-  `git clone https://github.com/JulioV/emma_watch_analysis.git`
- `conda env create -f environment.yml -n emma_watch`
- `conda activate emma_watch`
- `snakemake -j1 renv_install`
- `snakemake -j1 renv_restore`

## Run
- `snakemake -jX` where x is the number of CPU cores you want the pipeline to use
