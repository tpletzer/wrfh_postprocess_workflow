import glob
import re

configfile: "config.yaml"

# directory containing the netcdf and csv files
FILE_DIR = config['file_dir']
OB_DIR = config['ob_dir']
SAVE_DIR = config['save_dir']
OB_CSV = config['ob_csv']
STREAM_CSV = f'{OB_DIR}/{OB_CSV}'

NC_FILES = glob.glob(f"{FILE_DIR}/*CHANOBS*")


TIME_SERIES_PLOTS = [ re.sub(f'{FILE_DIR}/', f'{SAVE_DIR}/', re.sub(r'CHANOBS_DOMAIN1', 'TimeSeries.png', f)) for f in NC_FILES ]
SCATTER_PLOTS = [ re.sub(f'{FILE_DIR}/', f'{SAVE_DIR}/', re.sub(r'CHANOBS_DOMAIN1', 'Scatter.png', f) ) for f in NC_FILES]

STAT_CSV = f'{SAVE_DIR}/stat.csv'
AVG_CSV = f'{SAVE_DIR}/avg.csv'
REPORT_OUT = f"{SAVE_DIR}/wrf-h_report.pdf"

rule all:
    input:
        REPORT_OUT

rule produceReport:
    input:
        STAT_CSV,
        AVG_CSV,
        TIME_SERIES_PLOTS,
        SCATTER_PLOTS
    output:
        REPORT_OUT
    shell:
        "touch {output}"

rule produceAvg:
    input:
        STAT_CSV
    output:
        AVG_CSV
    shell:
        "touch {output}"

rule produceStat:
    input:
        NC_FILES,
        STREAM_CSV
    output:
        STAT_CSV
    shell:
        "touch {output}"

rule produceTimeSeriesPlots:
    input:
        NC_FILES,
        STREAM_CSV
    output:
        TIME_SERIES_PLOTS
    shell:
        "python timeseries.py --file-dir={FILE_DIR} --ob-dir={OB_DIR} --ob-csv={OB_CSV} --save-dir={SAVE_DIR}"

rule produceScatterPlots:
    input:
        NC_FILES,
        STREAM_CSV
    output:
        SCATTER_PLOTS
    shell:
        "touch {output}"
