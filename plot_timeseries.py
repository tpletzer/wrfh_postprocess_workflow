import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
import defopt

def plot_timeseries(*, save_dir: str='/nesi/nobackup/uoo03104/plots', station_name: str='bohner_b5'):

    """
    Plot timeseries of modelled and observed vs. datetime
    
    @param  save_dir directory to save timeseries png
    @param station_name LTER network name of stream gauge

    """

    df = pd.read_csv(f'{save_dir}/{station_name}.csv')
    df['DATE_TIME'] = pd.to_datetime(df['DATE_TIME'])

    
    fig, ax1 = plt.subplots(ncols=1,figsize=(12, 6))
    plt.suptitle(f'Hydrograph for {station_name}',fontsize=24)
    ax1.plot(df.DATE_TIME, df.streamflow_model,label='Model', color='blue')
    ax1.set_ylabel('Modelled (m3/s)', fontsize=14)

    ax2 = ax1.twinx()                                                                                                         
    ax2.plot(df.DATE_TIME, df.streamflow_obs, label='Observed', color='grey', linestyle='--')
    ax2.set_ylabel('Observed (m3/s)', fontsize=14)

    lines, labels = ax1.get_legend_handles_labels()
    lines2, labels2 = ax2.get_legend_handles_labels()
    ax2.legend(lines + lines2, labels + labels2)
    ax1.set_xlabel(f'Datetime (UTC)')

    plt.savefig(f'{save_dir}/timeseries_{station_name}.png')
    plt.close(fig)


if __name__ == "__main__":
    defopt.run(plot_timeseries)