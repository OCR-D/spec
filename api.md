# Web API

## Why we need a Web API?

The purpose of this specification is to improve the interoperability between Implementation Projects (IP). Based on a
common API definition, users can interact with different systems built by different IPs in the same way.

## The Specification

The Web API specification can be found [here][1]. It follows the [OpenAPI specification][2]. There are 4 parts to be
implemented: discovery, processing, workflow, and workspace.

## REST API for Processors

### Why do we need this?

As described in the [OCR-D syntax][8], one can call a single processor by using the command

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

[1]: openapi.yml

[2]: https://swagger.io/specification/

[8]: https://ocr-d.de/en/user_guide#ocr-d-syntax
