# Conventions for LOGGING
This section specifies how the output of the digitization workflow is logged.
## Target Audience
Users and developers of digitization workflows in libraries and/or digitization centers.
## Introduction
Logging is essential for developers and users to debug applications.
You always have to choose between two contradictory goals: 
- Runtime 
- Information 

Many issues make troubleshooting easier but have a negative effect on the runtime.
Therefore, log levels have been introduced to customize the output to suit your needs.

When a workflow is executed, the output of the applications should be stored in files.
All log outputs should be listed in the provenance.

## Log Levels
A more detailed description will be found [here](https://stackoverflow.com/questions/2031163/when-to-use-the-different-log-levels/5278006#5278006)
### TRACE / ALL
This is the most verbose logging level to trace the path of the algorithm.
E.g.: Start/End/Duration of a method, even loops may be logged. 
Note that logging within loops can dramatically affect performance.
### DEBUG
This level is used if parameters and or the status of an algorithm/method should be logged. 
### INFO
Log information about used settings on application level.
### WARN
This level is used to log information about missing/wrong configurations which may lead to errors.
### ERROR
Log all events that produce no or a wrong result. 
It is useful to output all the information that helps to determine the cause without the need for further investigation.


## Format
The format of the logging output has to be formatted like this:
TIMESTAMP LEVEL LOGGERNAME - MESSAGE
***Example:***
08:03:40.017 WARN edu.kit.ocrd.MyTestClass - A warn message
:warning: 
Since only the time stamp is logged, the log should be written to files that change daily.

## METS
### File Group
File groups holding logging have to start with prefix "LOG-"

## Use Cases
### Log during the Workflow
All applications executed during workflow have to write there logging to STDERR and STDOUT.
Since both outputs are also stored in the provenance, only information that is important 
for later analysis should be provided.
STDERR only contains error messages that cause the program to terminate (see [Loglevel ERROR](#ERROR)).
STDOUT should only contain outputs that are maximum of the log level INFO (see [Loglevel INFO](#INFO)).
### Analyze applications
All applications executed during workflow have to write there logging to STDERR and STDOUT.
Since both outputs are used to analyze the program flow and possible errors and the performance 
is not important, all information should be output here.


