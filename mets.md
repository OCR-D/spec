# Requirements on handling METS/PAGE

OCR-D has decided to base its data exchange format on top of [METS](http://www.loc.gov/standards/mets/).

For layout and text recognition results, the primary exchange format is [PAGE](https://github.com/OCR-D/PAGE-XML)

This document defines a set of conventions and mechanism for using these formats.

## Pixel density of images must be explicit and high enough

The pixel density is the ratio of the number of pixels that represent a a unit of measure of the scanned object. It is typically measured in pixels per inch (PPI, a.k.a. DPI).

The original input images MUST have >= 150 ppi.

Every processing step that generates new images and changes their dimensions MUST make sure to adapt the density explicitly when serialising the image.

```sh
$> exiftool input.tif |grep 'X Resolution'
"300"

# WRONG (ppi unchanged)
$> convert input.tif -resize 50% output.tif

# RIGHT:
$> convert input.tif -resize 50% -density 150 -unit inches output.tif

$> exiftool output.tif |grep 'X Resolution'
"150"
```

## Unique ID for the document processed

METS provided to the MP must be uniquely addressable within the global library community.

For this purpose, the METS file MUST contain a `mods:identifier` that must contain a globally unique identifier for the document and have a `type` attribute with a value of, in order of preference:

* `purl`
* `urn`
* `handle`
* `url`


## File Group id syntax

All `mets:fileGrp` must have a `USE` attribute that hints at the provenance of the files. It MUST have the structure

```
ID := "OCR-D-" + WORKFLOW_STEP + ("-" + PROCESSOR)?
WORKFLOW_STEP := ("IMG" | "SEG" | "OCR" | "COR")
PROCESSOR := [A-Z0-9\-]{3,}
```

`WORKFLOW_STEP` can be one of:

- `IMG`: Image(s)
- `SEG`: Segmented page / regions
- `OCR`: OCR produced from image
- `COR`: Post-correction

`PROCESSOR` should be a mnemonic of the processor or result type in a terse, all-caps form, such as the name of the tool (`KRAKEN`) or the organisation `CIS` or the type of manipulation (`CROP`) or a combination of both starting with the type of manipulation (`BIN-KRAKEN`).

### Examples

`<mets:fileGrp USE>` | Type of use for OCR-D
-- | --
`<mets:fileGrp USE=”OCR-D-IMG”>` | The unmanipulated source images
`<mets:fileGrp USE=”OCR-D-IMG-BIN”>` | Black-and-White images
`<mets:fileGrp USE=”OCR-D-IMG-CROP”>` | Cropped images
`<mets:fileGrp USE=”OCR-D-IMG-DESKEW”>` | Deskewed images
`<mets:fileGrp USE=”OCR-D-IMG-DESPECK”>` | Despeckled images
`<mets:fileGrp USE=”OCR-D-IMG-DEWARP”>` | Dewarped images
`<mets:fileGrp USE=”OCR-D-SEG-PAGE”>` | Page segmentation
`<mets:fileGrp USE=”OCR-D-SEG-BLOCK”>` | Block segmentation
`<mets:fileGrp USE=”OCR-D-SEG-LINE”>` | Line segmentation
`<mets:fileGrp USE=”OCR-D-SEG-WORD”>` | Word segmentation
`<mets:fileGrp USE=”OCR-D-SEG-GLYPH”>` | Glyph segmentation
`<mets:fileGrp USE=”OCR-D-OCR-TESS”>` | Tesseract OCR
`<mets:fileGrp USE=”OCR-D-OCR-ANY”>` | AnyOCR
`<mets:fileGrp USE=”OCR-D-COR-CIS”>` | CIS post-correction
`<mets:fileGrp USE=”OCR-D-COR-ASV”>` | ASV post-correction

## File ID syntax

The `ID` attribute of a `mets:file` SHOULD be the `USE` of the containing `mets:fileGrp` combined with a 4-zero-padded number.

```
FILEID := ID + "_" + [0-9]{4}
ID := "OCR-D-" + WORKFLOW_STEP + ("-" + PROCESSOR)?
WORKFLOW_STEP := ("IMG" | "SEG" | "OCR" | "COR")
PROCESSOR := [A-Z0-9\-]{3,}
```

## Grouping files with GROUPID

Files in multiple `mets:fileGrp` with different `USE` can represent the fact that they encode the same page by using the same `GROUPID`.

If used, the `GROUPID` of the page MUST BE the `ID` of the file that represents the original image. In other words: For the file representing the original image, `ID` and `GROUPID` must be identical.

### Example

```xml
<mets:fileGrp USE="OCR-D-IMG">
    <mets:file ID="OCR-D-IMG_0001" GROUPID="OCR-D-IMG_0001">...</mets:file>
</mets:fileGrp>
<mets:fileGrp USE="OCR-D-OCR">
    <mets:file ID="OCR-D-OCR_0001" GROUPID="OCR-D-IMG_0001">...</mets:file>

</mets:fileGrp>
```

## Images and coordinates

Coordinates are always absolute, i.e. relative to extent defined in the `imageWidth`/`imageHeight` attribute of the nearest `<pc:Page>`.

When a processor wants to access the image of a layout element like a TextRegion or TextLine, the algorithm should be:

- If the element in question has an attribute `imageFilename`, resolve this value
- If the element has a `<pc:Coords>` subelement, resolve by passing the attribute `imageFilename` of the nearest `<pc:Page>` and the `points` attribute of the `<pc:Coords>` element

## One page in one PAGE

A single PAGE XML file represents one page in the original document.

Every `<pc:Page>` element MUST have an attribute `image` which MUST always be the source image.

The PAGE XML root element `<pc:PcGts>` MUST have exactly one `<pc:Page>`.

## Always use URL everywhere

Always use URL. If it's a local file, prefix absolute path with `file://`.

### Example

```xml
<mets:fileGrp USE="OCR-D-SEG-PAGE">
    <mets:file ID="OCR-D-SEG-PAGE_0001" GROUPID="OCR-D-IMG_0001" MIMETYPE="text/xml">
        <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink" LOCTYPE="URL" xlink:href="file:///path/to/workingDir/segmentation/page/page_0001.xml" />
    </mets:file>
</mets:fileGrp>
```

## If in PAGE then in METS

Every image URL referenced via `imageFileName` or the `filename` attribute of any `pc:AlternativeImage` MUST be represented in the METS file as a `mets:file` with corresponding `mets:FLocat@xlink:href`. 
