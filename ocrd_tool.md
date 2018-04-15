# Description of tools provided by MP

Tools MUST be described in a file `ocrd_tool.yml` in the root of the
repository. It must contain a YAML file adhering to the
[`ocrd_tool.schema.yml` YAML Schema](https://github.com/OCR-D/spec/blob/master/ocrd_tool.schema.yml).

In particular, every tool provided must be described in an entry under the `tools` key. These definitions drive the CLI and the web services.

To validate a `ocrd_tool.yml` file, use `ocrd validate-ocrd-tool -T /path/to/ocrd_tool.yml`.

## Definition

**This is a static copy as of 2018-04-13 14:43. Do not edit here but send PR to https://github.com/OCR-D/spec**

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
            - /preprocessing/characterization
            - /preprocessing/optimization
            - /preprocessing/optimization/cropping
            - /preprocessing/optimization/deskewing
            - /preprocessing/optimization/despeckling
            - /preprocessing/optimization/dewarping
            - /preprocessing/optimization/binarization
            - /recognition/text-recognition
            - /recognition/font-identifification
            - /layout/segmentation
            - /layout/segmentation/page
            - /layout/segmentation/line
            - /layout/segmentation/classification
            - /layout/analysis
        tags:
          description: Tools belong to this category, representing modules within the OCR-D project structure
          enum:
            - Image preprocessing
            - Layout analysis
            - Text recognition and optimization
            - Model training
            - Long-term archiving
            - Quality assurance
```

## Example

```json
{
  "git_url": "https://github.com/ocr-d/ocrd_tesserocr",
  "dockerhub": "ocrd/ocrd-tesserocr",
  "tools": [
    {
      "tags": ["Layout analysis"],
      "description": "Segment page into regions with tesseract",
      "binary": "ocrd_tesserocr_segment_line",
      "step": "segment-line"
    },
    {
      "tags": ["Layout analysis"],
      "description": "Segment regions into lines with tesseract",
      "binary": "ocrd_tesserocr_segment_region",
      "step": "segment-region"
    },
    {
      "tags": ["Texterkennung"],
      "description": "Recognize text in lines with tesseract",
      "binary": "ocrd_tesserocr_recognize",
      "step": "recognize"
    }
  ]
}
```




