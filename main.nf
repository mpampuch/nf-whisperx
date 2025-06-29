#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Parameters
params.input      = null
params.samplesheet = null
params.outdir     = "results"
params.help       = false

// Help message
def helpMessage() {
    log.info(
        """
    Usage:
    nextflow run main.nf --samplesheet samplesheet.csv --outdir results
    OR
    nextflow run main.nf --input "path/to/videos/*" --outdir results

    Required arguments (choose one):
      --samplesheet             Path to samplesheet CSV file with video files
      --input                   Path to input video files (glob pattern)
      --outdir                  Output directory (default: results)

    Samplesheet format:
      sample_id,video_path
      sample1,/path/to/video1.mp4
      sample2,/path/to/video2.avi

    WhisperX options:
      --whisperx_compute_type   Compute type for WhisperX (default: float32)
      --whisperx_model          WhisperX model to use (default: turbo)

    Optional arguments:
      --help                    Show this help message
    """.stripIndent()
    )
}

// Function to parse samplesheet
def parseSamplesheet(samplesheet_file) {
    def samplesheet_channel = Channel.fromPath(samplesheet_file, checkIfExists: true)
        .splitCsv(header: true, sep: ',')
        .map { row ->
            def meta = [:]
            meta.id = row.sample_id
            meta.single_end = true
            def video_file = file(row.video_path, checkIfExists: true)
            [meta, video_file]
        }
    return samplesheet_channel
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
    if (!params.input && !params.samplesheet) {
        log.error("Error: Either --input or --samplesheet parameter is required")
        helpMessage()
        exit(1)
    }
    
    if (params.input && params.samplesheet) {
        log.error("Error: Please provide either --input OR --samplesheet, not both")
        helpMessage()
        exit(1)
    }

    // Create input channel from video files
    if (params.samplesheet) {
        // Parse samplesheet
        video_files = parseSamplesheet(params.samplesheet)
    } else {
        // Use glob pattern
        video_files = Channel.fromPath(params.input, checkIfExists: true)
            .map { file ->
                def meta = [:]
                meta.id = file.baseName
                meta.single_end = true
                [meta, file]
            }
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
