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

Input:
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

Input:
  - Page image

Output:
  - PAGE XML enriched with image metadata in corresponding attributes
```xml
<Page imageCompression="JPEG" imageHeight="3062" imagePhotometricInterpretation="RGB"
      imageResolutionUnit="inches" imageWidth="2097" imageXResolution="300" imageYResolution="300">
```

### Cropping

Information:
  - Detection of print space

Input:
  - Page image

Output:
  - PAGE XML `<PrintSpace>` with coordinates corresponding to the print space 
```xml
<PrintSpace>
	<Coords points="25,25 25,4895 3483,4895 3483,25"/>
</PrintSpace>
```

### Deskewing

Information:
  - Skew

Input:
  - Page
  - Region
  
Output:
  - PAGE XML `<AlternativeImage>` linking to the deskewed image and process meta data
```xml
<AlternativeImage filename="deskewed.tif" comments="deskewed" skew="1.67" rotation="normal" ... />
```

### Binarization

Information:
  - For each pixel {0,1}

Input:
  - Page
  - Region
  - Line

Output:
  - PAGE XML `<AlternativeImage>` linking to the binarized image and process meta data
```xml
<AlternativeImage filename="page_b.tif" comments="B/W" ... />
```

### Dewarping

Information:
  - Removal of distortion

Input:
  - Line

Output:
  - PAGE XML `<AlternativeImage>` linking to the dewarped image and process meta data
```xml
<AlternativeImage lineRef="l01" filename="line_01_dewarped.tif" comments="dewarped" ... />
```

## Layout analysis

### Page segmentation

Information:
  - Localization of regions

Input:
  - Page

Output:
  - PAGE XML with Regions, corresponding coordinates and their classification
```xml
<TextRegion id="r0">
  <Coords points="54,178 267,391 324,448 111,235"/>
</TextRegion>
<GraphicRegion id="r1">
  <Coords points="55,532 269,768 326,800 109,532"/>
</GraphicRegion>
```

### Region segmentation

Information:
  - Localization of lines

Input:
  - Region
  
Output:
  - PAGE XML `<TextLine>` for each line (and corresponding coordinates) in a `<TextRegion>`
```xml
<TextLine>
  <Coords points="85,0 928,843 976,891 133,48"/>
</TextLine>
```

### Region classification

Information:
  - Function of regions

Input:
  - Page

Output:
  - METS structural map `<mets:structMap>` linking (typed) structures and regions
```xml
<structMap TYPE="logical">
  <div ID="STRUCT1" LABEL="Überschrift" TYPE="heading">
    <fptr>
      <area FILEID="FILE001" COORDS="0123 4567 8901 2345"/>
    </fptr>
  </div>
</structMap>
```

### Document analysis

Information:
  - Function of regions
  
Input:
  - Document

Output:
  - METS XML structural map `<mets:structMap>` linking (typed) structures and pages
```xml
<structMap TYPE="logical">
  <div ID="LOG1" LABEL="Inhaltsverzeichnis" TYPE="table of contents">
    <div ID="div1" LABEL="1. Einleitung" ORDER="1">
      <fptr FILEID="FILE001" ID="LOG001"/>
    </div>
    <div ID="div2" LABEL="2. Fortsetzung" ORDER="2">
      <fptr FILEID="FILE002" ID="LOG002"/>
    </div>
  </div>
</structMap>
```

## Text production

### Text recognition

Information:
  - OCR core functionality

Input:
  - Line

Output:
  - PAGE XML `<TextEquiv>` with recognized text
```xml
<TextRegion id="r02" type="text" textColour="black">
  ...
  <TextLine id=”l01”>
    <Coords points="222 250, 222 477, 2259 477, 2259 250"/>
  </TextLine>
  <TextEquiv id=”l01”>befondere Ausgabe dic Kreditorgamſation deſ Hanse⸗Bund</TextEquiv>
</TextRegion>
```

### Post correction
Information:
  - Improvement of recognized text

Input:
  - Seite
  - Dokument

Output:
  - PAGE XML `<TextEquiv>` with improved text
```xml
<TextRegion id="r02" type="text" textColour="black">
  ...
  <TextLine id=”l01”>
    <Coords points="222 250, 222 477, 2259 477, 2259 250"/>
  </TextLine>
  <TextEquiv id=”l01”>beſondere Aufgabe die Kreditorganiſation des Hanse⸗Bund</TextEquiv>
</TextRegion>
```
