#!/bin/sh

## Script to run the Nextflow test pipeline on CAMP
## Copy this script to a working folder

## LOAD REQUIRED MODULES
ml purge
ml Nextflow/20.01.0
ml Singularity/3.4.2
ml Graphviz

## UPDATE PIPLINE
nextflow pull candiceh08/nextflow-test-pipeline

## RUN PIPELINE
nextflow run candiceh08/nextflow-test-pipeline \
-profile crick \
--num_gpus 0 \
--input '/camp/lab/luscomben/home/users/hermanc/projects/test_pipeline/rel3_fast5_subset'