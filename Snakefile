configfile: "config.yaml"
include: "rules/renv.smk"
include: "rules/emma_watch.smk"

files = []

for pid in config["PIDS"].keys():
    for repetition in [1,2,3]:
        files.extend(expand("data/interim/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"], REPETITION=[repetition] * 3))
        files.extend(expand("reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_lineplot.html", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))
        # Duration audit
        files.extend(expand("data/interim/duration_audit/duration_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"], REPETITION=[3,3,3]))
        # R features
        files.extend(expand("data/processed/features_r_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))
        # Python features
        files.extend(expand("data/processed/features_p_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))
        files.extend(expand("reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_peaksx.png", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))
        files.extend(expand("reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_peaksy.png", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))
        files.extend(expand("reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_peaksz.png", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))
        files.extend(expand("reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_peaksm.png", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))
        # Join R and Python features
        files.extend(expand("data/processed/features_join_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))

# files.extend(expand("reports/figures/allparticipants_{type}_{feature}_bar.png", type=["acceleration", "jerk"], feature=['complexity','energy2.0','energy2.5','energy3.0','energy3.5','energy4.0','energy4.5','energy5.0','energy5.5','energy6.0','energy6.5','entropy.frequency','mean','mean.frequency','mobility','peaks','roughness','rugosity']))
# files.extend(expand("reports/figures/allparticipants_{type}_box.png", type=["acceleration", "jerk"]))
files.extend(["data/processed/allparticipants_features.csv"])

rule all:
    input:
        files


rule clean:
    shell:
        "rm -rf data/raw/* && rm -rf data/interim/* && rm -rf data/processed/* && rm -rf reports/figures/* && rm -rf reports/*.zip && rm -rf reports/compliance/*"