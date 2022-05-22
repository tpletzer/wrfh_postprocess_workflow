import xarray as xr
import matplotlib.pyplot as plt
import pandas as pd
import pytz
from pandas.plotting import register_matplotlib_converters
import glob
from datetime import datetime
import defopt


fid_dict = {
    'aiken_f5': 2, 
    'bohner_b5': 14,
    'canada_f1': 20,
    'harnish_f11': 35,
    'lawson_b3': 43,
    'onyx_vnda': 55,
    'onyx_lwright': 56,
    }


def main_chanobs(*, file_dir: str='/nesi/nobackup/output_files', 
                ob_dir: str='/nesi/nobackup/uoo03104/validation_data/streamgagedata', 
                ob_csv: str='stream_conc.csv',
                save_dir: str='/nesi/nobackup/uoo03104/plots', station_name: str='bohner_b5'):  
    """
    Postprocessing workflow of channel observations

    @param file_dir directory of model output netcdfs
    @param  ob_dir directory of observation csv
    @param ob_csv name of csv file for observations
    @param  save_dir directory to save timeseries png
    @param station_name LTER network name of stream gauge


    """

    chanobs_baseline = xr.open_mfdataset(f'{file_dir}/*CHANOBS*', combine='by_coords') #open model output netcdfs

    #extract time from the first and last file in sim (in UTC)
    files = glob.glob(f'{file_dir}/*CHANOBS*')
    files = sorted(files)
    t0_str = files[0].split('/')[-1].split('.')[0] #extract first time stamp of simulation
    t0_utc = pd.Timestamp(t0_str,tz='UTC') # convert to time
    t0_mcm = t0_utc.tz_convert('Antarctica/Mcmurdo') #convert to mcm timezone
    t0 = str(t0_mcm)[0:-6] #id for observation csv

    tf_str = files[-1].split('/')[-1].split('.')[0] #extract last time stamp of simulation
    tf_utc = pd.Timestamp(tf_str,tz='UTC') # convert to time
    tf_mcm = tf_utc.tz_convert('Antarctica/Mcmurdo') #convert to mcm timezone
    tf = str(tf_mcm)[0:-6] #id for observation csv '2018-12-13 14:00:00'
    # breakpoint()
    #open observational data
    obs = pd.read_csv(f'{ob_dir}/{ob_csv}', dtype=str)
    obs = obs[obs['STRMGAGEID']==station_name]
    obs['DATE_TIME'] = pd.to_datetime(obs['DATE_TIME']) #convert DATE_TIME to date time obj
    obs['DISCHARGE RATE']=pd.to_numeric(obs['DISCHARGE RATE'])
    
    obs = obs.loc[obs.DATE_TIME >= t0, :] # extract same times as the simulation in local time
    obs = obs.loc[obs.DATE_TIME <= tf, :] 

    obs_piv = obs.pivot(index="DATE_TIME", columns="STRMGAGEID", values="DISCHARGE RATE") # DISCHARGE RATE is in cubic m/s and includes canada
    obs_piv.index = obs_piv.index.tz_localize('Antarctica/Mcmurdo').tz_convert('UTC') 
    obs_piv = obs_piv.resample('H').mean()

    df = pd.DataFrame()
    df['streamflow_obs'] = []
    df['streamflow_model'] = []
    df['time'] = []

    #if station_name in fid_dict:
    if obs_piv.empty:
        print(f'WARNING: station name {station_name} has no stream gage data')
        df = obs_piv
    else:
        fid = fid_dict[station_name]
        obs_station = obs_piv[station_name]
        model_station = chanobs_baseline.sel(feature_id=fid).streamflow
        time = obs_piv.index
        df['streamflow_obs'] = obs_station
        df['streamflow_model'] = model_station
        df['time'] = time
        
    df.to_csv(f'{save_dir}/{station_name}.csv')


if __name__ == "__main__":
    defopt.run(main_chanobs)