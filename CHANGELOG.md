Change Log
==========

All notable changes to the specs will be documented in this file.

Versioned according to [Semantic Versioning](http://semver.org/).


## Unreleased

## TODO

## [2.3.0] - 2018-09-26

Changed:

  * CLI: filtering by log level required, OCR-D/core#173, #74
  * CLI: log messages must adhere to uniform pattern, #78

Added:

  * CLI: Convention to prefer comma-separated values over repeated flags, #68

## [2.2.2] - 2018-08-14

Fixed:

  * Missed `description` for parameters

## [2.2.1] - 2018-07-25

Changed

  * spell out parameter properties in ocrd-tool.json schem

## [2.2.0] - 2018-07-23

Added:

  * CLI: Conventions for handling URL on the command line

## [2.1.2] - 2018-07-19

Added:

  * Reference PAGE media type in PAGE conventions, #65

## [2.1.1] - 2018-06-18

Fixed:

  - ocrd-tool: regex for `version` had a YAML error

## [2.1.0] - 2018-06-18

Added:

  * ocrd-tool: Must define `version`
  * METS: `mets:file` must have ID
  * METS: `mets:fileGrp` must have consistent MIMETYPE
  * METS: `mets:file` GROUPID must be unique with a `mets:fileGrp`

## [2.0.0] - 2018-06-18

Removed:

  * --output-mets CLI option

## [1.3.0] - 2018-06-15

Added:

  * Glossary, #56

Removed:

  * drop OCR-D-GT-PAGE, #61

Fixed:

  * explain `GT-` prefix for `fileGrp@USE` of ground truth files, #58
  * various typos

## [1.2.0] - 2018-05-25

Fixed:

* Fix example for ocrd_tool
* Fix TIFF media type

Added:

* -J/--dump-json, #30

Changed

  * ocrd-tool: tags -> category, #44
  * ocrd-tool: step -> steps (now an array), #44
  * ocrd-tool: parameterSchema -> parameters, #48
  * ocrd-tool: 'tools' is an object now, not an array, #43

## [1.1.5] - 2018-05-15

Added:

  * ocrd-tool: Steps: `preprocessing/optimization/grayscale_normalization` and `layout/segmentation/word`
  * PAGE conventions

## [1.1.4] - 2018-05-02

Added:

* PAGE/XML media type, #33
* mets:file@GROUPID == pg:pcGtsId, #31

## [1.1.3] - 2018-04-28

Added:

* Add OCR-D-SEG-WORD and OCR-D-SEG-GLYPH as USE attributes

## [1.1.2] - 2018-04-23

Changed:

* rename repo OCR-D/pyocrd -> OCR-D/core
* rename repo OCR-D/ocrd-assets -> OCR-D/assets
* renamed docker base image ocrd/pyocrd -> ocrd/core

Fixed:

* In ocrd_tool example: renamed parameter structure-level -> level-of-operation

## [1.1.1] - 2018-04-19

Fixed:
  * typo: `exceutable` -> `executable`
  * disallow custom properties

## [1.1.0] - 2018-04-19

Added
* Spec for OCRD-ZIP

Changed
* Use `executable` instead of `binary` to reduce confusion

Fixed
* typos (@stweil)

Removed

## [1.0.0] - 2018-04-16

Initial Release

<!-- link-labels -->
[2.3.0]: ../../compare/v2.3.0...v2.2.2
[2.2.2]: ../../compare/v2.2.2...v2.2.1
[2.2.1]: ../../compare/v2.2.1...v2.2.0
[2.2.0]: ../../compare/v2.2.0...v2.1.2
[2.1.2]: ../../compare/v2.1.2...v2.1.1
[2.1.1]: ../../compare/v2.1.1...v2.1.0
[2.1.0]: ../../compare/v2.1.0...v2.0.0
[2.0.0]: ../../compare/v2.0.0...v1.3.0
[1.3.0]: ../../compare/v1.3.0...v1.2.0
[1.2.0]: ../../compare/v1.2.0...v1.1.5
[1.1.5]: ../../compare/v1.1.5...v1.1.4
[1.1.4]: ../../compare/v1.1.4...v1.1.3
[1.1.3]: ../../compare/v1.1.3...v1.1.2
[1.1.2]: ../../compare/v1.1.2...v1.1.1
[1.1.1]: ../../compare/v1.1.1...v1.1.0
[1.1.0]: ../../compare/v1.1.0...v1.0.0
[1.0.0]: ../../compare/v1.0.0...HEAD
