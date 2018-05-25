# ocrd-tool.json

Tools MUST be described in a file `ocrd_tool.json` in the root of the repository.

It must contain a JSON object adhering to the [ocrd-tool JSON Schema](#Definition).

In particular, every tool provided must be described in an array item under the
`tools` key. These definitions drive the [CLI](cli) and the [web
services](swagger).

To validate a `ocrd_tool.json` file, use `ocrd validate-ocrd-tool -T /path/to/ocrd-tool.json`.

## Definition

<!-- Regenerate with 'shinclude -i ocrd_tool.md'. See https://github.com/kba/shinclude -->
<!-- BEGIN-EVAL -w '```yaml' '```' -- cat ./ocrd_tool.schema.yml -->
```yaml
type: object
description: Schema for tools by OCR-D MP
required:
  - git_url
  - tools
additionalProperties: false
properties:
  git_url:
    description: Github/Gitlab URL
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
        properties:
          executable:
            description: The name of the CLI executable in $PATH
            type: string
          parameters:
            description: Object describing the parameters of a tool. Keys are parameter names, values sub-schemas.
            type: object
          description:
            description: Concise description what the tool does
          categories:
            description: Tools belong to this categories, representing modules within the OCR-D project structure
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
                - layout/segmentation
                - layout/segmentation/region
                - layout/segmentation/line
                - layout/segmentation/word
                - layout/segmentation/classification
                - layout/analysis
```

<!-- END-EVAL -->

## Example

This is from the [ocrd_tesserocr sample project](https://github.com/OCR-D/ocrd_tesserocr):

<!-- BEGIN-EVAL -w '```json' '```' -- cat ../ocrd_kraken/ocrd-tool.json -->
```json
{
  "git_url": "https://github.com/OCR-D/ocrd_kraken",
  "tools": {
    "ocrd-kraken-binarize": {
      "executable": "ocrd-kraken-binarize",
      "category": "Image preprocessing",
      "steps": [
        "preprocessing/optimization/binarization"
      ],
      "description": "Binarize images with kraken",
      "parameters": {
        "level-of-operation": {
          "type": "string",
          "default": "page",
          "enum": ["page", "region", "line"]
        }
      }
    },
    "ocrd-kraken-segment": {
      "executable": "ocrd-kraken-segment",
      "category": "Layout analysis",
      "steps": [
        "layout/segmentation/region"
      ],
      "description": "Block segmentation with kraken",
      "parameters": {
        "text_direction": {
          "type": "string",
          "description": "Sets principal text direction",
          "enum": ["horizontal-lr", "horizontal-rl", "vertical-lr", "vertical-rl"],
          "default": "horizontal-lr"
        },
        "script_detect": {
          "type": "boolean",
          "description": "Enable script detection on segmenter output",
          "default": false
        },
        "maxcolseps": {"type": "number", "format": "integer", "default": 2},
        "scale": {"type": "number", "format": "float", "default": null},
        "black_colseps": {"type": "boolean", "default": false},
        "white_colseps": {"type": "boolean", "default": false}
      }
    }

  }
}
```

<!-- END-EVAL -->


