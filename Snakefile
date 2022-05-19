import glob
import re

# directory containing the netcdf and csv files. This could be read from 
# a config file if need be
INPUT_DIR = "input"

NC_FILES = glob.glob(f"{INPUT_DIR}/*CHANOBS*")
STREAM_CSV = f"{INPUT_DIR}/stream_conc.csv"

TIME_SERIES_PLOTS = [ re.sub(f'{INPUT_DIR}/', 'output/', re.sub(r'CHANOBS*', 'TimeSeries.png', f)) for f in NC_FILES ]
SCATTER_PLOTS = [ re.sub(f'{INPUT_DIR}/', 'output/', re.sub(r'CHANOBS*', 'Scatter.png', f) ) for f in NC_FILES]

STAT_CSV = "output/stat.csv"
AVG_CSV = "output/avg.csv"
REPORT_IN = "input/wrf-h_report.tex"
REPORT_OUT = "output/wrf-h_report.pdf"

rule all:
    input:
        REPORT_OUT

rule produceReport:
    input:
        REPORT_IN,
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
        "touch {output}"

rule produceScatterPlots:
    input:
        NC_FILES,
        STREAM_CSV
    output:
        SCATTER_PLOTS
    shell:
        "touch {output}"
