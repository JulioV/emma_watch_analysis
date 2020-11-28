from scipy import signal
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

acc_data = pd.read_csv(snakemake.input[0])
pid = snakemake.params["pid"]
features_file = snakemake.output["features"]
plot_peaks_x = snakemake.output["plot_peaks_x"]
plot_peaks_y = snakemake.output["plot_peaks_y"]
plot_peaks_z = snakemake.output["plot_peaks_z"]

def plotSmoothedPeaks(timestamps, data, peaks, file, pid, axis):
    #https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.find_peaks.html
    # Plot Velocity vs time
    fig, ax = plt.subplots(dpi=400)
    plt.plot(timestamps, data)
    plt.plot(timestamps[peaks], data[peaks], "x")

    plt.title("{} : acceleration {} axis peaks ".format(pid, axis))
    plt.xlabel('Time (s)')
    plt.ylabel('Acceleration (g)')
    plt.savefig(file)

duration = acc_data['t'].max() - acc_data['t'].min()

# find peaks (local maxima) of velocity
peaks_x, _ = signal.find_peaks(acc_data['x'])
plotSmoothedPeaks(acc_data["t"], acc_data["x"], peaks_x, plot_peaks_x, pid, "x")

peaks_y, _ = signal.find_peaks(acc_data['y'])
plotSmoothedPeaks(acc_data["t"], acc_data["y"], peaks_y, plot_peaks_y, pid, "x")

peaks_z, _ = signal.find_peaks(acc_data['z'])
plotSmoothedPeaks(acc_data["t"], acc_data["z"], peaks_z, plot_peaks_z, pid, "x")


# intialise data of lists. 
features = {'type':['acceleration', 'acceleration', 'acceleration'],'axis':["x", "y","z"], 'peaks':[len(peaks_x), len(peaks_y), len(peaks_z)], 'normalised_peaks':[len(peaks_x)/duration, len(peaks_y)/duration, len(peaks_z)/duration]} 
features = pd.DataFrame(features).replace(0, np.nan) 
features.to_csv(features_file, index = False)