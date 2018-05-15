# OCR-D Glossary

> Glossary of terms from the domain of image processing/OCR as used within the OCR-D framework

<!-- BEGIN-MARKDOWN-TOC -->
* [Layout and Typography](#layout-and-typography)
	* [Block](#block)
	* [Block type](#block-type)
	* [Glyph](#glyph)
	* [Grapheme Cluster](#grapheme-cluster)
	* [Line](#line)
	* [Reading Order](#reading-order)
	* [Region](#region)
	* [Symbol](#symbol)
	* [TextLine](#textline)
	* [Word](#word)
* [Data](#data)
	* [Ground Truth](#ground-truth)
		* [Reference data](#reference-data)
		* [Evaluation data](#evaluation-data)
		* [Training data](#training-data)
* [Activities](#activities)
	* [Binarization](#binarization)
	* [Dewarping](#dewarping)
	* [Despeckling](#despeckling)
	* [Deskewing](#deskewing)
	* [Font indentification](#font-indentification)
	* [Grayscale normalization](#grayscale-normalization)
	* [Document analysis](#document-analysis)
	* [Reading order detection](#reading-order-detection)
	* [Cropping](#cropping)
	* [Border removal](#border-removal)
	* [Segmentation](#segmentation)
	* [Block segmentation](#block-segmentation)
	* [Block classification](#block-classification)
	* [Line segmentation](#line-segmentation)
	* [Word segmentation](#word-segmentation)
	* [Glyph segmentation](#glyph-segmentation)
* [Data Persistence](#data-persistence)
	* [Software repository](#software-repository)
	* [Ground Truth repository](#ground-truth-repository)
	* [Research data repository](#research-data-repository)
	* [Model repository](#model-repository)
* [OCR-D modules](#ocr-d-modules)
	* [Image preprocessing](#image-preprocessing)
	* [Layout analysis](#layout-analysis)
	* [Text recognition and optimization](#text-recognition-and-optimization)
	* [Model training](#model-training)
	* [Long-term preservation](#long-term-preservation)
	* [Quality assurance](#quality-assurance)

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

### Reading Order

Reading order is the intended order of regions within a document.

### Region

See [Region](#Region)

### Symbol

See [Glyph](#glyph)

### TextLine

A TextLine is a [block](#block) of text without line breaks.

### Word

A word is a sequence of [glyphs](#glyph) not containing any word-bounding whitespace.

## Data

### Ground Truth

Ground Truth (GT) in the context of OCR-D is transcriptions in PAGE-XML format in
combination with the original image.

We distinguish different usage scenarios for GT:

#### Reference data

**TODO**

#### Evaluation data

**TODO**

#### Training data

Most LSTM will be trained on line transcription/line image tuples. These can be
generated from PAGE-XML of the [Ground Truth](#ground-truth).

## Activities

### Binarization

Binarization means converting all colors in an image to either black or white.

Controlled term: `binarized` (`comments` of a mets:file), `preprocessing/optimization/binarization` (`step` in ocrd-tool.json)

See [Felix' Niklas interactive demo](http://felixniklas.com/imageprocessing/binarization)

### Dewarping

Manipulating an image in such a way that it is rectangular, all text lines are
parallel to bottom/top edge of page and creases/folds/curving of page into
spine of book has been corrected.

Controlled term: `preprocessing/optimization/dewarping`

See [Matt Zucker's entry on Dewarping](https://mzucker.github.io/2016/08/15/page-dewarping.html).

### Despeckling

Remove artifacts such as smudges, ink blots, underlinings etc. from an image.

Controlled term: `preprocessing/optimization/despeckling`

### Deskewing

Rotate image so that all text lines are horizontal.

Controlled term: `preprocessing/optimization/deskewing`

### Font indentification

Detecting the font type used in the document. Can happen after an initial OCR run or before.

Controlled term: `recognition/font-identification`

### Grayscale normalization

> ISSUE: https://github.com/OCR-D/spec/issues/41

Controlled term:
  - `gray_normalized` (`comments` in file)
  - `preprocessing/optimization/cropping` (step)

Gray normalization is similar to binarization but instead of a purely bitonal
image, the output can also contain shades of gray to avoid inadvertently
combining glyphs when they are very close together.

### Document analysis

Document analysis is the detection of structure on the document level to create a table of contents.

### Reading order detection

Detects the [reading order](#reading-order) of [blocks](#block).

### Cropping

Detecting the print space in a page, as opposed to the margins. It is a form of
[block segmentation](#block-segmentation)

Controlled term: `preprocessing/optimization/cropping`.

### Border removal

--> [Cropping](#cropping)

### Segmentation

Segmentation means detecting areas within an image.

Specific segmentation algorithms are labelled by the semantics of the regions
they detect not the semantics of the input, i.e. an algorithm that detects
blocks is called [block segmentation](#block-segmentation).

### Block segmentation

Segment an image into [blocks](#block). Also determines whether this is a text
or non-text block (e.g. images).

Controlled term:
- `SEG-BLOCK` (`USE`)
- `layout/segmentation/region` (step)

### Block classification

Determine the [type](#block-type) of a detected block.

### Line segmentation
Segment [blocks](#block) into [textlines](#textline).

Controlled term:
- `SEG-LINE` (`USE`)
- `layout/segmentation/line` (step)

### Word segmentation

Segment a [textline](#textline) into [words](#word)

Controlled term:
- `SEG-LINE` (`USE`)
- `layout/segmentation/word` (step)

### Glyph segmentation

Segment a [textline](#textline) into [glyphs](#glyph)

Controlled term: `SEG-GLYPH`

## Data Persistence

### Software repository

**TODO** wrong use of document analysis

The software repository contains all document analysis algorithms developed
during the project including tests. It will also contain the documentation and
installation instructions for deploying a document analysis workflow.

### Ground Truth repository

Contains all the [ground truth](#ground-truth) data.

### Research data repository

**TODO** wrong use of document analysis

The research data repository contains the results of all
[activities](#activities) during document analysis. At least it contains the
end results of every processed document and its full provenance. The research
data repository must be available locally.

### Model repository

**TODO** wrong use of document analysis

Contains all trained (OCR) models for document analysis. The model repository
must be available locally. Ideally, a publicly available model repository will
be developed.


## OCR-D modules

The [OCR-D project](https://ocr-d.de) divided the various elements of an OCR
workflow into six modules.

### Image preprocessing

**TODO**

### Layout analysis

**TODO**

### Text recognition and optimization

**TODO**

### Model training

**TODO**

### Long-term preservation

**TODO**

### Quality assurance

**TODO**
