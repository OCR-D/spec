# OCRD-ZIP

This document describes an exchange format to bundle a workspace described by a
[METS file following OCR-D's conventions](mets).

## Rationale

METS is the exchange format of choice by OCR-D for describing relations of
files such as images and metadata about those images such as PAGE or ALTO
files. METS is a textual format, not suitable for embedding arbitrary,
potentially binary, data. For various use cases (such as transfer via network,
long-term preservation, reproducible tests etc.) it is desirable to have a
self-contained representation of a workspace. With such a representation, data
producers are not forced to provide dereferencable HTTP-URL for the files they
produce and data consumers are not forced to dereference all HTTP-URL.

While METS does have mechanisms for embedding XML data and even base64-encoded
binary data, the tradeoffs in file size, parsing speed and readability are too
great to make this a viable solution for a mass digitization scenario.

Instead, OCRD-ZIP is based on the widely used ZIP format which allows
representing file hierarchies in a standardized, compressable archive format.
Many formats like JAR (used in software development) and BagIt (used in
long-term preservation) use the same principles: A zip file containing a
manifest of contained resources and the resources themselves. For OCRD-ZIP, the
METS file is the manifest.

## Format

### ZIP

An OCRD-ZIP MUST be a valid ZIP file.

### `mets.xml` in the root folder

The root folder of the ZIP filetree must contain a file `mets.xml`.

### `file://`-URLs must be relative

All resources referenced in the METS with a `file://`-URL (and consequently all
those referenced in other files within the workspace -- see rule "When in PAGE
then in METS") must be referenced by `file://`-URL that must be relative to the
root location of the workspace.

Right:
* `file://foo.xml`
* `file://foo.tif`
* `http://server/foo.tif`

Wrong:
* `file:///absolute/path/somewhere/foo.tif`

### When in ZIP then in METS

All files except `mets.xml` itself that are contained in the OCRD-ZIP must be
referenced in a `file/Flocat` in the `mets.xml`.

## Packing a workspace as OCRD-ZIP

To pack a workspace to OCRD-ZIP:

* Create a temporary folder `TMP`
* Copy source METS to `TMP/mets.xml`
* Foreach file `f` in `TMP/mets.xml`:
  * If it is not a `file://`-URL, continue
  * Copy the file to a location `TMP`. The structure SHOULD be `<USE>/<ID>` where
    * `<USE>` is the `USE` attribute of the parent `mets:fileGrp`
    * `<ID>` is the `ID` attribute of the `mets:file`
  * Replace the URL of `f` with `file://<USE>/<ID>` in
    * all `mets:FLocat` of `TMP/mets.xml`
    * all other files in the workspace
* zip the directory with the `zip` utility

## Unpacking OCRD-ZIP to a workspace

* Unzip OCRD-ZIP `z` to a folder `TMP` (e.g. `/tmp/folder-1`)
* Foreach file `f` in `TMP/mets.xml`:
  * If it is not a `file://`-URL, continue
  * Replace the URL of `f` with `file://<ABSPATH>`, where `<ABSPATH>` is the absolute path to `f`, in
    * `TMP/mets.xml
    * all files within `TMP`

## IANA considerations

Proposed media type of OCRD-ZIP: `application/vnd.ocrd+zip`

Proposed extension: `.ocrd.zip`
