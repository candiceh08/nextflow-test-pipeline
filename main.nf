#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

/*-----------------------------------------------------------------------------------------------------------------------------
Module inclusions
-------------------------------------------------------------------------------------------------------------------------------*/

include simple_metadata from './luslab-nf-modules/tools/metadata/main.nf'
include { check_max; build_debug_param_summary; luslab_header } from './luslab-nf-modules/tools/luslab_util/main.nf' /** required **/
include { guppy_basecaller } from './luslab-nf-modules/tools/guppy/main.nf' addParams (guppy_flowcell: 'FLO-MIN106', guppy_kit: 'SQK-LSK108')
include { guppy_qc } from './luslab-nf-modules/tools/guppy/main.nf'

/*-----------------------------------------------------------------------------------------------------------------------------
Parameters
-------------------------------------------------------------------------------------------------------------------------------*/

// Guppy parameters
params.input = "/Users/candicehermant/dev/data/genomic_assembly/rel3_fast5_subset"

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
  // Run guppy_basecaller
    guppy_basecaller ( ch_fast5 )
    guppy_qc ( guppy_basecaller.out.summary )

    // Collect file names and view output
    guppy_basecaller.out.basecalledSeq | view
    guppy_qc.out.report | view
}