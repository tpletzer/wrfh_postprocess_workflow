import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
import numpy as np
import defopt

def plot_scatter(*, save_dir: str='/nesi/nobackup/uoo03104/plots', station_name: str='bohner_b5'):


    """
    Plot scatterplot of modelled vs. observed
    
    @param  save_dir directory to save timeseries png
    @param station_name LTER network name of stream gauge

    """
    df = pd.read_csv(f'{save_dir}/{station_name}.csv')
    df['DATE_TIME'] = pd.to_datetime(df['DATE_TIME'])

    
    fig, ax = plt.subplots(ncols=1,figsize=(12, 6))
    plt.suptitle(f'Streamflow at {station_name}',fontsize=24)
    ax.scatter(df.streamflow_obs, df.streamflow_model)

    lims = [
    np.min([ax.get_xlim(), ax.get_ylim()]),  # min of both axes
    np.max([ax.get_xlim(), ax.get_ylim()]),  # max of both axes
    ]
    
    ax.plot(lims, lims, 'k-', alpha=0.75, zorder=0)
    ax.set_aspect('equal')
    ax.set_xlim(lims)
    ax.set_ylim(lims)

    ax.set_ylabel(f'Modelled streamflow (m3/s)', fontsize=12)
    ax.set_xlabel(f'Observed streamflow (m3/s)', fontsize=12)

    plt.savefig(f'{save_dir}/scatter_{station_name}.png')
    plt.close(fig)

if __name__ == "__main__":
    defopt.run(plot_scatter)
