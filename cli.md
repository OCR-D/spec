# Command Line Interface (CLI)

**NOTE:** Command line options cannot be repeated. To specify multiple values,
provide a single string with comma-separated items (e.g. `-I
group1,group2,group3` instead of `-I group1 -I group2 -I group3`).

## CLI executable name

All CLI provided by MP must be standalone executables, installable into `$PATH`.

Every CLI executable's name must begin with `ocrd-`.

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

### `-g, --group-id ID`

The `mets:div[@TYPE='page']/@ID` that contains the pointers to files
representing a page. Effectively, only those files in the [input file
group](#-i---input-file-grp-grp) that are referenced in these
`mets:div[@TYPE="page"]` will be processed.

### `-p, --parameter PARAM_JSON`

URL of parameter file in JSON format.

### `-l, --log-level LOGLEVEL`

Set the global maximum verbosity level. More verbose log entries will be
ignored. (One of `OFF`, `ERROR`, `WARN`, `INFO` (default), `DEBUG`, `TRACE`).

**NOTE:** Setting the log level via `--log-level` parameter should override any
other implementation-specific means of logging configuration. For example, with
`--log-level TRACE` no log messages should be filtered globally, whereas
`--log-level ERROR`, only errors should be output globally.

### `-J, --dump-json`

Instead of processing METS, output the [ocrd-tool](ocrd_tool) description for
this executable, in particular its parameters.

## Return value

Successful execution should signal `0`. Any non-zero return value is considered a failure.

## Logging

Data printed to `STDERR` and `STDOUT` is captured linewise and stored as log data.

Processors must adjust logging verbosity according to the [`--log-level` parameter](#-l---log-level-loglevel).

Errors, especially those leading to exceptions, must be printed to `STDERR`.

The log messages must have the format `TIME LEVEL LOGGERNAME - MESSAGE\n`, where

* `TIME` is the current time in the format `HH:MM:ss.mmm`, e.g. `07:05:31.007`
* `LEVEL` is the log level of the message, in uppercase, e.g. `INFO`
* `LOGGERNAME` is the name of the logging component, such as the class name. Segments of `LOGGERNAME` should be separated by dot `.`, e.g. `ocrd.fancy_tool.analyze`
* `MESSAGE` is the message to log, should not contain new lines.
* `\n` is ASCII char `0x0a` (newline)

## URL/file convention

Whenever a URL is expected, it should be possible to use a local file path
instead and have the implementation interpret as a `file://` URL on the fly.

Implementations should adhere to this algorithm when resolving a URL `u`:

1. If `u` contains the string `://`: Do not modify.
2. If `u` is an absolute path according to the mechanics of the underlying file system: Prepend `file://` to `u`.
3. Otherwise: Resolve `u` as a path relative to the current working directory, prepend `file://` to `u`.

**NOTE:** This convention is limited to the CLI for convenience of users and
developers. In METS and PAGE documents, URLs must be strictly valid and
resolvable by common software agents as-is.

## Example

This is how the CLI provided by the MP should work:

```sh
$> ocrd-kraken-binarize \
    --mets "file:///path/to/file/mets.xml" \
    --working-dir "file:///path/to/workingDir/" \
    --parameters "file:///path/to/file/parameters.json" \
    --group-id OCR-D-IMG_0001,OCR-D-IMG_0002,OCR-D-IMG_0003 \
    --input-file-grp OCR-D-IMG
    --output-file-grp OCR-D-IMG-BIN-KRAKEN
```

And this is how it will be called with the `ocrd` CLI:

```sh
$> ocrd process \
    -m "file:///path/to/file/mets.xml" \
    -w "file:///path/to/workingDir/" \
    -p "file:///path/to/file/parameters.json" \
    -g OCR-D-IMG_0001,OCR-D-IMG_0002,OCR-D-IMG_0003 \
    -I OCR-D-IMG \
    -O OCR-D-IMG-BIN-KRAKEN
    
    preprocessing/binarization/kraken-binarize
```

### METS input

```xml
<mets:mets>
    <!-- ... -->

  <mets:fileSec>
      
    <mets:fileGrp USE="OCR-D-IMG">
      <mets:file ID="OCR-D-IMG_0001" GROUPID="OCR-D-IMG_0001" MIMETYPE="image/tiff">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000001.tif" />
      </mets:file>
      <mets:file ID="OCR-D-IMG_0002" GROUPID="OCR-D-IMG_0002" MIMETYPE="image/tiff">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000002.tif" />
      </mets:file>
      <mets:file ID="OCR-D-IMG_0003" GROUPID="OCR-D-IMG_0003" MIMETYPE="image/tiff">
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

### METS output

This is the METS file after being run through the MP CLI:

```xml
<mets:mets>
    <!-- ... -->

  <mets:fileSec>
      
    <mets:fileGrp USE="OCR-D-IMG">
      <mets:file ID="OCR-D-IMG_0001" GROUPID="OCR-D-IMG_0001" MIMETYPE="image/tiff">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000001.tif" />
      </mets:file>
      <mets:file ID="OCR-D-IMG_0002" GROUPID="OCR-D-IMG_0002" MIMETYPE="image/tiff">
        <mets:FLocat LOCTYPE="URL" xlink:href="https://github.com/OCR-D/spec/raw/master/io/example/00000002.tif" />
      </mets:file>
      <mets:file ID="OCR-D-IMG_0003" GROUPID="OCR-D-IMG_0003" MIMETYPE="image/tiff">
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
