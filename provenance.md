# THIS IS JUST A FIRST DRAFT!

# Provenance
Provenance is information about entities, activities, and people involved in producing a piece of data or thing, which can be used to form assessments about its quality, reliability or trustworthiness. (Source: [The PROV Data Model (PROV-DM)](https://www.w3.org/TR/prov-dm/))

## Data Model
[The PROV Data Model (PROV-DM)](https://www.w3.org/TR/prov-dm/) is used to store all provenance metadata.
All provenance have to be stored in files. 
There's provenance at the page level, but there's also provenance at the document level.
All files regarding provenance were stored in a subfolder 'metadata/provenance'.

## Format
Not defined yet
RDF, PROV-XML, PROV-N, and PROV-JSON are supported by the [ProvToolbox](https://github.com/lucmoreau/ProvToolbox)

## Content 
Only the following information is stored for provenance:
(a) General data
1. Workflow engine (including version)
2. METS file
(b) Module Projects
1. ID of the input file(s)
2. Content of parameter.json (optional)
3. Module 
  i) unique-id
  ii) start date
  iii) end date
  iiii) (ocrd-tool.json)?
4. ID of output files
5. Log level (?) this is only used for debugging
6. StdOut(?) this is only used for debugging
7. StdErr(?) this is only used for debugging

### Input/Output
All files listed in METS should be referenced in provenance via their file ID.
File ID MAY be linked to its location. The location may be replaced due to 
different uses:
1. local files
2. external files
Files not listed in METS should be linked to their content in provenance.

### Ingest Workspace to OCR-D Repositorium
During the ingest into repository/LTA, the entire provenance must be stored in a graph to make the provenance searchable.
Therfore all the provenance files are merged into one big file.
This file replaces all files stored in subfolder 'metadata/provenance'

## METS
The provenance file MAY be referenced in METS.


