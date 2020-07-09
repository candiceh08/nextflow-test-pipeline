#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

/*-----------------------------------------------------------------------------------------------------------------------------
Module inclusions
-------------------------------------------------------------------------------------------------------------------------------*/

include { check_max; build_debug_param_summary; luslab_header } from './luslab-nf-modules/tools/luslab_util/main.nf' /** required **/
include { guppy_basecaller } from './luslab-nf-modules/tools/guppy/main.nf' addParams (guppy_flowcell: 'FLO-MIN106', guppy_kit: 'SQK-LSK108')

/*-----------------------------------------------------------------------------------------------------------------------------
Parameters
-------------------------------------------------------------------------------------------------------------------------------*/

// Guppy parameters
params.input = "/Users/candicehermant/dev/data/genomic_assembly/rel3_fast5_subset"
//params.guppy_flowcell = "FLO-MIN106"
//params.guppy_kit = "SQK-LSK108"

/*-----------------------------------------------------------------------------------------------------------------------------
Init
-------------------------------------------------------------------------------------------------------------------------------*/

// Show banner and param summary
log.info luslab_header()
if(params.verbose)
    log.info build_debug_param_summary()

// Show work summary
def summary = [:]
summary['Metadata file'] = params.input
log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
log.info "-\033[2m------------------------------------------------------------------------\033[0m-"

// Check inputs
//check_params(["input"])

/*-----------------------------------------------------------------------------------------------------------------------------
Main workflow
-------------------------------------------------------------------------------------------------------------------------------*/

// Run workflow
workflow {
  guppy_basecaller( params.input )
}
workflow.onComplete {
}