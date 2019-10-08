# Provenance
Provenance is information about entities, activities, and people involved in producing a piece of data or thing, which can be used to form assessments about its quality, reliability or trustworthiness. (Source: [The PROV Data Model (PROV-DM)](https://www.w3.org/TR/prov-dm/))

## Data Model
[The PROV Data Model (PROV-DM)](https://www.w3.org/TR/prov-dm/) is used to store all provenance metadata.
All provenance have to be stored in files. 
There's provenance at the page level, but there's also provenance at the document level.
All files regarding provenance were stored in a subfolder '**metadata**'.

## Format
The workflow provenance is stored in [PROV-XML](https://www.w3.org/TR/prov-xml/). 

### Types
All Activities, Entities belonging to the OCR-D workflow have the same namespace.
#### Namespace
<dl>
  <dt><strong>Prefix</strong></dt>
  <dd>ocrd</dd>
  <dt><strong>Namespace</strong></dt>
  <dd>http://www.ocr-d.de</dd>
</dl>

Type | Data Type | Description
-------- | -------- | --------
Entity   | ocrd:mets | Filename  of METS file
Entity   | ocrd:mets_referencedFile | ID of the file referenced inside METS. 
Entity   | ocrd:parameter_file   | Content of the parameter file.
Activity   | ocrd:module | Module that was executed 
Activity   | ocrd:workflow | Workflow that was executed


## Content 
Only the following information is stored for provenance:
(a) **General data**
1. Workflow engine 
  - Label including version
  - Start date
  - End date

(b) **Module Projects**
2. Module 
  - Label (e.g.: ocrd-kraken-binarize_Version 0.1.0, ocrd/core 1.0.0)
  - Start date
  - End date
3. METS file before executing module
4. METS file after executing module
5. ID of the input file(s)
6. ID of output file(s)
7. Content of parameter.json (optional)

### Input/Output
All files listed in METS should be referenced in provenance via their file ID.
File ID MAY be linked to its location. The location may be replaced due to 
different uses:
1. local files
2. external files
Files not listed in METS should be linked to their content in provenance. (e.g.: parameter.json)

### Ingest Workspace to OCR-D Repositorium
At least before ingesting into repository/LTA, the entire provenance must be stored in one file (metadata/ocrd_provenance.xml) to make the provenance searchable.
Therfore all the provenance files are merged into one big file.
This file replaces all provenance files stored in subfolder 'metadata'

## Example
The file structure could look like this after a workflow with 4 steps has been executed.
```
metadata/
   |
   +-- mets.xml.'workflowid'_0000
   |
   +-- mets.xml.'workflowid'_0001
   |
   +-- mets.xml.'workflowid'_0002
   |
   +-- mets.xml.'workflowid'_0003
   |
   +-- mets.xml.'workflowid'_0004
   |
   +-- ocrd_provenance.xml
   |
   +-- provenance_'workflowid'.xml (optional)
```

## Provenance and BagIt
The provenance MAY be stored as tag directory in the bagIt container.
E.g.:
```
<base directory>/
         |
         +-- bagit.txt
         |
         +-- manifest-<algorithm>.txt
         |
         +-- [additional tag files]
         |
         +-- data/
         |     |
         |     +-- mets.xml
         |     |
         |     +-- ...
         |
         +-- metadata
                |
                +-- mets.xml.'workflowid'_0000
                |
                +-- ...
                |
                +-- mets.xml.'workflowid'_XXXX
                |
                +-- ocrd_provenance.xml

```

