# wrfh_postprocess_workflow

## Requirements

You will need to have "Snakemake" installed. The easiest is to create a conda environment
```
conda create -p /path/to/snakemake_env
conda activate /path/to/snakemake_env
conda install -c conda-forge -c bioconda snakemake
```

## How to run a simple test

Create some fake data, for example
```
mkdir input
touch input/stream_conc.csv
touch input/wrf-h_report.tex
for n in 1 2 3 4; do
    touch input/${n}_CHANOBS.nc
done
```

Check that the workflow runs:
```
snakemake --dry-run
```

Run the workflow using 4 workers
```
snakemake -j 4
```

The `output` directory will coontain the output files, including the intermediate files:
```
$ ls output/
1_Scatter.png.nc	2_TimeSeries.png.nc	4_Scatter.png.nc	stat.csv
1_TimeSeries.png.nc	3_Scatter.png.nc	4_TimeSeries.png.nc	wrf-h_report.pdf
2_Scatter.png.nc	3_TimeSeries.png.nc	avg.csv
```

Now remove some output files and rerun the workflow. For instance, 
```
rm output/wrf-h_report.pdf
snakemake -j 1
```
will recreate only the report.


## To do 

Edit the Snakefile and replace the sections
```
    shell:
        "touch {output}"
```
with the appropriate commands.

You can specifyy the directory where the input files are located in the `config.yaml` file.



