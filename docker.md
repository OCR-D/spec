# Dockerfile provided by MP

MP should provide a [Dockerfile](https://docs.docker.com/engine/reference/builder/) that should result in a container to execute the CLI with all dependencies bundled.

It should be based on the [ocrd base image](https://hub.docker.com/r/ocrd/pyocrd/) (which itself is based on Ubuntu 18.04), so consumers can use the `ocrd` cli and helpers for a uniform user/integration experience.

```dockerfile=
FROM ocrd:pyocrd

# Install M

ENTRYPOINT ["/bin/sh", "-c"]
```
