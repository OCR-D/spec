# Web API

## Why we need a Web API?

The purpose of this specification is to improve the interoperability between Implementation Projects (IP). Based on a
common API definition, users can interact with different systems built by different IPs in the same way.

## The Specification

The Web API specification can be found [here](openapi.yml). It follows
the [OpenAPI specification](https://swagger.io/specification/). There are 4 parts to be implemented: discovery,
processing, workflow, and workspace.

**Discovery**: the endpoints in this section give information about the system to users. It includes but not limited to
hardware configuration, installed processors, and information about each processor.

**Processing**: via the endpoints in this section, one can get information about a specific processor, trigger a
processor, and check a status of a running processor. By exposing these endpoints, the Web API can encapsulate the
detailed setup of the system and offer users a single entry to the processors.

**Workflow**: unlike a single processor, one can manage workflows, which is a series of connected processors. In this
Web API spec, a workflow is a [Nextflow](https://www.nextflow.io/) script. Some information about Nextflow and how to
use it in OCR-D is documented [here](nextflow.md).

**Workspace**: [workspaces](https://ocr-d.de/en/user_guide#preparing-a-workspace) are managed via these endpoints. Users
always need to refer to an existing workspace when they want to trigger a processor or a workflow.

## REST API for Processors

### Why do we need this?

As described in the [OCR-D syntax](https://ocr-d.de/en/user_guide#ocr-d-syntax), one can call a single processor by
using the command

```shell
ocrd-[processor needed] -I [Input-Group] -O [Output-Group] -P [parameter]
# alternatively using Docker
docker run --rm -u $(id -u) -v $PWD:/data -w /data -- ocrd/all:maximum ocrd-[processor needed] -I [Input-Group] -O [Output-Group] -P [parameter]
```

Although this approach works perfectly fine, it poses a drawback: the processor cannot be called remotely. One always
needs to connect to the machine where the processor is installed and execute the command on the CLI. If the data is
small, one might not have to deal with this problem.

However, in the era of big data, where one has to constantly deal with a huge amount of input, resource utilization has
become vital and a distributed system is the way to go. To achieve a distributed OCR-D system, the mentioned drawback
must be overcome. Therefore, we provide a wrapper for processors to enable their communication over network ability.

### OCR-D Distributed System Architecture
