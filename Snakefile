import glob
import re

configfile: "config.yaml"

# directory containing the netcdf and csv files
FILE_DIR = config['file_dir']
OB_DIR = config['ob_dir']
OB_CSV = config['ob_csv']
SAVE_DIR = config['save_dir']

STATION_NAMES = ['aiken_f5', 'bohner_b5'] #, 'canada_f1', 'harnish_f11', 'lawson_b3', 'onyx_vnda', 'onyx_lwright']
STATION_FILES = [f'{SAVE_DIR}/{sname}.csv' for sname in STATION_NAMES]

NC_FILES = glob.glob(f"{FILE_DIR}/*CHANOBS*")


rule all:
    input:
        STATION_FILES

rule produceStation_aiken_f5:
    input:
        NC_FILES,
        f'{OB_DIR}/{OB_CSV}'
    output:
        "{SAVE_DIR}/aiken_f5.csv"
    shell:
        "python generate_timeseries.py -f {FILE_DIR} --ob-dir={OB_DIR} --ob-csv={OB_CSV} --save-dir={SAVE_DIR} --station-name='aiken_f5'"

rule produceStation_bohner_b5:
    input:
        NC_FILES,
        f'{OB_DIR}/{OB_CSV}'
    output:
        "{SAVE_DIR}/bohner_b5.csv"
    shell:
        "python generate_timeseries.py -f {FILE_DIR} --ob-dir={OB_DIR} --ob-csv={OB_CSV} --save-dir={SAVE_DIR} --station-name='bohner_b5'"
