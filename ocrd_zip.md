# OCRD-ZIP

This document describes an exchange format to bundle a workspace described by a
[METS file following OCR-D's conventions](/mets).

## Rationale

METS is the exchange format of choice by OCR-D for describing relations of
files such as images and metadata about those images such as PAGE or ALTO
files. METS is a textual format, not suitable for embedding arbitrary,
potentially binary, data. For various use cases (such as transfer via network,
long-term preservation, reproducible tests etc.) it is desirable to have a
self-contained representation of a [workspace](/mets).

With such a representation, data producers are not forced to provide
dereferencable HTTP-URL for the files they produce and data consumers are not
forced to dereference all HTTP-URL.

While METS does have mechanisms for embedding XML data and even base64-encoded
binary data, the tradeoffs in file size, parsing speed and readability are too
great to make this a viable solution for a mass digitization scenario.

Instead, we propose an exchange format ("OCRD-ZIP") based on the BagIt spec
used for data ingestion adopted in the web archiving community.

## BagIt profile

As a baseline, an OCRD-ZIP must adhere to [v0.97+ of the BagIt
specs](https://tools.ietf.org/html/draft-kunze-bagit-16), i.e.

* all files in `data/`
* a file `bagit.txt`
* a file `bag-info.txt`

In accordance with the BagIt standard, `bagit.txt` MUST consist of exactly
these two lines:

```
BagIt-Version: 1.0
Tag-File-Character-Encoding: UTF-8
```

In addition, OCRD-ZIP adhere to a [BagIt
profile](https://github.com/bagit-profiles/bagit-profiles) (see [Appendix A for
the full definition](#appendix-a)):

* `bag-info.txt` MAY additionally contain these tags:
  * `X-Ocrd-Mets`: Alternative path to the mets.xml file if its path IS NOT `/data/mets.xml`
  * `X-Ocrd-Manifestation-Depth`: Whether all URL are dereferenced as files or only some

### `X-Ocrd-Mets`

By default, the METS file should be at `data/mets.xml`. If this file has
another name, it must be listed here and implementations MUST check for
`X-Ocrd-Mets` before assuming `data/mets.xml`.

### `X-Ocrd-Manifestation-Depth`

Specifiy whether the bag contains the full manifestation of the data referenced in the METS (`full`)
or only those files that were `file://` URLs before (`partial`). Default: `partial`.

### ZIP

An OCRD-ZIP MUST be a serialized as a ZIP file.

## Invariants

### `file://`-URLs must be relative

All resources referenced in the METS with a `file://`-URL (and consequently all
those referenced in other files within the workspace -- see rule "When in PAGE
then in METS") must be referenced by `file://`-URL that is absolute with root
being the root location of the workspace, i.e. they MUST begin with
`file:///data`

Right:
* `file:///data/foo.xml`
* `file:///data/foo.tif`
* `http:///data/server/foo.tif`

Wrong:
* `file:///absolute/path/somewhere/foo.tif`

### When in data then in METS

All files except `mets.xml` itself that are contained in `data` directory must
be referenced in a `mets:file/mets:Flocat` in the `mets.xml`.

## Algorithms

### Packing a workspace as OCRD-ZIP

To pack a workspace to OCRD-ZIP:

* Create a temporary folder `TMP`
* Copy mets.xml to `TMP/data/mets.xml`
* Foreach `mets:file` `f` in `TMP/data/mets.xml`:
  * If it is not a `file://`-URL
    * If `X-Ocrd-Manifestation-Depth` is `partial`
      continue
  * Download/Copy the file to a location within `TMP/data`. The structure SHOULD be `<USE>/<ID>` where
    * `<USE>` is the `USE` attribute of the parent `mets:fileGrp`
    * `<ID>` is the `ID` attribute of the `mets:file`
  * Replace the URL of `f` with `file:///data/<USE>/<ID>` in
    * all `mets:FLocat` of `TMP/data/mets.xml`
    * all other files in the workspace, esp. PAGE-XML
* Package `TMP` as a BagIt bag

### Unpacking OCRD-ZIP to a workspace

* Unzip OCRD-ZIP `z` to a folder `TMP`
* Foreach file `f` in `TMP/data/mets.xml`:
  * If it is not a `file://`-URL, continue
  * Replace the URL of `f` with `file://<ABSPATH>`, where `<ABSPATH>` is the absolute path to `f`, in
    * `TMP/data/mets.xml`
    * all files within `TMP`, esp. PAGE-XML

## Appendix A - BagIt profile definition

<!-- BEGIN-EVAL -w '```yaml' '```' -- cat ./bagit_ocrd_profile.yml  -->
```yaml
Bagit-Profile-Info:
  Bagit-Profile-Identifier: https://ocr-d.github.io/bagit_ocrd.json
  Source-Organization: OCR-D
  External-Description: BagIt profile for OCR data
  Version: 0.1
Bag-Info:
  Bagging-Date:
    required: false
  Source-Organization:
    required: false
  X-Ocrd-Mets:
    default: 'data/mets.xml'
  X-Ocrd-Manifestation-Depth:
    default: partial
    values: ["partial", "full"]
Manifests-Required:
  - md5
  - sha512
Allow-Fetch.txt: false
Serialization: required
Accept-Serialization: application/zip
Accept-BagIt-Version:
  - 1.0
  - 0.97
  - 0.96
```

<!-- END-EVAL -->

## Appendix B - IANA considerations

Proposed media type of OCRD-ZIP: `application/vnd.ocrd+zip`

Proposed extension: `.ocrd.zip`
