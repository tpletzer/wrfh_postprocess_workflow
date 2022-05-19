import glob

NC_FILES = glob.glob("input/*CHANOBS*")
STREAM_CSV = "input/stream_conc.csv"

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
        AVG_CSV
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

