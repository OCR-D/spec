# Dockerfile provided by MP

MP should provide a
[Dockerfile](https://docs.docker.com/engine/reference/builder/) that should
result in a container which bundles the [tools developed by the MP](cli) along
with all requirements.

## Based on ocrd:pyocrd

Docker containers should be based on the [ocrd base
image](https://hub.docker.com/r/ocrd/pyocrd/) which itself is based on Ubuntu
18.04. For one, this allows MP to use the `ocrd` tool to handle recurrent tasks
in a spec-conformant way. Besides, it locally installed and containerized
[CLI](cli) interchangeable.

## Shell entrypoint

The `ENTRYPOINT` should a be a shell call not the tool provided. A non-shell
entrypoint would restrict MP to just one tool.

## `/data` as volume

The directory `/data` in the the container should be marked as a volume to
allow processing host data in the container in a uniform way.

## Example

```dockerfile=
FROM ocrd:pyocrd
VOLUME ["/data"]

# RUN-commands to install requirements, build and install

ENTRYPOINT ["/bin/sh", "-c"]
```
