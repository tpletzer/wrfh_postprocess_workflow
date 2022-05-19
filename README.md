# wrfh_postprocess_workflow

## Requirements

You will need to have "Snakemake" installed. The easiest is to create a conda environment
```
conda create -p /path/to/snakemake_env
conda activate /path/to/snakemake_env
pip install snakemake
```

## How to run a simple test

Create some fake data, for example
```
mkdir input
touch input/stream_conc.csv
for n in 1 2 3 4; do
    touch input/$n_CHANOBS.nc
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

Now remove some output files and rerun the workflow. For instance, 
```
rm output/wrf-h_report.pdf
snakemake -j 1
```
will recreate the report.


