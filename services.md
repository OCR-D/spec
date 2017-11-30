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
