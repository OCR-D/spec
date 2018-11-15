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

* `bag-info.txt` MUST additionally contain these tags:
  * [`BagIt-Profile-Identifier`](#bagit-profile-identifier): URL of the OCR-D BagIt profile
  * [`Ocrd-Identifier`](#ocrd-identifier): A globally unique identifier for this bag
  * [`Ocrd-Base-Version-Checksum`](#ocrd-base-version-checksum): Checksum of the version this bag is based on
* `bag-info.txt` MAY additionally contain these tags:
  * [`Ocrd-Mets`](#ocrd-mets): Alternative path to the mets.xml file if its path IS NOT `/data/mets.xml`
  * [`Ocrd-Manifestation-Depth`](#ocrd-manifestation-depth): Whether all URL are dereferenced as files or only some

### `BagIt-Profile-Identifier`

The `BagIt-Profile-Identifier` must be the string `https://ocr-d.github.io/bagit-profile.json`.

### `Ocrd-Mets`

By default, the METS file should be at `data/mets.xml`. If this file has
another name, it must be listed here and implementations MUST check for
`Ocrd-Mets` before assuming `data/mets.xml`.

### `Ocrd-Manifestation-Depth`

Specifiy whether the bag contains the full manifestation of the data referenced in the METS (`full`)
or only those files that were `file://` URLs before (`partial`). Default: `partial`.

### `Ocrd-Identifier`

A globally unique identifier identifying the work/works/parts of works this
bundle of file represents.

This is to be used for repositories to identify new ingestions of existing works.

To ensure global uniqueness, the identifier should be prefixed with an
identifier of the organization, e.g. an ISIL or domain name.

### `Ocrd-Base-Version-Checksum`

The SHA512 checksum of the `manifest-sha512.txt` file of the version this bag
was based on, if any.

## Invariants

### ZIP

An OCRD-ZIP MUST be a serialized as a ZIP file.

### `manifest-sha512.txt`

Checksums for the files in `/data` must be calculated with the `SHA512`
algorithm only and provided as `manifest-sha512.txt`.

Since the checksum of this manifest file can be relevant (see
[`Ocrd-Base-Version-Checksum`](#ocrd-base-version-checksum)), in addition to the requirements
of the BagIt spec, the entries MUST be sorted.

**NOTE:** These checksums can be generated with `find data -type f | sort -sf |xargs sha512sum > manifest-sha512.txt`.

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
    * If `Ocrd-Manifestation-Depth` is `partial`
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

<!-- BEGIN-EVAL -w '```yaml' '```' -- cat ./bagit-profile.yml  -->
```yaml
BagIt-Profile-Info:
  BagIt-Profile-Identifier: https://ocr-d.github.io/bagit-profile.json
  Source-Organization: OCR-D
  External-Description: BagIt profile for OCR data
  Contact-Name: Konstantin Baierer
  Contact-Email: konstantin.baierer@sbb.spk-berlin.de
  Version: 0.1
Bag-Info:
  Bagging-Date:
    required: false
  Source-Organization:
    required: false
  Ocrd-Mets:
    required: false
    default: 'data/mets.xml'
  Ocrd-Manifestation-Depth:
    required: false
    default: partial
    values: ["partial", "full"]
  Ocrd-Identifier:
    required: true
  Ocrd-Checksum:
    required: false
    # echo -n | sha512sum
    default: 'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e'
Manifests-Required: ['sha512']
Tag-Manifests-Required: []
Tag-Files-Required: []
Allow-Fetch.txt: true
Serialization: required
Accept-Serialization: application/zip
Accept-BagIt-Version:
  - '1.0'
```

<!-- END-EVAL -->

## Appendix B - IANA considerations

Proposed media type of OCRD-ZIP: `application/vnd.ocrd+zip`

Proposed extension: `.ocrd.zip`
