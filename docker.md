# Dockerfile conventions

OCR-D [modules](glossary#ocr-d-module) SHOULD provide
a [Dockerfile](https://docs.docker.com/engine/reference/builder/)
that results in containers which bundle the [processor tools](cli)
along with all requirements.

## Based on OCR-D/core

Docker images SHOULD be based on the [OCR-D base image](https://github.com/OCR-D/core/pkgs/container/core):
```Dockerfile
FROM ghcr.io/ocr-d/core
```
(That stage itself is [based on](https://github.com/OCR-D/core/blob/77a385cef8c9dfefda841cb505cc829137ee0578/Makefile#L52) Ubuntu 20.04.)

– or, for CUDA-enabled tools –
```Dockerfile
FROM ghcr.io/ocr-d/core-cuda
```
(That stage itself is [based on]([https://github.com/OCR-D/core/blob/77a385cef8c9dfefda841cb505cc829137ee0578/Makefile#L52](https://github.com/OCR-D/core/blob/77a385cef8c9dfefda841cb505cc829137ee0578/Makefile#L222)) Ubuntu 20.04 with multiple versions of the Nvidia CUDA runtime.)

This allows using the [`ocrd` multi-purpose tool](https://ocr-d.de/core/api/ocrd/ocrd.cli.html)
and the [OCR-D/core framework](https://ocr-d.de/core) (with a Python API and a bash library
to facilitate implementation of new and integration of existing tools)
to handle recurrent tasks in a spec-conformant way.

Moreover, this makes using natively installed and containerized [CLI](cli) interchangeable.

## Naming images

Docker image tags MUST be the same as the project name but with underscore (`_`)
replaced with forward slash (`/`).

Examples:

| project name                                                | docker tag                                                  |
| ---                                                         | ---                                                         |
| [`ocrd_tesserocr`](https://github.com/OCR-D/ocrd_tesserocr) | [`ghcr.io/ocr-d/tesserocr`](https://github.com/orgs/OCR-D/packages/container/package/tesserocr) |
| [`ocrd_calamari`](https://github.com/OCR-D/ocrd_calamari)   | [`ocrd/calamari`](https://hub.docker.com/r/ocrd/calamari)   |
| [`ocrd_olena`](https://github.com/OCR-D/ocrd_olena)         | [`ocrd/olena`](https://hub.docker.com/r/ocrd/olena)         |

## Labelling images

The Dockerfile MUST accept build args `VCS_REF` and `BUILD_DATE`.

`VCS_REF` contains the short id of the latest commit this image was built upon.

`BUILD_DATE` contains an ISO-8601 date.

From these build args, the image shall be labelled with this command:

```dockerfile
LABEL \
    maintainer="https://github.com/YOUR/PROJECT/issues" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/YOUR/PROJECT" \
    org.label-schema.build-date=$BUILD_DATE
```

`maintainer` and `org.label-schema.cvs-url` shall point to the issues and
landing page of the GitHub project resp.

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
FROM ghcr.io/ocr-d:core
VOLUME ["/data"]
ARG VCS_REF
ARG BUILD_DATE
LABEL \
    maintainer="https://github.com/bar/ocrd_foo/issues" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/bar/ocrd_foo" \
    org.label-schema.build-date=$BUILD_DATE

# RUN-commands to install requirements, build and install
# e.g.
# apt-get install -y curl

CMD ["/usr/local/bin/ocrd-foo", "--help"]
```

### Command to build docker image

```sh
docker build \
  -t 'ghcr.io/ocr-d/foo' \
	--build-arg VCS_REF=$(git rev-parse --short HEAD) \
	--build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
```
