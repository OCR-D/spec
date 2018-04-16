# Command Line Interface (CLI)

## CLI binary name

All CLI provided by MP must be standalone binaries, installable into `$PATH`.

Every CLI binary's name must begin with `ocrd-`.

Examples:
  * `ocrd-kraken-binarize`
  * `ocrd-tesserocr-recognize`

## Mandatory parameters

### `-m, --mets METS_IN`

Input METS URL

### `-w, --working-dir DIR`

Working Directory.

### `-I, --input-file-grp GRP`

File group(s) used as input.

### `-O, --output-file-grp GRP`

File group(s) used as output.

## Optional parameters

### `-g, --group-id GROUPID`

The `mets:file@GROUPID` to process. If no groupID is defined all files within the `inputGrp` will be processed. Repeatable and multiple IDs can be provided separated by comma.

### `-p, --parameter PARAM_JSON`

URL of parameter file in JSON format

### `-l, --log-level LOGLEVEL`

Minimum Log level. One of `OFF`, `ERROR`, `WARN`, `INFO` (default), `DEBUG`, `TRACE`).

Actual mechanism for filtering log messages must not be implemented by
processors.

### `-o, --output-mets METS_OUT`

File path where processor MUST write resulting METS to. If not set, output METS is expected to be in the file `mets.xml` in the working directory.

## Return value

Successful execution should signal `0`. Any non-zero return value is considered a failure.

## Logging

Data printed to `STDERR` and `STDOUT` is captured linewise and stored as log data.

Processors can adjust their logging verbosity according to the `--log-level` parameter but they are not required to.

Errors, especially those leading to an exception, should be printed to `STDERR`.

## Example

This is how the CLI provided by the MP should work:

```sh
$> ocrd-kraken-binarize \
    --mets "file:///path/to/file/mets.xml" \
    --working-dir "file:///path/to/workingDir/" \
    --output-mets /path/to/workingDir/metsOutput.xml \
    --parameters "file:///path/to/file/parameters.json" \
    --group-id OCR-D-IMG_0001,OCR-D-IMG_0002 \
    --group-id OCR-D-IMG_0003 \
    -input-file-grp OCR-D-IMG \
    -output-file-grp OCR-D-IMG-BIN-KRAKEN
```

And this is how it will be called with the `ocrd` CLI:

```sh
$> ocrd process \
    -m "file:///path/to/file/mets.xml" \
    -w "file:///path/to/workingDir/" \
    -o /path/to/workingDir/metsOutput.xml \
    -p "file:///path/to/file/parameters.json" \
    -g OCR-D-IMG_0001,OCR-D-IMG_0002 \
    -g OCR-D-IMG_0003 \
    -I OCR-D-IMG \
    -O OCR-D-IMG-BIN-KRAKEN
    
    preprocessing/binarization/kraken-binarize
```

### Description

Binarize images from METS file with GROUPIDs id0001, id0002 and id0003.

### Input METS file

```xml
<mets:mets>
    <!-- ... -->

  <mets:fileSec>
      
    <mets:fileGrp USE="OCR-D-IMG">
      <mets:file ID="OCR-D-IMG_0001" GROUPID="OCR-D-IMG_0001" MIMETYPE="image/tif">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000001.tif" />
      </mets:file>
      <mets:file ID="OCR-D-IMG_0002" GROUPID="OCR-D-IMG_0002" MIMETYPE="image/tif">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000002.tif" />
      </mets:file>
      <mets:file ID="OCR-D-IMG_0003" GROUPID="OCR-D-IMG_0003" MIMETYPE="image/tif">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000003.tif" />
      </mets:file>
    </mets:fileGrp>
      
  </mets:fileSec>
</mets:mets>
```

### Input JSON parameter file

```json
{
    "threshold": 0.05,
    "zoom": 2,
    "range": [5, 10],
}
```

### Output METS file

This is the METS file as it is returned by the MP CLI:

```xml
<mets:mets>
    <!-- ... -->

  <mets:fileSec>
      
    <mets:fileGrp USE="OCR-D-IMG">
      <mets:file ID="OCR-D-IMG_0001" GROUPID="OCR-D-IMG_0001" MIMETYPE="image/tif">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000001.tif" />
      </mets:file>
      <mets:file ID="OCR-D-IMG_0002" GROUPID="OCR-D-IMG_0002" MIMETYPE="image/tif">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000002.tif" />
      </mets:file>
      <mets:file ID="OCR-D-IMG_0003" GROUPID="OCR-D-IMG_0003" MIMETYPE="image/tif">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000003.tif" />
      </mets:file>
    </mets:fileGrp>
      
    <mets:fileGrp USE="OCR-D-IMG-BIN-KRAKEN">
      <mets:file ID="OCR-D-IMG-BIN-KRAKEN_0001" GROUPID="OCR-D-IMG_0001" MIMETYPE="image/png">
        <mets:FLocat LOCTYPE="URL" xlink:href="file:///tmp/ocrd-workspace-ABC123/0001.png" />
      </mets:file>
      <mets:file ID="OCR-D-IMG-BIN-KRAKEN_0002" GROUPID="OCR-D-IMG_0002" MIMETYPE="image/png">
        <mets:FLocat LOCTYPE="URL" xlink:href="file:///tmp/ocrd-workspace-ABC123/0002.png" />
      </mets:file>
      <mets:file ID="OCR-D-IMG-BIN-KRAKEN_0003" GROUPID="OCR-D-IMG_0003" MIMETYPE="image/png">
        <mets:FLocat LOCTYPE="URL" xlink:href="file:///tmp/ocrd-workspace-ABC123/0003.png" />
      </mets:file>
    </mets:fileGrp>
      
  </mets:fileSec>
</mets:mets>
```
