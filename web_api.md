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

There are different ways to build a system which implements this Web API. In this section, we suggest 3 types of
architecture, starting from the simplest setup. The implementers do not have to strictly follow one of them, but free to
choose the approach which fits their situation best.

### Centralized System Architecture

The simplest way is having everything implemented and installed in one server, as shown in Figure 1. In this case, the
Web API Server implements all endpoints from this specification. On the same machine, there are also all processors and
Nextflow installed, either natively or using Docker. Whenever a request arrives, the Web API Server just calls the
appropriate command, e.g. `ocrd-[processor]` or Nextflow related command, and returns results to the users.

<figure>
  <img src="images/web-api-simple.jpg" alt="A simple architecture of a system with Web API"/>
  <figcaption align="center">
    <b>Fig. 1:</b> The simplest architecture, where a server implements all endpoints and has all processors as well as Nextflow installed locally.
  </figcaption>
</figure>

A database is needed to store necessary information, such as users requests, the job status, path to workspace, etc. We
recommend to use [MongoDB](https://www.mongodb.com/) since it is used by the [Processor API](#rest-api-for-processors),
but other kind of storage will work fine as well.

The Web API Server requires access to the file system so that it can manage the workspace. In this simple setup, the
file system can just be the local file system on the machine, where the Web API Server is deployed.

### Separate the Web API Server

Instead of implementing all endpoints of the specification in one server, it might make sense to separate them into many
servers. If so, a reverse proxy should be deployed in front of these servers. It handles all requests from users and
routes them to the responsible server. Figure 2 shows this setup. There are three servers, which are responsible for
different sections in the Web API specification, as they are named. In this case, all processors and Nextflow are
installed only in the Processing/Workflow Server. A workflow is basically a series of processors connecting to each
other. Therefore, it is better to have the `Processing` and `Workflow` part implemented in the same server. Otherwise,
we need to install all processors on the Workflow Server as well.

<figure>
  <img src="images/web-api-partly-distributed.jpg" alt="Different servers implement different parts of the Web API"/>
  <figcaption align="center">
    <b>Fig. 2:</b> The Web API specification is implemented by many servers, each of them is responsible for different sets of endpoints, as they are named.
  </figcaption>
</figure>

The Processing/Workflow and Workspace server need access to workspaces created from users' requests. Instead of
moving the workspaces between the servers, it is more efficient to set up a Network File System (NFS) and share the
access among them. The Discovery server, on the other hand, has nothing to do with workspaces. Therefore, it only needs
access to the database.

By separating the responsibility, one can easily customize a server to fit its need. For example, the Discovery server
does not need as many resources as the Processing/Workflow server. It is also possible to scale out a type of server
in case it is heavily used. This setup is also enhance security since we can restrict access to all components and only
expose the reverse proxy to the public network. Last but not least, each component can be developed independently, and a
failure of one does not lead to the failure of the whole system.

### Distributed System Architecture

In the previous approach, all processors are installed on the Processing/Workflow server, either natively or via Docker.
We can take one step further by having each processor running on a different machine and communicate with them via
[their REST API](#rest-api-for-processors), as illustrated in Figure 3.

<figure>
  <img src="images/web-api-distributed.jpg" alt="Distributed architecture with the Web API"/>
  <figcaption align="center">
    <b>Fig. 3:</b> A distributed architecture, where each processor runs as a server on their own machine and communicates via REST API. The Workflow Server is also separated from the Processing Server.
  </figcaption>
</figure>

By having each processor running on its own machine, it can reduce the risk of conflicting. Furthermore, we can
customize the machine to fit best to the processor as well as its need. For example, some processors need GPU, some do
not, or some need more compute power while others need more memory. It is also easier to scale out the processors, or
even apply Function-as-a-Service on some of them, which are not constantly used, to save resources. The Processing
Server in this case plays the role as an entrance to the processors. It takes a request, pre-process it if necessary,
and forward it to the appropriate processor. The caller does not need to know the detail about the deployment of each
processor (e.g. which IP address, which port).

Since processors are now running independently, there is no need to have the `Workflow` and `Processing` section in the
Web API implemented on the same machine anymore. Instead, we can have a Workflow Server separated from the Processing
Server, and Nextflow is installed on this server. This Workflow Server does not require access to file system, but
instead the access to processors and the database.

## REST API for Processors

In the [Distributed System Architecture](#distributed-system-architecture), we describe a case, where a processor runs
as a server instead of its usual one-shot mode. This section describe the REST API of processor in detail, which we call
it _Processor API_.

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
small, this might not be a problem. However, in the era of big data, where one has to constantly deal with a huge amount
of input, resource utilization has become vital and a distributed system is the way to go. To achieve a distributed
OCR-D system, the mentioned drawback must be overcome. Therefore, we provide a wrapper for processors to enable their
communication over network ability.

### Usage

Since the Processor API uses [MongoDB](https://www.mongodb.com/) to store data, we must have an instance of MongoDB
running before starting a Processor API. There are 2 ways to start it:

```shell
# 1. Via processor CLI
ocrd-[processor needed] --server=<ip>:<port>:<mongo-url>

# 2. Via ocrd CLI
ocrd server --server=<ip>:<port>:<mongo-url> <processor-name>
```

The parameters are:

1. `processor-name`: name of the processor, e.g. `ocrd-dummy`
2. `ip`: the IP address to which the server should bind, e.g. `0.0.0.0`
3. `port`: the port number on which the server should listen, e.g. `80`
4. `mongo-url`: the URL to the Mongo database, e.g. `mongodb://localhost:27017`

For example, to have an `ocrd-dummy` processor running at port `80` of all IPv4 addresses on the local machine and
connecting to a MongoDB instance at `localhost:27017`, we run one of the two commands:

```shell
# 1. Via processor CLI
ocrd-dummy --server=0.0.0.0:80:mongodb://localhost:27017

# 2. Via ocrd CLI
ocrd server --server=0.0.0.0:80:mongodb://localhost:27017 ocrd-dummy
```

**Note**: this feature is currently under code review. Once it is finished and release, this page will be updated with
more information regarding the endpoints of the Processor API.
