import xarray as xr
import pandas as pd
import glob
from datetime import datetime
import defopt
import numpy as np


fid_dict = {
    'terminus': [227, 198],  #[i, j]
    'middle': [217, 211],
    'highelv': [209, 220],
    'soil': [208, 195],
    }


def LDASOUT_energybal_todf(*, file_dir: str='/nesi/project/uoo03104/code/wrf_hydroCrocus_mahuika/Taylor200_glac/NWM/*LDASOUT*', 
    save_dir: str='/nesi/nobackup/uoo03104/plots', station_name: str='soil', start_index: int=0, end_index: int=-1):
    
    files = glob.glob(file_dir)
    files = sorted(files)

    end_index = min(len(files), end_index)

    DATETIME = []
    albedo = []
    swdown = []
    lwdown = []
    fira = []
    fsa = []
    sag = []
    lh = []
    grdflx = []
    hfx = []

    pix_i = fid_dict[station_name][0]
    pix_j = fid_dict[station_name][1]

    for file in files[start_index:end_index]:
        ds = xr.open_dataset(file,decode_times=False)

        albedo.append(ds['ALBEDO'][:,pix_j,pix_i].values)
        swdown.append(ds['SWFORC'][:,pix_j,pix_i].values)
        lwdown.append(ds['LWFORC'][:,pix_j,pix_i].values)
        fira.append(ds['FIRA'][:,pix_j,pix_i].values)
        fsa.append(ds['FSA'][:,pix_j,pix_i].values)
        sag.append(ds['SAG'][:,pix_j,pix_i].values)
        lh.append(ds['LH'][:,pix_j,pix_i].values)
        grdflx.append(ds['GRDFLX'][:,pix_j,pix_i].values)
        hfx.append(ds['HFX'][:,pix_j,pix_i].values)

        DATETIME.append(file.split('/')[-1].split('.')[0])

    
    lst = []
    comp = [swdown, albedo, lwdown, fira, fsa, sag, lh, grdflx, hfx]
    col_names = ["SWFORC", "ALBEDO", "LWFORC", "FIRA", "FSA", "SAG", "LH", "GRDFLX", "HFX"]

    for ind in range(len(swdown)):
        lst2 = []
        for val in comp:
            lst2.append(val[ind][0])
        lst.append(lst2)

    df = pd.DataFrame(lst, index=pd.to_datetime(DATETIME), columns=col_names)

    df_dailycyc = df.groupby([df.index.hour]).mean()

    df.to_csv(f'{save_dir}/{station_name}_energybal.csv')

    df_dailycyc.to_csv(f'{save_dir}/{station_name}_dailycyc.csv')


if __name__=='__main__':
    defopt.run(LDASOUT_energybal_todf)

