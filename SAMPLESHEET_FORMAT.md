# Samplesheet Format

The samplesheet should be a CSV file with a single column header `video_path` containing the full paths to your video or audio files.

## Example:

```csv
video_path
/path/to/test-video_1-speaker_background-music.mkv
/path/to/another-video.mp4
/path/to/audio-file.wav
```

## Output Structure:

Each video/audio file will generate its own subdirectory named `{basename}_TRANSCRIPTS` containing:

- `{basename}.json` - Full transcript with timestamps and speaker information
- `{basename}.txt` - Plain text transcript
- `{basename}.srt` - SubRip subtitle format
- `{basename}.vtt` - WebVTT subtitle format  
- `{basename}.tsv` - Tab-separated values format
- `{basename}.{ext}` - Symlink to the original video/audio file

Where `{basename}` is the filename without extension and `{ext}` is the original file extension.

## Usage:

```bash
nextflow run main.nf --samplesheet samplesheet.csv --outdir results
```

Or with direct input:

```bash
nextflow run main.nf --input "path/to/videos/*" --outdir results
```

## Example Output Structure:

```
results/
└── test-video_1-speaker_background-music_TRANSCRIPTS/
    ├── test-video_1-speaker_background-music.json
    ├── test-video_1-speaker_background-music.mkv -> /path/to/original/test-video_1-speaker_background-music.mkv
    ├── test-video_1-speaker_background-music.srt
    ├── test-video_1-speaker_background-music.tsv
    ├── test-video_1-speaker_background-music.txt
    └── test-video_1-speaker_background-music.vtt
```