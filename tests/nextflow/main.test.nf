#!/usr/bin/env nextflow

include { igblastn } from '../../nextflow/modules.nf'

workflow {
    // Define parameters from input JSON
    output_directory = params.output_directory
    organism = params.organism
    j_database = params.j_database
    v_database = params.v_database
    d_database = params.d_database

    // Define the input directory and create a channel with all sequence files
    input_directory = file(params.input_directory)
    sequence_files = Channel
        .fromPath("${input_directory}/*")
        .map { file -> 
            def sample_id = file.baseName
            tuple(sample_id, file, organism, j_database, v_database, d_database)
        }

    // Call the igblastn process with the sequence_files channel
    igblastn(sequence_files)
}
