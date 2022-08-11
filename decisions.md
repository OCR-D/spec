# Decisions in OCR-D

In a software project, especially a highly distributed one like OCR-D, decisions need to be made on the technology used, how interfaces should interoperate and how the software as a whole is designed.

In this document, such decisions on key aspects of OCR-D are discussed for the benefit of all OCR-D stakeholders.

## Past decisions

* We will update to Ubuntu 22.04 and Python 3.7 as soon as possible.
* We use Nextflow. Further details can be found in [here](https://ocr-d.de/en/spec/nextflow).
* OCR-D Koord provides the Web API spec. Only the REST API wrapper of a single processor is provided by OCR-D Core.
* Switch to Slim Containers in ```ocrd_all``` 
* Python API changes: see [https://ocr-d.de/en/spec/api](https://ocr-d.de/en/spec/api)