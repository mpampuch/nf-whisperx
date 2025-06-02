process VIDEO_TO_MP3 {
    tag "${meta.id}"
    label 'process_medium'
    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(meta), path(input_file)

    output:
    tuple val(meta), path("${meta.id}.mp3"), emit: mp3
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    ffmpeg -i ${input_file} ${args} ${meta.id}.mp3

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ffmpeg: \$(ffmpeg -version | head -n 1 | sed 's/ffmpeg version //g' | cut -d' ' -f1)
    END_VERSIONS
    """

    stub:
    """
    touch ${meta.id}.mp3
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ffmpeg: 7.1.1
    END_VERSIONS
    """
}
