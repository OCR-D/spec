# OCR-D Workflow format
> Sequence of [processor](glossary#processor) [calls](cli)

Revision: 1

## Rationale

OCR consists of many [steps](glossary#activities) that need to be run in
sequence ([*workflow*](glossary#workflow)). In OCR-D, these steps are
implemented in [*processors*](https://ocr-d.de/en/workflows), executables that
read and write files to one or more `mets:fileGrp` in a METS document. While it
is possible to define such a workflow as a sequence of commands in a shell
script, that approach has many drawbacks (no checks for correct input/output
wiring, no syntax checks, easy to end up with an invalid
[workspace](glossary#workspace)).

A subset of shell script is however a good solution to define a common,
workflow-engine-agnostic syntax for workflows in OCR-D. It is straightforward
to tokenize [according to
POSIX](https://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_03)
(`sh`) and every processor invocation can be parsed according to the [OCR-D CLI
spec](cli). Every step can be reproduced easily by executing it in a command
shell.

While such an OCR-D workflow description "script" (*OCRD-WF*) is syntactically
compatible with a POSIX-compliant command shell, it has different semantics and
supports only a small subset of shell script syntax and functionality.

## File structure and syntax

A OCRD-WF script has two logical sections: preamble and steps.

The preamble contains the shebang and any variable
assignments while the steps contain the processor calls. Both preamble and steps can
contain any number of comment lines.

### Shebang

The first line of every OCRD-WF must match the regular expression
`#!/usr/bin/env ocrd-wf-v[1-9]+[0-9]*\n` 

The number represents the revision of this spec, so initially, all OCRD-WF
should begin with `#!/usr/bin/env ocrd-wf-v1`.

### Comments

Any line that begins with a number of whitespace (tab `\x09` or space `\x20`) characters
(including zero) followed by the character "#" (*pound sign*, `\x23`).

### Line continuation

If a line ends with "\" (*backslash*, `\x5c`), backslash and newline are
removed and the next line, without leading whitespace, is appended. This is
repeated as long as the next line ends with a backslash.

### Variable Assignments

An OCRD-WF can contain variable assignments of the form `name=value\n`. `name` must be
a valid `sh` identifier. Everything to the right of `=` is parsed as a string after expanding quotation (i.e. removing enclosing pairs of double `"` or single `'` quotes, or backslash `\` to _escape_ the special meaning of the following character, with `\\`, `\"`, and `\'` for literal backslash, double quote, and single quote, respectively). Note: whitespace is not allowed anywhere, except as quoted part of `value`.

<!-- TODO define behavior? -->
**NOTE** The semantics of assigning `value` to `name` are implementation-dependent

## Parsing Algorithm

The parsing algorithm consists of a set of passes. It should inform
implementers, but does not require require an exact implementation, as long as
the result is the same.

**NOTE** Unlike in POSIX shell, comments are removed before line continuations are
resolved, so you can intersperse line continuation with comments:

```sh
ocrd-foo \
  # This parameter does bar
  -P foo bar
```

### Check shebang

* assert that line[0] is `#!/usr/bin/env ocrd-wf`

### Preprocess comments

* set new_lines to empty list
* for every line
  * if line does not begin with `\s*#`:
    * add line to new_lines
* return new_lines

### Preprocess line continuation

* set new_lines to empty list
- for every line index *n* in lines:
  * set continued_lines to 0
  * while lines[n] ends with backslash:
    * remove backslash and newline from lines[n]
    * remove leading whitespace from lines[n + 1]
    * append lines[n + 1] to lines[n]
    * increment continued_lines by 1
  * add lines[n] to new_lines
  * increment n by continued_lines
* return new_lines

### Tokenize

*according to POSIX rules* means handling quotes and escapes like a UNIX shell.

* set steps_tokens, assignments_tokens to empty lists
* for every line:
  * trim leading/trailing whitespace
  * if line is empty:
    * continue
  * if line begins with "ocrd-":
    * split line into tokens according to POSIX rules
    * add tokens to steps_tokens
    * continue
  * if line matches the regular expression `^[A-Za-z][A-Za-z0-9_]=.*`:
    * split line into tokens according to POSIX rules
    * if there is more than one token:
      * raise an error "tokens after assignment"
    * add first token to assignments_tokens
    * continue
  * raise an error "unhandled line"
* return steps_tokens, assignments_tokens

### Parse

* set steps to empty list
* for step_tokens in steps_tokens:
  * for tokens in step_tokens:
    * set step to empty map
    * set step.parameters to empty map
    * set step.executable to tokens[0]
    * remove tokens[0]
    * parse tokens to step [according to OCR-D CLI spec](cli) but raise an error for these options:
      * `-m/--mets` (provided by the workflow engine)
      * `-h/--help`
      * `--version`
      * `-J--dump-json`
    * add step to steps
* set assignments to empty map
* for token in assignments_tokens:
  * split tokens at the first equal sign into key and value
  * set assignments.key to value
* return steps, assignments

## Validation

### Well-formedness

OCRD-WF is *well-formed* if it can be parsed.

### Resolveability

OCRD-WF is *resolveable* if it is well-formed and
  * all executables are available (either as an executable in `$PATH` or some abstraction of it)
  * all exceutbales can be resolved to their resp. [`ocrd-tool.json`](ocrd_tool) (e.g. [`--dump-json`](cli#--J--dump-json))
  * the parameters in all steps are valid according to their JSON-Schema definition.

Resolveability can only be determined in the context of a deployment.

### Consistency

OCRD-WF is *consistent* if it is resolveable and all input file groups
  * are either output file groups of previous steps or
  * exist in the METS file this workflow is executed on

### EBNF

<!-- TODO: questionable whether helpful -->

```c
nl = "\x0a"
ws = "\x09" | "\x20"
any = ("\x00" .. "\xffff") - nl
bslash = "\x5c"
not-bslash = any - bslash
alpha = "A" .. "Z" | "a" .. "z"
alnum = alpha | "0" .. "9"
comment-prefix = "#"

shebang = "#!/usr/bin/env ocrd-wf\n"
processor-name = alnum +(alnum | "-")

ocrd-wf = preface steps
preface = shebang *(comment-line | assignment-line)
steps = *(comment-line | processor-line)

assignment-line = *ws alnum "=" *any
comment-line = *ws *(comment-prefix *any) nl
processor-line = *ws processor-name *any nl
```



## IANA Considerations

### `text/vnd.ocrd+sh`

Type name:
  - `text`
Subtype name:
  - `vnd.ocrd+sh`
Encoding considerations:
  - `UTF-8`
Published specification:
  - https://ocr-de.de/en/spec/workflow
Applications that use this media type:
  - https://ocr-de.de/en/spec/workflow#implementations
Magic number:
  - `#!/usr/bin/env ocrd-wf`
File extension:
  `.ocrd.sh`

## Appendix

### Examples

```sh
    first command
ocrd-olena-binarize           -I OCR-D-IMG                   -O OCR-D-BIN                 -P impl sauvola
ocrd-anybaseocr-crop          -I OCR-D-BIN                   -O OCR-D-CROP
ocrd-olena-binarize           -I OCR-D-CROP                  -O OCR-D-BIN2                -P impl kim
ocrd-cis-ocropy-denoise       -I OCR-D-BIN2                  -O OCR-D-BIN-DENOISE         -P level-of-operation page
ocrd-tesserocr-deskew         -I OCR-D-BIN-DENOISE           -O OCR-D-BIN-DENOISE-DESKEW  -P operation_level page
ocrd-tesserocr-segment-region -I OCR-D-BIN-DENOISE-DESKEW    -O OCR-D-SEG-REG
ocrd-segment-repair           -I OCR-D-SEG-REG               -O OCR-D-SEG-REPAIR          -P plausibilize true
ocrd-cis-ocropy-deskew        -I OCR-D-SEG-REPAIR            -O OCR-D-SEG-REG-DESKEW      -P level-of-operation region
ocrd-cis-ocropy-clip          -I OCR-D-SEG-REG-DESKEW        -O OCR-D-SEG-REG-DESKEW-CLIP -P level-of-operation region
ocrd-tesserocr-segment-line   -I OCR-D-SEG-REG-DESKEW-CLIP   -O OCR-D-SEG-LINE
ocrd-segment-repair           -I OCR-D-SEG-LINE              -O OCR-D-SEG-REPAIR-LINE     -P sanitize true
ocrd-cis-ocropy-dewarp        -I OCR-D-SEG-REPAIR-LINE       -O OCR-D-SEG-LINE-RESEG-DEWARP
ocrd-calamari-recognize       -I OCR-D-SEG-LINE-RESEG-DEWARP -O OCR-D-OCR \
  # This parameter should point to a glob of all the .ckpt.json files of a calamari model directory
  -P checkpoint /path/to/models/\*.ckpt.json
```
