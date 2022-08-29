# Decisions in OCR-D

In a software project, especially a highly distributed one like OCR-D, decisions need to be made on the technology used, how interfaces should interoperate and how the software as a whole is designed.
In this document, such decisions on key aspects of OCR-D are discussed for the benefit of all OCR-D stakeholders.

## General decisions
* [2022] We will update to Ubuntu 22.04 and Python 3.7 as soon as possible.
* [2022] Switch to Slim Containers in ```ocrd_all``` 
* [2022] Python API changes (Pagewise processing): https://github.com/OCR-D/zenhub/issues/2

## Workflow format
* [2022] We use Nextflow. The whole ```.nf``` file (Nextflow file) as the workflow format workflow server and processing 
server including web API implementation is part of the [implementation projects](phase3). 
Further details can be found [here](spec/nextflow).

##  Web API
* [2022] OCR-D Coordination Project provides the [Web API spec](spec/web_api). 
Only the [REST API wrapper](https://github.com/OCR-D/core/pull/884) of a single processor is provided by OCR-D Core.