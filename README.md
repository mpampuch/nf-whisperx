# nf-whisperx

This repository contains code to transcribe audio and video files locally using WhisperX.

## Usage

### Option 1: Using a samplesheet (recommended)

Create a CSV samplesheet with the following format:

```csv
sample_id,video_path
sample1,/path/to/video1.mp4
sample2,/path/to/video2.avi
sample3,/path/to/video3.mov
```

Run the pipeline:

```bash
nextflow run main.nf --samplesheet samplesheet.csv --outdir results
```

### Option 2: Using glob patterns

```bash
nextflow run main.nf --input "path/to/videos/*" --outdir results
```

## Parameters

- `--samplesheet`: Path to CSV samplesheet file with video files
- `--input`: Path to input video files (glob pattern) 
- `--outdir`: Output directory (default: results)
- `--whisperx_compute_type`: Compute type for WhisperX (default: float32)
- `--whisperx_model`: WhisperX model to use (default: turbo)

## Output

The pipeline generates the following output files for each input video:
- `.mp3`: Converted audio file
- `.json`: Transcript with timestamps and speaker diarization
- `.txt`: Plain text transcript
- `.srt`: Subtitle file
- `.vtt`: WebVTT subtitle file
