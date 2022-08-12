# Decisions in OCR-D

In a software project, especially a highly distributed one like OCR-D, decisions need to be made on the technology used, how interfaces should interoperate and how the software as a whole is designed.
In this document, such decisions on key aspects of OCR-D are discussed for the benefit of all OCR-D stakeholders.

## General decisions
* [2022] We will update to Ubuntu 22.04 and Python 3.7 as soon as possible.
* [2022] Switch to Slim Containers in ```ocrd_all``` 

## Workflow format
* [2022] We use Nextflow. Further details can be found [here](https://ocr-d.de/en/spec/nextflow).

## API
* [2022] Python API changes: see [https://ocr-d.de/en/spec/api](https://ocr-d.de/en/spec/api)
* [2022] OCR-D Koord provides the Web API spec. Only the REST API wrapper of a single processor is provided by OCR-D Core.
