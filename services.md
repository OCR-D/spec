# OCR-D services

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

Tools:
  - ToDO

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
  - Image file format
  - Resolution
  - Color scheme
  - ...

Level of operation:
  - Page

Tools:
  - `exiftool`

Status:
 
### Cropping

Information:
  - Print space

Level of operation:
  - Page

Tools:
  - `scantailor`
  - `unpaper`

### Deskewing

Information:
  - Skew

Level of operation:
  - Page
  - Region

### Binarization

Information:
  - For each pixel {0,1}

Level of operation:
  - Page
  - Region
  - Line

Tools:
  - `kraken`
  - ...

## Layout analysis

### Page segmentation

Information:
  - Localization of regions

Level of operation:
  - Page

Tools:
  - `Tesseract`
  - `kraken`

### Line splitting

Information:
  - Localization of lines
