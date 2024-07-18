#!/usr/bin/env nextflow

include { igblastn } from '../../nextflow/modules.nf'

workflow {
    // Define parameters from input JSON
    output_directory = params.output_directory
    sample_id = params.sample_id
    organism = params.organism
    sequences = file(params.sequences)
    j_database = file(params.j_database)
    v_database = file(params.v_database)
    d_database = file(params.d_database)
    
    // Define the samples channel as a single tuple containing all necessary information
    samples = Channel
        .of(tuple(sample_id, organism, sequences, j_database, v_database, d_database))

    // Call the igblastn process with the samples channel
    igblastn(samples)
}
