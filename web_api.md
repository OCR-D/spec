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

## Usage

When a system implemented this Web API, it can be used as following:

1. User gets information about the system via endpoints in the `Discovery` section.
2. User creates a workspace via the `POST /workspace` endpoint and gets back a workspace ID.
3. User creates a workflow by uploading a Nextflow script to the system via the `POST /workflow` endpoint and get back a
   workflow ID.
4. User can either:
    * Trigger a single processor on a workspace by calling the `POST /processor/{executable}` endpoint with the chosen
      processor name and workspace ID, or
    * Start a workflow on a workspace by calling the `POST /workflow/{workflow-id}` endpoint with the chosen workflow ID
      and workspace ID.
    * In both case, a job ID is returned to the user.
5. With the given job ID, user can check the job status by calling:
    * `GET /processor/{executable}/{job-id}` for a single processor, or
    * `GET /workflow/{workflow-id}/{job-id}` for the workflow.
6. The result can be downloaded by calling the `GET /workspace/{workspace-id}` endpoint with the
   header `Accept: application/vnd.ocrd+zip`. Without that header, only the metadata of the specified workspace is
   returned.

## Suggested Architecture for the Implementers

### Centralized approach

There are different ways to build a system which implements this Web API. The simplest way is having everything
implemented and installed in one server, as shown in Figure 1.

<figure>
  <img src="images/web-api-simple.jpg" alt="A simple architecture of a system with Web API"/>
  <figcaption align="center">
    <b>Fig. 1:</b> The simplest architecture, where a server implements all endpoints and has all processors as well as Nextflow installed locally.
  </figcaption>
</figure>

In this case, the Web API Server implements all endpoints from this specification. On the same machine, there are also
all processors and Nextflow installed, either natively or using Docker. Whenever a request arrives, the Web API Server
just calls the appropriate command, e.g. `ocrd-[processor]` or Nextflow related command, and returns results to the
users.

A database is needed to store necessary information, such as users requests, the job status, path to workspace, etc. We
recommend to use [MongoDB](https://www.mongodb.com/) since it is used by the [Processor API](#rest-api-for-processors),
but other kind of storage will work fine as well.

The Web API Server requires access to the file system so that it can manage the workspace. In this simple setup, the
file system can just be the local file system on the machine, where the Web API Server is deployed.

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
