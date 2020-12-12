rule extract_accelerometer_data:
    input:
        "data/external/EW{PID}/s{SESSION}_d{DAY}_{CONDITION}.mat",
        "data/external/repetition_times.csv"
    params:
        pid="{PID}",
        session="{SESSION}",
        day="{DAY}",
        repetition="{REPETITION}",
    output:
        "data/interim/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv",
        "data/interim/duration_audit/duration_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv"
    script:
        "../src/data/extract_accelerometer_data.R"

rule plot_accelerometer_data:
    input:
        "data/interim/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}.csv"
    output:
        lineplot="reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_lineplot.html",
        # histogram="reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_histogram.html"
    script:
        "../src/visualization/plot_accelerometer_data.R"

rule compute_accelerometer_features_r:
    input:
        "data/interim/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv"
    output:
        "data/processed/features_r_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv",
    script:
        "../src/features/compute_accelerometer_features.R"

rule compute_accelerometer_features_python:
    input:
        "data/interim/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv"
    params:
        pid = "{PID}"
    output:
        features = "data/processed/features_p_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv",
        plot_peaks_x="reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_peaksx.png",
        plot_peaks_y="reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_peaksy.png",
        plot_peaks_z="reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_peaksz.png",
        plot_peaks_m="reports/figures/EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}_peaksm.png",
    script:
        "../src/features/compute_accelerometer_features.py"

rule join_accelerometer_features:
    input:
        features_python = "data/processed/features_p_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv",
        features_r = "data/processed/features_r_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv",
    output:
        "data/processed/features_join_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv",
    script:
        "../src/features/join_accelerometer_features.R"

def get_features_all_participants(wildcards):
    files = []
    for pid in config["PIDS"].keys():
        for repetition in [1,2,3]:
            files.extend(expand("data/processed/features_join_EW{PID}_s{SESSION}_d{DAY}_{CONDITION}_{REPETITION}.csv", zip, PID=[pid] * len(config["PIDS"][pid]["SESSIONS"]), SESSION=config["PIDS"][pid]["SESSIONS"], DAY=config["PIDS"][pid]["DAYS"], CONDITION=config["PIDS"][pid]["CONDITIONS"],REPETITION=[repetition] * 3))
    return files

rule join_allparticipants_features:
    input:
        feature_files = get_features_all_participants
    output:
        "data/processed/allparticipants_features.csv",
    script:
        "../src/features/join_allparticipants_features.R"

rule plot_accelerometer_features:
    input:
        feature_files = get_features_all_participants
    params:
        type = "{type}",
        feature = "{feature}",
    output:
        "reports/figures/allparticipants_{type}_{feature}_bar.png",
    script:
        "../src/visualization/plot_accelerometer_features.R"

rule plot_box_accelerometer_features:
    input:
        feature_files = get_features_all_participants
    params:
        type = "{type}",
    output:
        "reports/figures/allparticipants_{type}_box.png",
    script:
        "../src/visualization/plot_box_accelerometer_features.R"

