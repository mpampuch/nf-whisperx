#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Parameters
params.input  = null
params.outdir = "results"
params.help   = false

// Help message
def helpMessage() {
    log.info(
        """
    Usage:
    nextflow run main.nf --input "path/to/videos/*" --outdir results

    Required arguments:
      --input                   Path to input video files (glob pattern)
      --outdir                  Output directory (default: results)

    WhisperX options:
      --whisperx_compute_type   Compute type for WhisperX (default: float32)
      --whisperx_model          WhisperX model to use (default: turbo)

    Optional arguments:
      --help                    Show this help message
    """.stripIndent()
    )
}


// Include processes
include { VIDEO_TO_MP3 } from './modules/ffmpeg.nf'
include { WHISPERX } from './modules/whisperx.nf'

workflow {
    // Show help message if requested
    if (params.help) {
        helpMessage()
        exit(0)
    }

    // Validate required parameters
    if (!params.input) {
        log.error("Error: --input parameter is required")
        helpMessage()
        exit(1)
    }
    // Create input channel from video files
    video_files = Channel.fromPath(params.input, checkIfExists: true)
        .map { file ->
            def meta = [:]
            meta.id = file.baseName
            meta.single_end = true
            [meta, file]
        }

    // Convert videos to MP3
    VIDEO_TO_MP3(video_files)
    
    // Transcribe MP3 files using WhisperX
    WHISPERX(VIDEO_TO_MP3.out.mp3)
}


workflow.onComplete {
    log.info("Pipeline completed at: ${workflow.complete}")
    log.info("Execution status: ${workflow.success ? 'OK' : 'failed'}")
    log.info("Results saved to: ${params.outdir}")
}
