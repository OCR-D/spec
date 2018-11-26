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

## Font Information

### Font family and typographic style plus characteristics

The font information (type, cut...) can be documented in PAGE XML in two places. Once as `custom` attribute value and another time using the `<TextStyle>` element. Both options can be used together.

| characterisation |goal  |
|--|--|
| The use of the `<page:TextStyle>` element is **the recommended solution** for an OCR-D compliant file. |**is  required**  |
| The use of the `custom` attribute is only a reference to Transkribus. |*is optional*  |



#### The first value, the use of the `<page:TextStyle>`

This information is **primarily recorded in the `<TextStyle>` element**. 

See: http://www.ocr-d.de/sites/all/gt_guidelines/pagecontent_xsd_Complex_Type_pc_TextStyleType.html?hl=textstyle

All Information are documented in element `<TextStyle>`

```xml
<TextStyle fontFamily="Arial" fontSize="17.0" bold="true"/>
```

However, since not all typographic information can be stored in TextStyle, this is in the case of:
- antiqua,
- fracturswitch and
- doubleunderlined
to use the custom attribute value.

#### The  second value, the use of ``custom`` attribute

As `custom` attribute value for the elements: `<TextLine>`, `<Word>`, it is also possible  `<TextRegion>`
here an example for *Textline*

```xml
<TextLine custom="textStyle {fontFamily:Arial; fontSize:17.0; bold:true;}">
```

The keyword for this information is textStyle. For the font: fontFamily, for the size: fontSize and for the typographic style the characteristic feature. 
See: http://www.ocr-d.de/sites/all/gt_guidelines/lyTypographie.html

### Font Informationen and her confidence

The degree of confidence of the font information can be specified as follows.
*Font or font group name*: [colon] *Confidence value*

Example

```xml
<TextStyle fontFamily="Arial:0.8, Times:0.7, Courier:0.4"/>`
<TextStyle fontFamily="Arial:0.8, Times:0.5"/>
<TextStyle fontFamily="Arial:0.7"/>

```

### Problems
Note: The fontFamily attribute should also be used for font cluster documentation.

1. **Different fonts** in the paragraph region:
  - **the recommended solution**
      -  `<TextStyle fontFamily="Arial, Times, Courier"/>`
      -  `<TextStyle fontFamily="Arial, Times"/>`
      -  `<TextStyle fontFamily="Arial"/>`
  - **the optional solution**
      - `<TextRegion custom="textStyle {fontFamily:Arial, Times, Courier; }">`
      -  `<TextLine custom="textStyle {fontFamily:Arial, Times; }">`
      -  `<Word custom="textStyle {fontFamily:Arial; }">`

2. **Different fonts** in typographic style 
  - **the recommended solution**  
       -  `<TextStyle bold="true"/>` only the whole TextRegion
       -  `<TextStyle bold="true"/>` only the whole TextLine
       -  `<TextStyle bold="true">` only the whole Word
  - **the optional solution**
       - `<TextRegion custom="textStyle {bold="true"}">`
       - `<TextLine custom="textStyle {bold="true"}">`
       - `<Word custom="textStyle {bold="true"}">`
       




### FAQ

1. **Question:** What If information in `<TextStyle>` is provided and clashes with information in custom?
   - **Answer:** The font information from Element `<TextStyle>` should be used primarily.
2. Question: Won't data consumers be required to parse custom anyway, if it can be redundant?
   - **Answer:** Only in the case of the following custom attribute values is the custom information to be extracted or stored as a value in this attribute.
      - antiqua,
      - fracturswitch and
      - double-underlined.
3. Question: Can TextStyle be used whereever we need it or do we need to change PAGE XML?
   - **Answer:** Yes, the `<TextStyle>` element is available for all necessary and important elements: 
      -  `<TextRegion>`, 
      -  `<TextLine>`, 
      -  `<Word>` and 
      -  `<Glyph>`.