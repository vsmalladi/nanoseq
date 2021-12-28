process M6ANET_DATAPREP {
    tag "$meta.id"
    label 'process_medium'

//  conda     (params.enable_conda ? "bioconda::nanopolish==0.13.2" : null) // need to get xpore onto conda
    container "docker.io/yuukiiwa/m6anet:1.0"

    input:
    tuple val(meta), path(genome), path(gtf), path(eventalign), path(nanopolish_summary)

    output:
    tuple val(meta), path("$meta.id"), emit: dataprep_outputs

    script:
    """
    m6anet-dataprep \\
    --eventalign $eventalign \\
    --out_dir $meta.id \\
    --n_processes $task.cpus
    """
}
