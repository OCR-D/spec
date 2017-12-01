# OCR-D services

## Input output data

Input:
  - METS file
  - User-defined parameters
  
Output:
  - METS file
  - Process metadata (“provenance”)
  
### Input preparation

Information:
  - PAGE XML skeleton

Level of operation:
  - Document

Tools:
  - ToDO

#### METS profile

All file refs are to be put in `<fileSec>` with two different `fileGrp` sections, one for images, one for textual content.
```xml
<fileGrp USE="IMAGE"> <!-- master input images -->
  <file ID="name" MIMETYPE="img" /> <!-- single page image id -->
  <FLocat LOCTYPE="URL" xlink:href="..." /> <!-- URL to get image from -->
</fileGrp>
<fileGrp USE="FULLTEXT"> <!-- recognition results -->
  <file ID="name" MIMETYPE="xml" /> <!-- single page xml id -->
  <FLocat LOCTYPE="URL" xlink:href="..." /> <!-- URL to get PAGE XML from -->
</fileGrp>
<fileGrp USE="IIIF"> <!-- additional output -->
  <file ID="doc_name" MIMETYPE="application/json" /> <!-- document IIF manifest -->
  <FLocat LOCTYPE="URL" xlink:href="..." /> <!-- URL to get JSON from -->
</fileGrp>
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
