# Provenance
[See issues](https://github.com/OCR-D/spec/issues/11)
All provenance have to be stored in files. 
There's provenance at the page level, but there's also provenance at the document level.
Because these files can become very large, they are also stored as references in the fileGrp section.

## Format
Not defined yet

### Input/Output
Input should be the input files referenced via FileIDs. Optionally the parameter file.
Output should be the generated files referenced via FileIDs.

### Ingest/Access Workspace to/from OCR-D Repositorium
The linking of inputs and outputs should be done via the FileID as long as the files are not archived. 
If the files are in repository, the FileIDs should be replaced by the unique URL.
When exporting a workspace, the references should be reset to the FileID again.
During the ingest, the entire provenance must be stored in a graph to make the provenance searchable.

## METS
### File Group
File groups holding provenance have to start with prefix "PROV-"


