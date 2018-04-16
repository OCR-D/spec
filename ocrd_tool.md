# Description of tools provided by MP

Tools MUST be described in a file `ocrd_tool.yml` in the root of the
repository. It must contain a YAML file adhering to the
[`ocrd_tool.schema.yml` YAML Schema](https://github.com/OCR-D/spec/blob/master/ocrd_tool.schema.yml).

In particular, every tool provided must be described in an entry under the `tools` key. These definitions drive the CLI and the web services.

To validate a `ocrd_tool.yml` file, use `ocrd validate-ocrd-tool -T /path/to/ocrd_tool.yml`.

## Definition

<!-- Regenerate with 'shinclude -i ocrd_tool.md'. See https://github.com/kba/shinclude -->
<!-- BEGIN-EVAL -w '```yaml' '```' -- cat ./ocrd_tool.schema.yml -->
```yaml
type: object
description: Schema for tools by OCR-D MP
required:
  - git_url
  - tools
properties:
  git_url:
    description: Github/Gitlab URL
    type: string
    format: url
  dockerhub:
    description: DockerHub image
    type: string
  tools:
    type: array
    items:
      type: object
      required:
        - description
        - step
        - binary
      properties:
        binary:
          description: The name of the CLI in $PATH
          type: string
        parameterSchema:
          description: JSON Schema for the parameters.json file
          type: object
        description:
          description: Concise description what the tool does
          type: string
        step:
          description: Step in the OCR-D functional model for this tool
          type: string
          enum:
            - preprocessing/characterization
            - preprocessing/optimization
            - preprocessing/optimization/cropping
            - preprocessing/optimization/deskewing
            - preprocessing/optimization/despeckling
            - preprocessing/optimization/dewarping
            - preprocessing/optimization/binarization
            - recognition/text-recognition
            - recognition/font-identification
            - layout/segmentation
            - layout/segmentation/region
            - layout/segmentation/line
            - layout/segmentation/classification
            - layout/analysis
        tags:
          description: Tools belong to this category, representing modules within the OCR-D project structure
          type: array
          items:
            type: string
            enum:
              - Image preprocessing
              - Layout analysis
              - Text recognition and optimization
              - Model training
              - Long-term archiving
              - Quality assurance
```

<!-- END-EVAL -->

## Example

<!-- BEGIN-EVAL -w '```json' '```' -- cat ../ocrd_tesserocr/ocrd-tool.json -->
```json
{
  "git_url": "https://github.com/ocr-d/ocrd_tesserocr",
  "dockerhub": "ocrd/ocrd-tesserocr",
  "tools": [
    {
      "tags": ["Layout analysis"],
      "description": "Segment page into regions with tesseract",
      "binary": "ocrd_tesserocr_segment_line",
      "step": "layout/segmentation/line"
    },
    {
      "tags": ["Layout analysis"],
      "description": "Segment regions into lines with tesseract",
      "binary": "ocrd_tesserocr_segment_region",
      "step": "layout/segmentation/region"
    },
    {
      "tags": ["Texterkennung"],
      "description": "Recognize text in lines with tesseract",
      "binary": "ocrd_tesserocr_recognize",
      "step": "recognition/text-recognition",
      "parameters": {
        "lang": {
          "type": "string",
          "enum": [
            "eng",
            "deu"
          ]
        }
      }
    }
  ]
}
```

<!-- END-EVAL -->


