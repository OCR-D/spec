# Conventions for PAGE

## Media Type

The [preliminary media type](https://github.com/OCR-D/spec/issues/33) of a PAGE
document is `application/vnd.prima.page+xml`, which MUST be used [as the `MIMETYPE` of a `<mets:file>`
representing a PAGE document](https://ocr-d.github.io/mets#media-type-for-page-xml).

## One page in one PAGE

A single PAGE XML file represents one page in the original document.
Every `<pc:Page>` element MUST have an attribute `image` which MUST always be the source image.
The PAGE XML root element `<pc:PcGts>` MUST have exactly one `<pc:Page>`.

## Images

### URL for imageFilename / filename

The `imageFilename` of the `<pg:Page>` and `filename` of the `<pg:AlternativeImage>` element MUST be a URL. A local filename should be a `file://` URL.

All URL used in `imageFilename` and `filename` [MUST be referenced in a fileGrp in METS](https://ocr-d.github.io/mets#if-in-page-then-in-mets).

### Original image as imageFilename

The `imageFilename` attribute of the `<pg:Page>` MUST reference the original image and MUST NOT change between processing steps.

### AlternativeImage for derived images

To encode images derived from the original image, the `<pc:AlternativeImage>` should be used. Its `filename` attribute should reference the URL of the derived image.

The `comments` attribute should be one or more (separated by comma) terms of the following list:

### AlternativeImage: classification

The `comments` attribute of the `<pg:AlternativeImage>` attribute should be used

  * `binarized`
  * `grayscale_normalized`
  * `deskewed`
  * `despeckled`
  * `cropped`
  * `rotated-90` / `rotated-180` / `rotated-270`
  * `dewarped`

### AlternativeImage on sub-page level elements

For the results of image processing that changes the positions of pixels (e.g. cropping, rotation, dewarping), `AlternativeImage` on page level and polygon of recognized zones is not enough to access the image section a region is based on since coordinates are always relative to the original image.

For such use cases, `<pg:AlternativeImage>` may be used as a child of `<pg:TextRegion>`, `<pg:TextLine>`, `<pg:Word>` or `<pg:Glyph>`.

## `TextStyle`

Typographical information (type, cut etc.) must be documented in PAGE XML using the
`<TextStyle>` element.

See [the PAGE documentation on TextStyle](http://www.ocr-d.de/sites/all/gt_guidelines/pagecontent_xsd_Complex_Type_pc_TextStyleType.html?hl=textstyle) for all possible values.

The `<TextStyle>` element can be used in all relevant elements: 

  * `<TextRegion>`
  * `<TextLine>`
  * `<Word>`
  * `<Glyph>`

Example:

```xml
<Word>
  <TextStyle fontFamily="Arial" fontSize="17.0" bold="true"/>
  <!-- [...] -->
</Word>
```

### Font families

The `pg:TextStyle/@fontFamily` attribute can list one or more font
families, separated by comma (`,`).

```
font-families    := font-family ("," font-family)*
font-family      := font-family-name (":" confidence)?
font-family-name := ["A" - "Z" | "a" - "z" | "0" - "9"]+ | '"' ["A" - "Z" | "a" - "z" | "0" - "9" | " "]+ '"'
confidence       := ("0" | "1")? "." ["0" - "9"]+
```

Font family names that contain a space must be quoted with double quotes (`"`).

### Clusters of typesets

Sometimes it is necessary to not express that an element is typeset in a
specific **font family** but in font family from **a cluster of related font groups**.

For such typeset clusters, the `pg:TextStyle/@fontFamily` attribute should be re-used.

This specification doesn't restrict the naming of font families.
However, we recommend to choose one of the following list of type groups names if
applicable:

  * `textura`
  * `rotura`
  * `bastarda`
  * `antiqua`
  * `greek`
  * `hebrew`
  * `italic`
  * `fraktur`

### Font families and confidence

Providing multiple font families means that the element in
question is set in **one of the font families listed**.

It is not possible to declare that **multiple font families are used in an
element**. Instead, data producers are advised to increase output granularity
until every element is set in a single font family.

The degree of confidence in the font family can be expressed by concatenating
font family names with colon (`:`) followed by a float between `0` (information
is certainly wrong) and `1` (information is certainly correct).

If a font family is not suffixed with a confidence value, the confidence is
considered to be `1`.

Examples

```xml
<TextStyle fontFamily="Arial:0.8, Times:0.7, Courier:0.4"/>
<TextStyle fontFamily="Arial:.8, Times:0.5"/>
<TextStyle fontFamily="Arial:1"/>
<TextStyle fontFamily="Arial"/>
```
