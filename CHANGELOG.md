Change Log
==========

All notable changes to the specs will be documented in this file.

Versioned according to [Semantic Versioning](http://semver.org/).

## TODO


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
[1.1.4]: ../../compare/v1.1.4...v1.1.3
[1.1.3]: ../../compare/v1.1.3...v1.1.2
[1.1.2]: ../../compare/v1.1.2...v1.1.1
[1.1.1]: ../../compare/v1.1.1...v1.1.0
[1.1.0]: ../../compare/v1.1.0...v1.0.0
[1.0.0]: ../../compare/v1.0.0...HEAD
