import glob
import re

configfile: "config.yaml"

# directory containing the netcdf and csv files
FILE_DIR = config['file_dir']
OB_DIR = config['ob_dir']
OB_CSV = config['ob_csv']
SAVE_DIR = config['save_dir']
STATION_NAMES = config['station_names'] #, 'canada_f1', 'harnish_f11', 'lawson_b3', 'onyx_vnda', 'onyx_lwright']

NC_FILES = glob.glob(f"{FILE_DIR}/*CHANOBS*")

rule all:
    input:
        expand(f'{SAVE_DIR}/timeseries_{sname}.png' for sname in STATION_NAMES),
        expand(f'{SAVE_DIR}/scatter_{sname}.png' for sname in STATION_NAMES)

rule clean:
    shell:
        "rm {SAVE_DIR}/*.csv {SAVE_DIR}/*.png *.html"

rule produceStationData:
    input:
        NC_FILES,
        f'{OB_DIR}/{OB_CSV}'
    output:
        "{SAVE_DIR}/{sname}.csv"
    shell:
        "python generate_timeseries.py -f {FILE_DIR} --ob-dir={OB_DIR} --ob-csv={OB_CSV} --save-dir={SAVE_DIR} --station-name={wildcards.sname}"

rule createTimeseriesPlot:
    input:
        "{SAVE_DIR}/{sname}.csv"
    output:
        report("{SAVE_DIR}/timeseries_{sname}.png", category="timeseries plot")
    shell:
        "python plot_timeseries.py --save-dir={SAVE_DIR} --station-name={wildcards.sname}"

rule createScatterPlot:
    input:
        "{SAVE_DIR}/{sname}.csv"
    output:
        report("{SAVE_DIR}/scatter_{sname}.png", category="scatter plot")
    shell:
        "python plot_scatter.py --save-dir={SAVE_DIR} --station-name={wildcards.sname}"



# CASES = ["a", "b"]
# expand(f"{case}" for case in CASES)

# rule all:
#     input:
#         expand(f"{case}.txt" for case in CASES)

# rule clean:
#     shell:
#         "rm *.txt"

# rule generate:
#     output:
#         "{case}.txt"
#     shell:
#         "touch {output}"