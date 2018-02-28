# OCR-D interfaces

## Input output data

Input:
  - [METS](https://www.loc.gov/standards/mets/) file ([OCR-D profile](https://github.com/OCR-D/spec/blob/master/services.md#mets-profile))
  - User-defined parameters
  
Output:
  - [METS](https://www.loc.gov/standards/mets/) file ([OCR-D profile](https://github.com/OCR-D/spec/blob/master/services.md#mets-profile))
  - Process metadata ([provenance](https://en.wikipedia.org/wiki/Data_lineage#Data_Provenance))
  
### Input preparation

Information:
  - [PAGE-XML](https://github.com/PRImA-Research-Lab/PAGE-XML) file (OCR-D profile)

Level of operation:
  - Document

#### METS profile

METS files must contain a minimum of one [`<fileSec>`](https://www.loc.gov/standards/mets/docs/mets.v1-9.html#fileSec) element with at least two distinct [`<fileGrp>`](https://www.loc.gov/standards/mets/docs/mets.v1-9.html#fileGrp) children, one for images and one for textual content.
```xml
<fileSec>
  <fileGrp USE="IMAGE"> <!-- master input images -->
    <file ID="name" MIMETYPE="image/tif" /> <!-- single page image id -->
    <FLocat LOCTYPE="URL" xlink:href="..." /> <!-- URL to image -->
  </fileGrp>
  ...
  <fileGrp USE="FULLTEXT"> <!-- recognition results -->
    <file ID="name" MIMETYPE="text/xml" /> <!-- single page xml id -->
    <FLocat LOCTYPE="URL" xlink:href="..." /> <!-- URL to page xml -->
  </fileGrp>
</fileSec>
```

## Image preprocessing

### Characterisation

Information:
  - Identification of various image metadata, e.g.
    + Image file format
    + Resolution
    + Color scheme
    + Compression
  - Identification of special characterstics of/difficulties with the image, e.g.
    + Missing page parts
    + Coffee staines

Level of operation:
  - Page image

Result format:
  - PAGE XML
```xml
<Page imageCompression="JPEG" imageHeight="3062" imagePhotometricInterpretation="RGB"
      imageResolutionUnit="inches" imageWidth="2097" imageXResolution="300" imageYResolution="300">
```

### Cropping

Information:
  - Detection of print space

Level of operation:
  - Page

Result format:
  - PAGE XML
```xml
<Border>
	<Coords points="25,25 25,4895 3483,4895 3483,25"/>
</Border>
```

### Deskewing

Information:
  - Skew

Level of operation:
  - Page
  - Region
  
Result format:
  - PAGE XML
  - ToDo!
  - Page level:
```xml
<AlternativeImage filename="deskewed.tif" comments="deskewed" skew="1.67" rotation="normal"/>
```
  - Region level:
```xml
ToDO
```

### Binarization

Information:
  - For each pixel {0,1}

Level of operation:
  - Page
  - Region
  - Line

Result format:
  - PAGE XML
```xml
<AlternativeImage filename="page_b.tif" comments="B/W"/>
```

### Dewarping

Information:
  - ...

Level of operation:
  - Line

Result format:
  - ???

## Layout analysis

### Page segmentation

Information:
  - Localization of regions

Level of operation:
  - Page

Result format:
  - PAGE XML
```xml
<TextRegion id="r0">
  <Coords points="54,178 267,391 324,448 111,235"/>
</TextRegion>
```

### Region segmentation

Information:
  - Localization of lines

Level of operation:
  - Region
  
Result format:
  - PAGE XML
```xml
<TextLine>
  <Coords points="85,0 928,843 976,891 133,48"/>
</TextLine>
```

### Region classification

Information:
  - Function of regions

Level of operation:
  - Page

Result format:
  - PAGE XML
```xml
<TextRegion id="r0" type="caption">
```
  - METS XML
```xml
```

### Document analysis

Information:
  - Function of regions
  
Level of operation:
  - Document

Result format:
  - METS XML
```xml
```

## Text production

### Text recognition

### Post correction
