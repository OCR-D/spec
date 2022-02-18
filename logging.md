# Communicate Processor State with Logging and Exceptions

This section specifies how the output of the digitization workflow is handled.

## Target Audience

Users and developers of digitization workflows in libraries and/or digitization centers.

## Introduction

State communication is essential for developers and users to debug and understand application behavior.

One should be able to choose between two contradictory goals: 
- faster Runtime 
- more Information 

### Labelling

Depending on use case, it should be possible to configure the amount of output and the communication channels as granular or coarse as required.

### Quality Assurance

Processor output might be addressed by an optional dedicated test scenario or appropriate suite. They are _not_ part of detailed unit test cases, which document the functional behavior for a processor.

### Persistence

When a processor is executed, the output MAY be stored in files.

If log files are to be included in the Metadata, the file name SHOULD contain the ID of the data/page in the provenance and the name of the stream:
`FILENAME := ACTIVITY_ID + "_" + OUTPUT_STREAM + ".log"` , for example: `ocrd-kraken-bin_0001_stdout.log`

## Log Levels

A more detailed description will be found [here](https://stackoverflow.com/questions/2031163/when-to-use-the-different-log-levels/5278006#5278006)

### TRACE / ALL

This is the most verbose logging level to trace the path of the algorithm with intermediate state/results at most granular level, even loop executions may be logged. _Please note, that logging within loops can dramatically affect performance_.

### DEBUG

This level is used if parameters and or the status of an algorithm/method should be logged. 

### INFO

Might include rather statistical information:
* used configuration
* recived input, produced final output data
* processing time duration
* quality estimation

### WARN

Might communicate suspicious conditions, which a robust processor _should be able to handle_:
* information about required/missing configuration, replaced by defaults
* processor in/output data outside usual ranges (if defined), indicate unexpected, but still valid results, for example for layout analyzis or cropping
* example conditions: blank pages, segmentation overlaps (might be curated at later stages), high deskewing angles (might be valid if content/regions are rotated)

### ERROR

This level indicates internal processor failures, like
* violation of processor invariants (if defined, like DivisionByZero, processing timeouts, etc.)
* events that produce no or likely wrong results
It's up the processor to decide, whether to stop execution, or not.
* example conditions: images with size Zero, complete lack of data from preceeding processor, OAI-PMH-403-Responses

### CRITICAL / FATAL / RuntimeErrors

Events (rather non-functional circumstances) that cannot be handled by the processor itself and result into instant shutdown of the workflow. 
* example conditions: missing read/write permissions, I/O-errors,  OutOfMemory

## Format
The format of the logging output has to be formatted like this:
TIMESTAMP LEVEL LOGGERNAME - MESSAGE
***Example:***
08:03:40.017 WARN edu.kit.ocrd.MyTestClass - A warn message

## METS

The log files are not referenced inside METS.
If they are listed in the provenance section, their content must be included in the provenance.

## Ingest Workspace to OCR-D Repositorium

No log files will be stored in repository

## Use Cases
### Workflow State Communication

All processors executed during workflow mights write to STDERR and STDOUT, which might be captured. Furthermore, processor might raise custom RuntimeErrors/Exceptions, which will result in immediate shutdown if not being handled.

STDERR contains level error and above messages that cause the program to terminate (see [Loglevel ERROR](#ERROR)).

STDOUT should only contain at most outputs log level WARN (see [Loglevel WARN](#WARN)).

### Mass Digitalization / Automated Workflows

For automated workflows it is recommended to save STDERR only, i.e. starting with minimum Level ERROR/FATAL and RuntimeErrors, respectively.

### Analyze Processor Behavior

All processors executed during workflow have to write their output to STDERR and STDOUT.

Since both outputs are used to analyze the program flow, at most all information should be available.


