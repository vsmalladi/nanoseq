process SNIFFLES {
    tag "$meta.id"
    label 'process_high'

    conda (params.enable_conda ? "bioconda::sniffles=1.0.7" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/sniffles:1.0.7--0' :
        'quay.io/biocontainers/sniffles:1.0.7--0' }"

    input:
    tuple val(meta), path(sizes), val(is_transcripts), path(bam), path(bai)


    output:
    path "*_sniffles.vcf"               , emit: sv_calls // vcf files
    path "versions.yml"                 , emit: versions


    script:
    """
    sniffles \
        -m  $bam \
        -v ${meta.id}_sniffles.vcf \
        -t $task.cpus

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sniffles: \$( echo \$(featureCounts -v 2>&1) | sed -e "s/featureCounts v//g") //need sniffles's version
    END_VERSIONS
    """
}

