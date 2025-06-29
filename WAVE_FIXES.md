# Wave Configuration Fixes

## Problem
The pipeline was failing with Wave because:
- Wave was disabled in nextflow.config
- Docker was disabled in nextflow.config  
- Conda was disabled in nextflow.config
- Wave couldn't find the container image `community.wave.seqera.io/library/python_whisperx:09a8ea82ecde4819`

## Solution
Updated `nextflow.config` to properly enable Wave with conda environments:

### Changes Made:

1. **Enabled Wave**:
   ```groovy
   wave {
       enabled = true  // was false
       strategy = ['conda','container']
   }
   ```

2. **Enabled Docker**:
   ```groovy
   docker {
       enabled = true  // was false
       runOptions = '-u $(id -u):$(id -g)'
   }
   ```

3. **Enabled Conda**:
   ```groovy
   conda {
       enabled = true  // was false
       cacheDir = "$HOME/.conda/cache"
   }
   ```

4. **Proper Process Configuration**:
   - VIDEO_TO_MP3: Uses pre-built Wave ffmpeg containers
   - WHISPERX: Uses conda environment file `envs/whisperx/whisperx.yml`

## Result
- Wave now successfully builds containers from conda environments
- The pipeline works with `nextflow run main.nf --samplesheet example_samplesheet.csv --outdir OUTPUTS -with-wave`
- No more "container image does not exist" errors

## Test Files Created
- `example_samplesheet.csv`: Sample samplesheet for testing
- `test_data/sample1.mp4` and `test_data/sample2.mp4`: Test video files