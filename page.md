# Conventions for PAGE

## Media Type

The [preliminary media type](https://github.com/OCR-D/spec/issues/33) of a PAGE
document is `application/vnd.prima.page+xml`, which MUST be used [as the `MIMETYPE` of a `<mets:file>`
representing a PAGE document](https://ocr-d.github.io/mets#media-type-for-page-xml).

## URL for imageFilename / filename

The `imageFilename` of the `<pg:Page>` and `filename` of the `<pg:AlternativeImage>` element MUST be a URL. A local filename should be a `file://` URL.

All URL used in `imageFilename` and `filename` [MUST be referenced in a fileGrp in METS](https://ocr-d.github.io/mets#if-in-page-then-in-mets).

## Original image as imageFilename

The `imageFilename` attribute of the `<pg:Page>` MUST reference the original image and MUST NOT change between processing steps.

## AlternativeImage for derived images

To encode images derived from the original image, the `<pc:AlternativeImage>` should be used. Its `filename` attribute should reference the URL of the derived image.

The `comments` attribute should be one or more (separated by comma) terms of the following list:

## AlternativeImage: classification

The `comments` attribute of the `<pg:AlternativeImage>` attribute should be used

  * `binarized`
  * `grayscale_normalized`
  * `deskewed`
  * `despeckled`
  * `cropped`
  * `rotated-90` / `rotated-180` / `rotated-270`
  * `dewarped`

## AlternativeImage on sub-page level elements

For the results of image processing that changes the positions of pixels (e.g. cropping, rotation, dewarping), `AlternativeImage` on page level and polygon of recognized zones is not enough to access the image section a region is based on since coordinates are always relative to the original image.

For such use cases, `<pg:AlternativeImage>` may be used as a child of `<pg:TextRegion>`, `<pg:TextLine>`, `<pg:Word>` or `<pg:Glyph>`.

## Attaching text recognition results to elements

A PAGE document can attach recognized text to different typographical units of
a page at different levels, such as block (`<pg:TextRegion>`), line
(`<pg:TextLine>`), word (`<pg:Word>`) or glyph (`<pg:Glyph>`).

To attach recognized text to an element `E`, it must be encoded as
`UTF-8` in a single `<pg:Unicode>` element `U` within a `<pg:TextEquiv>`
element `T` of `E`.

`T` must be the last element of `E`.

Leading and trailing whitespace (`U+0020`, `U+000A`) in the content of a
`<pg:Unicode>` is not significant and must be removed from the string by
processors.

To encode an actual space character at the start or end of the content
`<pg:Unicode>`, use a non-breaking space `U+00A0`.

## Consistency of text results on different levels

Since text results can be defined on different levels and those levels can
be nested, text results information is redundant. To avoid inconsistencies,
the following assertions must be true:

  * text of `<pg:Word>` must be equal to contained `<pg:Glyph>`'s text, concatenated with empty string
  * text of `<pg:TextLine>` must be equal to contained `<pg:Word>`'s text, concatenated with a single space (`U+0020`).
  * text of `<pg:TextRegion>` must be equal to contained `<pg:TextLine>`'s text, concatenated with a newline (`U+000A`).

**NOTE:** "Concatenation" means joining a list of strings with a separator, no
separator is added to the start or end of the resulting string.

If any of these assertions fails for a PAGE document, it should be considered invalid and not processed further.
