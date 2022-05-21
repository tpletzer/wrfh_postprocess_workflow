import glob
import re

configfile: "config.yaml"

# directory containing the netcdf and csv files
FILE_DIR = config['file_dir']
OB_DIR = config['ob_dir']
OB_CSV = config['ob_csv']
SAVE_DIR = config['save_dir']

STATION_NAMES = ["aiken_f5", "bohner_b5"] #, 'canada_f1', 'harnish_f11', 'lawson_b3', 'onyx_vnda', 'onyx_lwright']
expand(f"{sname}" for sname in STATION_NAMES)

NC_FILES = glob.glob(f"{FILE_DIR}/*CHANOBS*")

rule all:
    input:
        expand(f"{sname}.csv" for sname in STATION_NAMES)

# rule produceStationData:
#     input:
#         NC_FILES,
#         f'{OB_DIR}/{OB_CSV}'
#     output:
#         '{SAVE_DIR}/{sname}.csv'
#     shell:
#         "python generate_timeseries.py -f {FILE_DIR} --ob-dir={OB_DIR} --ob-csv={OB_CSV} --save-dir={SAVE_DIR} --station-name={sname}"


rule generate:
    output:
        "{sname}.csv"
    shell:
        "touch {output}"


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