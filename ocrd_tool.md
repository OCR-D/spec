# ocrd-tool.json

Tools MUST be described in a file `ocrd-tool.json` in the root of the repository.

It must contain a JSON object adhering to the [ocrd-tool JSON Schema](#Definition).

In particular, every tool provided must be described in an array item under the
`tools` key. These definitions drive the [CLI](cli) and the [web
services](swagger).

To validate a `ocrd-tool.json` file, use `ocrd ocrd-tool /path/to/ocrd-tool.json validate`.

## Resource parameters

To mark a parameter as expecting the address of a file or directory,
it MUST declare the `content-type` property as a [valid media
type](https://www.iana.org/assignments/media-types/media-types.xhtml),
which may contain _multiple values_, formatted as a single string with comma-separated items.

Optionally, workflow processors can be notified that this file or directory
is potentially large and static (e.g. a fixed dataset or a precomputed model),
and should be cached indefinitely after download, by setting the `cacheable` property
to `true`.

The path of the file or directory itself, i.e. the concrete value `<rpath>` of a 
resource parameter, should be resolved in the following way:

* If `<rpath>` is an `http:` or `https:` URI, download to a temporary directory
  (if `cacheable==False`) or a semi-temporary cache directory (otherwise).
* If `<rpath>` is an absolute path: Use as-is.
* If `<rpath>` is a relative path: Try resolving via the following directories,
  and return the first one found, if any. Otherwise abort with an error message stating so.
  * If an environment variable is defined comprising the name of the processor in
    upper-case, with `-` replaced by `_` and followed by `_PATH`
    (e.g. for a processor `ocrd-dummy`, the variable would need to be called `OCRD_DUMMY_PATH`):
    * Split that variable value at `:` and try to resolve by appending each token with
      `/<rpath>`, returning the first found path, if any
  * `<cwd>/<rpath>`
  * `<data>/ocrd-resources/<processor>/<rpath>`
  * `<system>/ocrd-resources/<processor>/<rpath>`
  * `<mod>/<rpath>`

where `<processor>` is the name of the processor executable,
and the resource location directories are defined as follows:
- `<cwd>` represents the current (i.e. runtime) working directory
- `<data>` denotes `$XDG_DATA_HOME` (or `$HOME/.local/share`, if unset)
- `<system>` denotes `/usr/local/share`
- `<mod>` denotes the distribution directory of the module; 
  this path is implementation specific and allows modules
  to distribute small resources along with the code, i.e. pre-installed files
  like [presets](cli#processor-resources).

(**Note** that `<rpath>` is expected to be flat, i.e. without leading directories,
 so resources must reside directly under one of the location directories rather
 than recursively in a subdirectory, with the exception of the `<cwd>` location,
 where arbitrary relative paths are permissable.)


## Input / Output file groups

Tools should define the number of expected input and produced output file
groups ([`USE` attributes of `mets:fileGrp` elements](mets#3-file-groups-metsfilegrp)
as fixed integers or intervals under `input_file_grp_cardinality` and
`output_file_grp_cardinality`, respectively.

If more than one file group is expected or produced, its semantics should be explained 
in the description of the tool.

## Definition

<!-- Regenerate with 'shinclude -i ocrd_tool.md'. See https://github.com/kba/shinclude -->
<!-- BEGIN-EVAL -w '```yaml' '```' -- cat ./ocrd_tool.schema.yml -->
```yaml
type: object
description: Schema for tools by OCR-D MP
required:
  - version
  - git_url
  - tools
additionalProperties: false
properties:
  version:
    description: "Version of the tool, expressed as MAJOR.MINOR.PATCH."
    type: string
    pattern: '^[0-9]+\.[0-9]+\.[0-9]+$'
  git_url:
    description: GitHub/GitLab URL
    type: string
    format: url
  dockerhub:
    description: DockerHub image
    type: string
  tools:
    type: object
    additionalProperties: false
    patternProperties:
      'ocrd-.*':
        type: object
        additionalProperties: false
        required:
          - description
          - steps
          - executable
          - categories
          - input_file_grp_cardinality
          - output_file_grp_cardinality
        properties:
          executable:
            description: The name of the CLI executable in $PATH
            type: string
          input_file_grp:
            deprecated: true
            description: (DEPRECATED) Input fileGrp@USE this tool expects by default
            type: array
            items:
              type: string
              # pattern: '^OCR-D-[A-Z0-9-]+$'
          output_file_grp:
            deprecated: true
            description: (DEPRECATED) Output fileGrp@USE this tool produces by default
            type: array
            items:
              type: string
              # pattern: '^OCR-D-[A-Z0-9-]+$'
          input_file_grp_cardinality:
            description: Number of (comma-separated) input fileGrp@USE this tool expects (either an exact value or a minimum,maximum list with -1 for unlimited)
            oneOf:
              - type: number
                multipleOf: 1
              - type: array
                items:
                  type: number
                  multipleOf: 1
                minItems: 2
                maxItems: 2
            default: 1
          output_file_grp_cardinality:
            description: Number of (comma-separated) output fileGrp@USE this tool expects (either an exact value or a minimum,maximum list with -1 for unlimited)
            oneOf:
              - type: number
                multipleOf: 1
              - type: array
                items:
                  type: number
                  multipleOf: 1
                minItems: 2
                maxItems: 2
            default: 1
          parameters:
            description: Object describing the parameters of a tool. Keys are parameter names, values sub-schemas.
            type: object
            default: {}
            patternProperties:
              ".*":
                type: object
                additionalProperties: false
                required:
                  - description
                  - type
                  # also either 'default' or 'required'
                properties:
                  type:
                    type: string
                    description: Data type of this parameter
                    enum:
                      - string
                      - number
                      - boolean
                      - object
                      - array
                  format:
                    description: Subtype, such as `float` for type `number` or `uri` for type `string`.
                  description:
                    description: Concise description of syntax and semantics of this parameter
                  items:
                    type: object
                    description: describe the items of an array further
                  minimum:
                    type: number
                    description: Minimum value for number parameters, including the minimum
                  maximum:
                    type: number
                    description: Maximum value for number parameters, including the maximum
                  minProperties:
                    type: number
                    description: Minimum number of properties of an object
                  maxProperties:
                    type: number
                    description: Maximum number of properties of an object
                  exclusiveMinimum:
                    type: number
                    description: Minimum value for number parameters, excluding the minimum
                  exclusiveMaximum:
                    type: number
                    description: Maximum value for number parameters, excluding the maximum
                  multipleOf:
                    type: number
                    description: For number values, those values must be multiple of this number
                  properties:
                    type: object
                    description: Describe the properties of an object value
                  additionalProperties:
                    oneOf:
                    - type: boolean
                      description: Whether an object value may contain properties not explicitly defined
                    - type: object
                      description: Schema any additional properties need to adhere to
                  required:
                    type: boolean
                    description: Whether this parameter is required
                  default:
                    description: Default value when not provided by the user
                  enum:
                    type: array
                    description: List the allowed values if a fixed list.
                  content-type:
                    type: string
                    default: 'application/octet-stream'
                    description: >
                      The media type of resources this processor expects for
                      this parameter. Most processors use files for resources
                      (e.g.  `*.traineddata` for `ocrd-tesserocr-recognize`)
                      while others use directories of files (e.g. `default` for
                      `ocrd-eynollah-segment`).  If a parameter requires
                      directories, it must set `content-type` to
                      `text/directory`.
                  cacheable:
                    type: boolean
                    description: "If parameter is reference to file: Whether the file should be cached, e.g. because it is large and won't change."
                    default: false
          description:
            description: Concise description of what the tool does
          categories:
            description: Tools belong to these categories, representing modules within the OCR-D project structure
            type: array
            items:
              type: string
              enum:
                - Image preprocessing
                - Layout analysis
                - Text recognition and optimization
                - Model training
                - Long-term preservation
                - Quality assurance
          steps:
            description: This tool can be used at these steps in the OCR-D functional model
            type: array
            items:
              type: string
              enum:
                - preprocessing/format-conversion
                - preprocessing/characterization
                - preprocessing/optimization
                - preprocessing/optimization/cropping
                - preprocessing/optimization/deskewing
                - preprocessing/optimization/despeckling
                - preprocessing/optimization/dewarping
                - preprocessing/optimization/binarization
                - preprocessing/optimization/grayscale_normalization
                - recognition/text-recognition
                - recognition/font-identification
                - recognition/post-correction
                - layout/segmentation
                - layout/segmentation/text-nontext
                - layout/segmentation/region
                - layout/segmentation/line
                - layout/segmentation/word
                - layout/segmentation/classification
                - layout/analysis
                - postprocessing/format-conversion
                - postprocessing/archival
                - evaluation/layout
                - evaluation/text
          resource_locations:
            type: array
            description: The locations in the filesystem this processor supports for resource lookup
            default: ['data', 'cwd', 'system', 'module']
            items:
              type: string
              enum: ['data', 'cwd', 'system', 'module']
          resources:
            type: array
            description: Resources for this processor
            items:
              type: object
              additionalProperties: false
              required:
                - url
                - description
                - name
                - size
              properties:
                url:
                  type: string
                  description: URLs of all components of this resource
                description:
                  type: string
                  description: A description of the resource
                name:
                  type: string
                  description: Name to store the resource as
                type:
                  type: string
                  enum: ['file', 'directory', 'archive']
                  default: file
                  description: Type of the URL
                parameter_usage:
                  type: string
                  description: Defines how the parameter is to be used
                  enum: ['as-is', 'without-extension']
                  default: 'as-is'
                path_in_archive:
                  type: string
                  description: If type is archive, the resource is at this location in the archive
                  default: '.'
                version_range:
                  type: string
                  description: Range of supported versions, syntax like in PEP 440
                  default: '>= 0.0.1'
                size:
                  type: number
                  description: "Size of the resource in bytes to be retrieved (for archives: size of the archive)"
```

<!-- END-EVAL -->

## Example

This is from the [ocrd_kraken project](https://github.com/OCR-D/ocrd_kraken):

```json

{
  "git_url": "https://github.com/OCR-D/ocrd_kraken",
  "version": "1.0.1",
  "dockerhub": "ocrd/kraken",
  "tools": {
    "ocrd-kraken-binarize": {
      "executable": "ocrd-kraken-binarize",
      "input_file_grp_cardinality": 1,
      "output_file_grp_cardinality": 1,
      "categories": [
        "Image preprocessing"
      ],
      "steps": [
        "preprocessing/optimization/binarization"
      ],
      "description": "Binarize images with kraken",
      "parameters": {
        "level-of-operation": {
          "description": "segment hierarchy level to operate on",
          "type": "string",
          "default": "page",
          "enum": ["page", "region", "line"]
        }
      }
    },
    "ocrd-kraken-segment": {
      "executable": "ocrd-kraken-segment",
      "input_file_grp_cardinality": 1,
      "output_file_grp_cardinality": 1,
      "categories": [
        "Layout analysis"
      ],
      "steps": [
        "layout/segmentation/region",
        "layout/segmentation/line"
      ],
      "description": "Layout segmentation with Kraken",
      "parameters": {
        "level-of-operation": {
          "description": "segment hierarchy level to operate on (page into regions+lines, or regions into lines)",
          "type": "string",
          "default": "page",
          "enum": ["page", "table", "region"]
        },
        "overwrite_segments": {
          "description": "remove any existing regions/lines", 
          "type": "boolean", 
          "default": false
        },
        "text_direction": {
          "type": "string", 
          "description": "Sets principal text direction", 
          "enum": ["horizontal-lr", "horizontal-rl", "vertical-lr", "vertical-rl"], 
          "default": "horizontal-lr"
        },
        "maxcolseps": {
          "description": "Maximum number of column separators. Set to 0 for single-column text to avoid unnecessary computation.", 
          "type": "number", 
          "format": "integer", 
          "default": 2
        },
        "scale": {
          "description": "mean xheight size of glyphs (guessed if zero)", 
          "type": "number", 
          "format": "float", 
          "default": 0
        },
        "black_colseps": {
          "description": "Whether column separators are assumed to be vertical black lines or not", 
          "type": "boolean", 
          "default": false
        },
        "remove_hlines": {
          "description": "Remove horizontal colseps before segmentation", 
          "type": "boolean", 
          "default": true
        },
        "blla_model": {
          "description": "Model used for baseline detection and page segmentation. Ignored if use_legacy.",
          "type": "string",
          "format": "uri",
          "content-type": "application/python-cpickle",
          "cacheable": true,
          "default": "blla.mlmodel"
        },
        "blla_classes": {
          "description": "Class mapping for the region types trained into blla_model.",
          "type": "object",
          "minProperties": 2,
          "additionalProperties": { "type": "string",
                                    "enum": ["TextRegion", "ImageRegion", "LineDrawingRegion",
                                             "GraphicRegion", "TableRegion", "ChartRegion",
                                             "MapRegion", "SeparatorRegion", "MathsRegion",
                                             "ChemRegion", "MusicRegion", "AdvertRegion",
                                             "NoiseRegion", "UnknownRegion", "CustomRegion"] },
          "default": {"text": "TextRegion", "image": "ImageRegion", "line drawing": "LineDrawingRegion",
                      "graphic": "GraphicRegion", "table": "TableRegion", "chart": "ChartRegion",
                      "map": "MapRegion", "separator": "SeparatorRegion", "maths": "MathsRegion",
                      "chem": "ChemRegion", "music": "MusicRegion", "advert": "AdvertRegion",
                      "noise": "NoiseRegion", "unknown": "UnknownRegion", "custom": "CustomRegion"}
        },
        "device": {
          "description": "CUDA ID (e.g. 'cuda:0') for computation on GPU (if available), or 'cpu' to run on CPU only",
          "type": "string",
          "default": "cuda:0"
        },
        "use_legacy": {
          "description": "Use legacy box segmenter as opposed to neural net baseline segmenter",
          "type": "boolean",
          "default": false
        }
      },
      "resources": [
        {
          "url": "https://github.com/mittagessen/kraken/raw/main/kraken/blla.mlmodel",
          "size": 5047020,
          "name": "blla.mlmodel",
          "parameter_usage": "without-extension",
          "description": "Pretrained region+baseline segmentation model (trained on handwriting)"
        },
        {
          "url": "https://ub-backup.bib.uni-mannheim.de/~stweil/tesstrain/kraken/ubma_segmentation/ubma_segmentation.mlmodel",
          "size": 5047020,
          "name": "ubma_segmentation.mlmodel",
          "parameter_usage": "without-extension",
          "description": "region+baseline segmentation model trained by UBMA (on print)"
        }
      ]
    },
    "ocrd-kraken-recognize": {
      "executable": "ocrd-kraken-recognize",
      "input_file_grp_cardinality": 1,
      "output_file_grp_cardinality": 1,
      "categories": ["Text recognition and optimization"],
      "steps": ["recognition/text-recognition"],
      "description": "Text recognition with Kraken",
      "parameters": {
        "overwrite_text": {
          "description": "remove any existing TextEquiv", 
          "type": "boolean", 
          "default": false
        },
        "model": {
          "description": "OCR model to recognize with",
          "type": "string",
          "format": "uri",
          "content-type": "application/python-cpickle",
          "cacheable": true,
          "default": "en_best.mlmodel"
        },
        "pad": {
          "description": "Extra blank padding to the left and right of text line.",
          "type": "number",
          "format": "integer",
          "default": 16
        },
        "bidi_reordering": {
          "description": "Reorder classes in the ocr_record according to  the Unicode bidirectional algorithm for correct display.",
          "type": "boolean",
          "default": true
        },
        "device": {
          "description": "CUDA ID (e.g. 'cuda:0') for computation on GPU (if available), or 'cpu' to run on CPU only",
          "type": "string",
          "default": "cuda:0"
        }
      },
      "resources": [
        {
          "url": "https://ub-backup.bib.uni-mannheim.de/~stweil/tesstrain/kraken/austriannewspapers/20220520/austriannewspapers_best.mlmodel",
          "size": 16243476,
          "name": "austriannewspapers.mlmodel",
          "parameter_usage": "without-extension",
          "description": "19th and 20th century German Fraktur; https://github.com/UB-Mannheim/AustrianNewspapers/wiki/Training-with-Kraken"
        },
        {
          "url": "https://ub-backup.bib.uni-mannheim.de/~stweil/tesstrain/kraken/reichsanzeiger-gt/reichsanzeiger_best.mlmodel",
          "size": 16358636,
          "name": "reichsanzeiger.mlmodel",
          "parameter_usage": "without-extension",
          "description": "19th and 20th century German Fraktur ('Deutscher Reichsanzeiger'); https://github.com/UB-Mannheim/reichsanzeiger-gt/wiki/Training-with-Kraken"
        },
        {
          "url": "https://ub-backup.bib.uni-mannheim.de/~stweil/tesstrain/kraken/digitue-gt/digitue_best.mlmodel",
          "size": 16364343,
          "name": "digitue.mlmodel",
          "parameter_usage": "without-extension",
          "description": "mostly 19th century German Fraktur; https://github.com/UB-Mannheim/digitue-gt/wiki/Training-with-Kraken"
        },
        {
          "url": "https://ub-backup.bib.uni-mannheim.de/~stweil/tesstrain/kraken/digi-gt/luther_best.mlmodel",
          "size": 16305851,
          "name": "luther.mlmodel",
          "parameter_usage": "without-extension",
          "description": "16th century German Gothic; https://github.com/UB-Mannheim/digi-gt/wiki/Training"
        },
        {
          "url": "https://ub-backup.bib.uni-mannheim.de/~stweil/tesstrain/kraken/typewriter/typewriter.mlmodel",
          "size": 16364780,
          "name": "typewriter.mlmodel",
          "parameter_usage": "without-extension",
          "description": "20th century typewriter http://idb.ub.uni-tuebingen.de/opendigi/walz_1976, pretrained on austriannewspapers.mlmodel"
        },
        {
          "url": "https://zenodo.org/record/2577813/files/en_best.mlmodel?download=1",
          "size": 2930723,
          "name": "en_best.mlmodel",
          "parameter_usage": "without-extension",
          "description": "This model has been trained on a large corpus of modern printed English text augmented with ~10000 lines of historical pages"
        }
      ]
    }
  }
}
```
