# Decisions in OCR-D

In a software project, especially a highly distributed one like OCR-D, decisions need to be made on the technology used, how interfaces should interoperate and how the software as a whole is designed.
In this document, such decisions on key aspects of OCR-D are discussed for the benefit of all OCR-D stakeholders.

## General decisions

* [2022] We will update to Ubuntu 22.04 and Python 3.7 as soon as possible.
* [2022] Switch to Slim Containers in ```ocrd_all```
* [2022] Python API changes (Pagewise processing): <https://github.com/OCR-D/zenhub/issues/2>

## Workflow format

* [2022] We use Nextflow. The whole ```.nf``` file (Nextflow file) as the workflow format workflow server and processing
server including web API implementation is part of the [implementation projects](phase3).
Further details can be found [here](spec/nextflow).

## Web API

* [2022] OCR-D Coordination Project provides the [Web API spec](spec/web_api).
Only the [REST API wrapper](https://github.com/OCR-D/core/pull/884) of a single processor is provided by OCR-D Core.

## QUIVER

* [2022] We will create a web application, QUIVER (for QUalIty oVERview), in which several information about OCR-D processors are provided:
  * a general overview of the projects (i.e. GitHub repositories), e.g. if their `ocrd-tool.json` is valid, when their last release has been made etc.
  * a workflow section where we [benchmark](#benchmarking) different workflows for different corpora.
  * a general overview of the available processors

### Benchmarking

* [2022] To execute the benchmarking, we will create several corpora with different characteristics (font, creation date, layout, …) and 
run different workflows with these as input. The result is then displayed in the QUIVER workflow tab.
The corpora will be publicly available for better transparency.
* [2022] Relevant benchmarks for the mininum viable product (MVP) will be:
  * CER
  * WER
  * Bag of Words
  * Reading order
  * IoU
  * CPU time
  * wall time
  * I/O
  * Memory Usage
  * Disc usage
* [2022] The benchmarking will be executed automatically in a regular intervall to measure if changes in the processors improve the result.
This might be done via CI, GitHub Actions or as a CRON job on a separate server.
