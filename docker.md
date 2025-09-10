# Dockerfile conventions

OCR-D [modules](glossary#ocr-d-module) SHOULD provide
a [Dockerfile](https://docs.docker.com/engine/reference/builder/)
that results in containers which bundle the [processor tools](cli)
along with all requirements.

## Based on OCR-D/core

Docker images SHOULD be based on the OCR-D base images at [GitHub Container Registry (GHCR)](https://github.com/OCR-D/core/pkgs/container/core):
```Dockerfile
FROM ghcr.io/ocr-d/core
```
or [Dockerhub](https://hub.docker.com/r/ocrd/core):
```Dockerfile
FROM docker.io/ocrd/core
```

(That stage itself is [based on](https://github.com/OCR-D/core/blob/77a385cef8c9dfefda841cb505cc829137ee0578/Makefile#L52) Ubuntu 20.04.)

For CUDA-enabled tools, the base stage SHOULD be
```Dockerfile
FROM ghcr.io/ocr-d/core-cuda
```
or
```Dockerfile
FROM docker.io/ocrd/core-cuda
```

(That stage itself is [based on]([https://github.com/OCR-D/core/blob/77a385cef8c9dfefda841cb505cc829137ee0578/Makefile#L52](https://github.com/OCR-D/core/blob/77a385cef8c9dfefda841cb505cc829137ee0578/Makefile#L222)) Ubuntu 20.04 
with multiple versions of the Nvidia CUDA runtime provided via the Micromamba distribution of Condaforge.)

For typical machine-learning frameworks, there are additional base stages:
- `core-cuda-tf1` (for Tensorflow 1.x)
- `core-cuda-tf2` (for Tensorflow 2.x)
- `core-cuda-torch` (for Pytorch)

This allows using the [`ocrd` multi-purpose tool](https://ocr-d.de/core/api/ocrd/ocrd.cli.html)
and the [OCR-D/core framework](https://ocr-d.de/core) (with a Python API and a bash library
to facilitate implementation of new and integration of existing tools)
to handle recurrent tasks in a spec-conformant way. 

Moreover, this makes using natively installed and containerized [CLI](cli) interchangeable.

(Sharing the base stage across many module images also saves network bandwidth and disk space.)

For flexibility, the `FROM` stage CAN also be passed in via build argument.

## Naming images

Docker image tags MUST be the same as the project name, optionally without the `ocrd_` prefix,
if this is already reflected by the namespace part (i.e. `ocrd/`).

Images distributed via Dockerhub MUST use the exact name specified under `dockerhub` in the
[ocrd-tool.json](ocrd_tool) file.

Images distributed via GHCR MUST use the Github organization in lower-case 
as namespace component and the Github repository name as repository component.

Examples:

| project name                                                | docker tag                                                  |
| ---                                                         | ---                                                         |
| [`ocrd_tesserocr`](https://github.com/OCR-D/ocrd_tesserocr) | [`ghcr.io/ocr-d/tesserocr`](https://github.com/orgs/OCR-D/packages/container/package/tesserocr) |
| [`ocrd_calamari`](https://github.com/OCR-D/ocrd_calamari)   | [`ocrd/calamari`](https://hub.docker.com/r/ocrd/calamari)   |
| [`ocrd_olena`](https://github.com/OCR-D/ocrd_olena)         | [`ocrd/olena`](https://hub.docker.com/r/ocrd/olena)         |
| [`ocrd_detectron2`](https://github.com/bertsky/ocrd_detectron2) | [`bertsky/ocrd_detectron2`](https://hub.docker.com/r/bertsky/ocrd_detectron2)         |

## Labelling images

The Dockerfile MUST accept build args `VCS_REF` and `BUILD_DATE`:

- `VCS_REF` contains the short id of the latest commit this image was built upon.
- `BUILD_DATE` contains an ISO-8601 date.

From these build args, the image SHOULD be labelled with this command:

```dockerfile
LABEL \
    maintainer="https://ocr-d.de/en/contact" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/YOUR/REPO" \
    org.label-schema.build-date=$BUILD_DATE \
    org.opencontainers.image.vendor="DFG-Funded Initiative for Optical Character Recognition Development" \
    org.opencontainers.image.title="REPO" \
    org.opencontainers.image.description="DESCRIPTION" \
    org.opencontainers.image.source="https://github.com/YOUR/REPO" \
    org.opencontainers.image.documentation="https://github.com/YOUR/REPO/blob/${VCS_REF}/README.md" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.base.name=ocrd/core
```

(as pertains to your module).

## Shell entrypoint

There SHOULD be no `CMD` provided (since running with different commands
like `ocrd` or `bash` should be possible; also, some modules will contain
multiple tools anyway).

There MUST be no `ENTRYPOINT` provided (for the same reason, and since
this cannot be overriden at runtime).

## Data volume

The directory `/data` in the the container should be marked as a volume
(to be mounted at runtime) to allow processing host data in the container in a uniform way.

## Example

### `Dockerfile`

```dockerfile
FROM ghcr.io/ocr-d/core
ARG VCS_REF
ARG BUILD_DATE
LABEL \
    maintainer="https://ocr-d.de/en/contakt" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/bar/ocrd_foo" \
    org.label-schema.build-date=$BUILD_DATE \
    org.opencontainers.image.vendor="DFG-Funded Initiative for Optical Character Recognition Development" \
    org.opencontainers.image.title="ocrd_foo" \
    org.opencontainers.image.description="OCR-D wrapper for FOO" \
    org.opencontainers.image.source="https://github.com/bar/ocrd_foo" \
    org.opencontainers.image.documentation="https://github.com/bar/ocrd_foo/blob/${VCS_REF}/README.md" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.base.name=ocrd/core

VOLUME ["/data"]

# avoid HOME/.local/share (hard to predict USER here)                                                                                        
# so let XDG_DATA_HOME coincide with fixed system location                                                                                   
# (can still be overridden by derived stages)                                                                                                
ENV XDG_DATA_HOME /usr/local/share
# avoid the need for an extra volume for persistent resource user db                                                                         
# (i.e. XDG_CONFIG_HOME/ocrd/resources.yml)                                                                                                  
ENV XDG_CONFIG_HOME /usr/local/share/ocrd-resources

# build and install
WORKDIR /build/module
COPY . .
# symlinks require an extra invitation
COPY ocrd-tool.json ocrd-tool.json
# prepackage ocrd-tool.json as ocrd-all-tool.json                                                                                            
RUN ocrd ocrd-tool ocrd-tool.json dump-tools > $(dirname $(ocrd bashlib filename))/ocrd-all-tool.json
# install everything and reduce image size                                                                                                   
RUN make deps-ubuntu deps install \
    && rm -fr /build/module

WORKDIR /data
```

### Command to build docker image

```sh
docker build \
  -t 'ghcr.io/ocr-d/foo' -t 'docker.io/ocrd/foo' \
	--build-arg VCS_REF=$(git rev-parse --short HEAD) \
	--build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  .
```
