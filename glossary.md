# OCR-D Glossary

> Glossary of terms from the domain of image processing/OCR as used within the OCR-D framework

<!-- BEGIN-MARKDOWN-TOC -->
* [Layout and Typography](#layout-and-typography)
	* [Block](#block)
	* [Block type](#block-type)
	* [Glyph](#glyph)
	* [Grapheme Cluster](#grapheme-cluster)
	* [Line](#line)
	* [Region](#region)
	* [Symbol](#symbol)
	* [TextLine](#textline)
	* [Word](#word)
* [Data](#data)
	* [Evaluation data](#evaluation-data)
	* [Ground Truth](#ground-truth)
	* ["Referenzdaten"](#-referenzdaten-)
	* [Training data](#training-data)
* [Activities](#activities)
	* [Document analysis](#document-analysis)
	* [Page segmentation](#page-segmentation)
* [Data Persistence](#data-persistence)
	* [Software repository](#software-repository)
	* [Research data repository](#research-data-repository)
	* [Model repository](#model-repository)

<!-- END-MARKDOWN-TOC -->

## Layout and Typography

### Block

A block is a polygon inside a page.

### Block type

The semantics or function of a [block](#block) such as heading, page number, column, print space...

### Glyph

**TODO**

### Grapheme Cluster

See [Glyph](#glyph)

### Line

See [TextLine](#textline)

### Region

See [Region](#Region)

### Symbol

See [Glyph](#glyph)

### TextLine

A TextLine is a [block](#block) of text without line breaks.

### Word

A word is a sequence of [glyphs](#glyph) not containing any word-bounding whitespace.


## Data

### Evaluation data

**TODO**

### Ground Truth

**TODO**

### "Referenzdaten"

**TODO**

### Training data

**TODO**


## Activities

### Document analysis

**TODO**

### Page segmentation

**TODO**


## Data Persistence

### Software repository

<!--
Das Softwarerepositorium enthält alle während des Projektes entwickelten und getesteten Algorithmen für die Dokumentenanalyse.Hier wird am Ende des Projektes auch die Dokumentation und die Installationsanleitung zum Aufbau einer Dokumentenanalyse abgelegt.
-->

The software repository contains all document analysis algorithms developed during the project including tests. It will also contain the documentation and installation instructions for deploying a document analysis workflow.


### Research data repository

<!--
   Kann alle Zwischenergebnisse einer Dokumentenanalyse enthalten. Es enthält mindestens die Endergebnisse jedes prozessierten Dokuments und die komplette Provenance. Das Forschungsdatenrepositorium muss lokal verfügbar sein.
-->

The research data repository contains the results of all [activities](#activities) during document analysis. At least it contains the end results of every processed document and its full provenance. The research data repository must be available locally.


### Model repository

<!--
Enthält alle trainierten (OCR-)Modelle für die Dokumentenanalyse. Das Modellrepositorium muss lokal verfügbar sein. Ein öffentliches Modellrepositorium ist erstrebenswert.
-->

Contains all trained (OCR) models for document analysis. The model repository must be available locally. Ideally, a publicly available model repository will be developed.

