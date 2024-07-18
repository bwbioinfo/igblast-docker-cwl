process igblastn {

    // Specifies where to publish the output files. Here, it's set to copy the files
    // to a directory named after the sample ID within the specified output directory.
    publishDir "${params.output_directory}/$sample_id", mode: 'copy'

    // Defines the Docker container to be used for this process. The container is pulled
    // from GitHub Container Registry (ghcr.io) and contains IGBLAST and CWL tools.
    container 'ghcr.io/bwbioinfo/igblast-docker-cwl:latest'

    // Defines the input parameters for the process.
    input:
    // Takes a tuple with the sample ID, organism, sequence file, J gene database,
    // V gene database, and D gene database.
    tuple val(sample_id), val(organism), file(sequences), file(j_database), file(v_database), file(d_database)

    // Defines the output parameter for the process.
    output:
    // The output path pattern specifies that any file matching '*.igblastn.out'
    // will be emitted and made available as 'output_file'.
    path '*.log', emit: output_file

    // The script section contains the command to be executed inside the Docker container.
    script:
    """
    echo "Running IGBLAST for sample: ${sample_id} and organism: ${organism}" > ${sample_id}-${organism}.log
    echo igblastn -germline_db_V ${v_database} \
        -germline_db_J ${j_database} \
        -germline_db_D ${d_database} \
        -organism ${organism} -query ${sequences} \
        -show_translation \
        -out ${sample_id}-${organism}.igblastn.out > ${sample_id}-${organism}.igblastn.log
    """
}
