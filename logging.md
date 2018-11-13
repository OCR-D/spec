# Conventions for LOGGING
[See issues](https://github.com/OCR-D/spec/issues/11)
All logging may be stored in files. 
If so, they must be given in Provenance as a result. 

## Log Levels
(Is there any definition we could link to)
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
It is useful to provide so much information that could provide information about the cause.


## Format
The format of the logging output have to formatted like this:
TIMESTAMP LEVEL LOGGERNAME - MESSAGE
***Example:***
08:03:40.017 WARN edu.kit.ocrd.MyTestClass - A warn message
:warning: 
Since only the time stamp is logged, the log should be written to files that change daily.

## METS
### File Group
File group holding logging have to start with prefix "LOG-"

