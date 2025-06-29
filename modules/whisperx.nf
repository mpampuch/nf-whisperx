process WHISPERX {
    tag "${meta.id}"
    label 'process_high'
    publishDir "${params.outdir}/${meta.id}_TRANSCRIPTS", mode: 'copy'

    input:
    tuple val(meta), path(mp3_file), path(original_video)

    output:
    tuple val(meta), path("${meta.id}.json"), emit: transcript
    tuple val(meta), path("${meta.id}.txt"), emit: text
    tuple val(meta), path("${meta.id}.srt"), emit: srt
    tuple val(meta), path("${meta.id}.vtt"), emit: vtt
    tuple val(meta), path("${meta.id}.tsv"), emit: tsv
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def compute_type = params.whisperx_compute_type ?: 'float32'
    def model = params.whisperx_model ?: 'turbo'
    def basename = mp3_file.baseName
    """
    whisperx \\
        --compute_type ${compute_type} \\
        --model "${model}" \\
        --threads ${task.cpus} \\
        ${args} \\
        ${mp3_file}

    # Rename output files to include sample ID (only if different)
    if [ -f "${basename}.json" ] && [ "${basename}" != "${meta.id}" ]; then
        mv ${basename}.json ${meta.id}.json
    fi
    if [ -f "${basename}.txt" ] && [ "${basename}" != "${meta.id}" ]; then
        mv ${basename}.txt ${meta.id}.txt
    fi
    if [ -f "${basename}.srt" ] && [ "${basename}" != "${meta.id}" ]; then
        mv ${basename}.srt ${meta.id}.srt
    fi
    if [ -f "${basename}.vtt" ] && [ "${basename}" != "${meta.id}" ]; then
        mv ${basename}.vtt ${meta.id}.vtt
    fi
    if [ -f "${basename}.tsv" ] && [ "${basename}" != "${meta.id}" ]; then
        mv ${basename}.tsv ${meta.id}.tsv
    fi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        whisperx: \$(python -c "import whisperx; print(whisperx.__version__)" 2>/dev/null || echo "unknown")
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """

    stub:
    """
    touch ${meta.id}.json
    touch ${meta.id}.txt
    touch ${meta.id}.srt
    touch ${meta.id}.vtt
    touch ${meta.id}.tsv
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        whisperx: "3.1.1"
        python: "3.8.0"
    END_VERSIONS
    """
}
