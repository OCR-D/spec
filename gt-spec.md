# linegt

> An exchange format for line-based ground truth for OCR

<!-- BEGIN-MARKDOWN-TOC -->
* [Rationale](#rationale)
* [BagIt](#bagit)
* [BagIt profile](#bagit-profile)
	* [Gt-Transcription-Extension](#gt-transcription-extension)
	* [Gt-Transcription-Media-Type](#gt-transcription-media-type)
	* [Gt-Transcription-Directory](#gt-transcription-directory)
	* [Gt-Transcription-Normalization](#gt-transcription-normalization)
	* [Gt-Grayscale-Image-Extension](#gt-grayscale-image-extension)
	* [Gt-Grayscale-Image-Media-Type](#gt-grayscale-image-media-type)
	* [Gt-Grayscale-Image-Directory](#gt-grayscale-image-directory)
	* [Gt-Color-Image-Extension](#gt-color-image-extension)
	* [Gt-Color-Image-Media-Type](#gt-color-image-media-type)
	* [Gt-Color-Image-Directory](#gt-color-image-directory)
	* [Gt-Bitonal-Image-Extension](#gt-bitonal-image-extension)
	* [Gt-Bitonal-Image-Media-Type](#gt-bitonal-image-media-type)
	* [Gt-Bitonal-Image-Directory](#gt-bitonal-image-directory)
	* [Gt-Line-Metadata-Extension](#gt-line-metadata-extension)
	* [Gt-Line-Metadata-Media-Type](#gt-line-metadata-media-type)
	* [Gt-Line-Metadata-Directory](#gt-line-metadata-directory)
	* [Gt-Directory](#gt-directory)
	* [Gt-Directory-Structure](#gt-directory-structure)
* [Line metadata](#line-metadata)

<!-- END-MARKDOWN-TOC -->

## Rationale

Recent OCR (optical character recognition) engines are not actually
character-based anymore but use neural networks that operate on lines. These
engines can be trained with images of text lines and their transcription
("ground truth"), plus engine-specific configurations.

This format defines a standardized format to bundle such ground truth, based on
the BagIt conventions.

## BagIt

An `linegt` bag must be a valid BagIt bag:

* Root folder must contain a file `bagit.txt`
* Root folder must contain a file `bag-info.txt` with metadata about the bag
* All payload files must be under a folder `/data`
* Every file in `/data` along with its `<algo>` checksum must be listed in a
  file `manifest-<algo>.txt`

## BagIt profile

In addition to the requirements of BagIt, an `ocr_linegt` bag must adhere to
the `ocr_linegt` BagIt profile.

### Gt-Transcription-Extension

Extension of the transcription files. Default: `.gt.txt`.

### Gt-Transcription-Media-Type

Media type of the transcription files. Default: `text/plain`.

### Gt-Transcription-Directory

Name of the subfolder containing transcriptions if [`Gt-Directory-Structure`] is `subfolders` or `subfolders-nested`. Default: `text`.

### Gt-Transcription-Normalization

**Required**

All transcriptions MUST be UTF-8 encoded Unicode. This property defines the
unicode normalization level.

One of `NFC`, `NFKC`, `NFD` or `NFKC` or `non-normalized`.

![Illustration unicode normalization](http://unicode.org/reports/tr15/images/UAX15-NormFig6.jpg)

### Gt-Grayscale-Image-Extension

Extension of the grayscale image files. Default: `.nrm.png`.

### Gt-Grayscale-Image-Media-Type

Media type of the grayscale image files. Default: `image/png`.

### Gt-Grayscale-Image-Directory

Name of the subfolder containing grayscale images if [`Gt-Directory-Structure`] is `subfolders` or `subfolders-nested`. Default: `grayscale`.

### Gt-Color-Image-Extension

Extension of the color image files. Default: `.color.png`.

### Gt-Color-Image-Media-Type

Media type of the color image files. Default: `image/png`.

### Gt-Color-Image-Directory

Name of the subfolder containing color images if [`Gt-Directory-Structure`] is `subfolders` or `subfolders-nested`. Default: `img`.

### Gt-Bitonal-Image-Extension

Extension of the bitonal image files. Default: `.bin..png`.

### Gt-Bitonal-Image-Media-Type

Media type of the bitonal image files. Default: `image/png`.

### Gt-Bitonal-Image-Directory

Name of the subfolder containing bitonal images if [`Gt-Directory-Structure`] is `subfolders` or `subfolders-nested`. Default: `bin`.

### Gt-Line-Metadata-Extension

Extension of the [line metadata] files. Default: `.json`.

### Gt-Line-Metadata-Media-Type

Media type of the [line metadata] files. Default: `application/json`.

### Gt-Line-Metadata-Directory

Name of the subfolder containing [line metadata] if [`Gt-Directory-Structure`] is `subfolders` or `subfolders-nested`. Default: `meta`.

### Gt-Directory

Directory below `/data` containing the ground truth. Default: `ground-truth`.

### Gt-Directory-Structure

Directory structure. One of 

  - `flat`: img and transcription in the [`Gt-Directory`]
  - `flat-nested`: img and transcription in the same dir below [`Gt-Directory`]
  - `subfolders`: img and transcription in subfolders [`Gt-Bitonal-Image-Directory`] and [`Gt-Transcription-Directory`] of [`Gt-Directory`]
  - `subfolders-nested`: img and transcription in subfolders [`Gt-Bitonal-Image-Directory`] and [`Gt-Transcription-Directory`] in the same dir below Gt-Directory

## Line metadata

In addition to the bag-wide metadata defined by the [BagIt profile], metadata
can be saved per line to preserve the provenance of every single line.

Line metadata can be encoded in JSON or YAML (depending on
[`Gt-Line-Metadata-Extension`] and [`Gt-Line-Metadata-Media-Type`]).

Line metadata MUST adhere to this JSON schema:

<!-- BEGIN-EVAL -w '```yaml' '```' -- cat single-line.yml -->
```yaml
description: Schema for provenance of single lines
type: object
required:
  - coords
  - imageUrl
properties:
  coords:
    description: Coordinates as array of x-y-pairs
    type: array
    items:
      type: array
      length: 2
      items:
        type: number
  pageUrl:
    description: URL of the page (resp. URL the PAGE-XML file)
    type: string
  imageUrl:
    description: URL of the image (resp. the `pg:imageFilename` in the PAGE-XML file)
    type: string
  bagUrl:
    description: URL of the bag that contains the page
    type: string
  metsUrl:
    description: URL of the METS document that contains the page
    type: string
  lineId:
    description: ID of the line within the PAGE-XML doc
    type: string
  xpath:
    description: XPath to the line if no `fileId` was provided
    type: string
```

<!-- END-EVAL -->

<!--
   ==================================================================
   Reference links
   ==================================================================
--->
[`Gt-Directory`]: #gt-directory
[`Gt-Bitonal-Image-Directory`]: #gt-bitonal-image-directory
[`Gt-Transcription-Directory`]: #gt-transcription-directory
[`Gt-Directory-Structure`]: #gt-directory-structure
[`Gt-Line-Metadata-Directory`]: #gt-bitonal-image-directory
[`Gt-Line-Metadata-Extension`]: #gt-line-metadata-extension
[`Gt-Line-Metadata-Media-Type`]: #gt-line-metadata-media-type
[BagIt Profile]: #bagit-profile
[line metadata]: #line-metadata
