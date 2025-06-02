# Wave Configuration for nf-whisperx

This pipeline has been configured to use Seqera Wave for containerization of the WhisperX environment.

## What Changed

1. **Wave enabled**: The pipeline now uses Wave to automatically build containers from conda environments
2. **Container strategy**: Wave will build a container using the `envs/whisperx.yml` conda environment
3. **Docker support**: The pipeline will automatically create and use Docker containers with WhisperX installed

## Benefits

- **Reproducibility**: Consistent environment across different systems
- **No local conda issues**: Wave handles environment creation in containers
- **Faster execution**: Containers are cached and reused
- **Cross-platform**: Works on different architectures

## Usage

Run the pipeline as usual:

```bash
nextflow run main.nf --input "path/to/videos/*" --outdir results
```

Wave will automatically:
1. Build a container with WhisperX and dependencies
2. Cache the container for future runs
3. Execute the WHISPERX process in the containerized environment

## Requirements

- Docker or Singularity/Apptainer installed
- Internet connection for initial container build
- Nextflow 23.04.0 or later

## Troubleshooting

If you encounter issues:
1. Ensure Docker is running and accessible
2. Check internet connectivity for container building
3. Verify the conda environment file `envs/whisperx.yml` is present