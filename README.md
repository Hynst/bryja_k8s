# Read mapping to genomic references using Nextflow and k8s

## Run analysis
Computations are running from bioit proxy (use ssh to connect). Analysis is then deploy to k8s on kuba cluster (bryja-bioit-ns).

1) Create sample config
```
cd /mnt/run/
bash create_config.sh /mnt/raw_fastq/${RUN_ID}/raw_fastq ${RUN_ID} ${species} 
``` 
species variable is either "human", "mouse" or "zebrafish". <br /> Sample config is in /mnt/config, generally $RUN_ID_$species.tsv. All samples are included, remove lines with unwanted samples.
  
2) Create analysis run folder, create analysis workdir
```
cd /mnt/run
mkdir ${RUN_ID}_${species}
cd ${RUN_ID}_${species}
mkdir tmp
```
3) Prepare analysis <br />
copy and edit run.sh script and nextflow.config
```
cd /mnt/run/${RUN_ID}_${species}
cp ../run.sh .
cp ../zaloha_nextflow.config nextflow.config
```
Edit run.sh variable according instructions <br />
Edit launchDir = 'EDIT' in nextflow.config to launchDir = '/mnt/run/$RUN_ID_$species'

4) Run analysis
```
bash run.sh
```
