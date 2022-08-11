
# Decisions in OCR-D

In a software project, especially a highly distributed one like OCR-D, decisions need to be made on the technology used, how interfaces should interoperate and how the software as a whole is designed.

In this document, such decisions on key aspects of OCR-D are discussed for the benefit of all OCR-D stakeholders.

## Web API

### What the Web API is

### Why we need a Web API

The Web API is an important increment for implementers to be able to base their outward-facing HTTP 
interfaces on a common API definition, so that the different implementations are interoperable on this level.

### Basic Architecture

## Workflows

### What is NF and why did we choose it?

Nextflow (NF) is a workflow framework that allows the integration of various scripting languages into a single cohesive pipeline. Nextflow also has its own Domain Specific Language (DSL) that extends Groovy (extension of Java).


We choose it due to its rich set of features:
- Stream oriented: Promotes programming approach extending Unix pipes model.
- Fast Prototyping: Lets you write a computational pipeline from smaller tasks.

- Reproducibility: Supports Docker, Singularity, and 3 other types of containers.
- Portable: Can run locally, Slurm, SGE, PBS, and cloud (Google, Kubernetes, and AWS).
- Continuous checkpoints: Each process in the workflow is checkpointed. It is possible to retry 
failed workflows and start from the last checkpoint.
- Supports various scripting languages including Bash, Python, Perl, and others.
- Enables separation between configuration (how to do) and workflow logic (what to do).
- Modularization of tasks possible via workflow, sub-workflows, and processes.
- Provides detailed logs and various types of execution reports.

### How is the NF script structured?

The NF script contains the following structures:
#### 2.1 DSL and Parameters
#### 2.2 Definition of processes
#### 2.3 Definition of workflows
#### 2.4 Main workflow

Check this source code example: [seq_ocrd_wf_many.nf](https://github.com/MehmedGIT/OPERANDI_TestRepo/blob/master/ExampleWorkflows/Nextflow/workflow4/seq_ocrd_wf_many.nf)

TODO: I will provide more structure-related details here based on the example above.

### Which features of NF do we use, i.e. what features have to be implemented in potential implementations?
The minimally used features for local runs are the parameters, processes, process decorators, and workflows. I will provide further answers to any following questions related to this main question. I am not sure what else to cover here for now.

## How does parallelization work, both within works and across works?

A Nextflow workflow script contains several processes. Processes are executed independently and are isolated from each other (i.e. they do not have a shared memory space). Communication between the processes is possible only through data channels (similar to the pipes model in Unix). These channels are basically asynchronous FIFO queues. Any process can define one or more channels as input and output. The order of interaction between these processes, and ultimately the order of workflow execution depends on the communication channel dependencies between processes. For example, if process A writes data to channel A and process B reads data from channel A, then Nextflow knows that process A must be executed before process B.

Check this source code example: [seq_ocrd_wf_many.nf](https://github.com/MehmedGIT/OPERANDI_TestRepo/blob/master/ExampleWorkflows/Nextflow/workflow4/seq_ocrd_wf_many.nf)

TODO: I will provide more parallelization details here based on the example above.

## How does the NF script interact with the processing server?
As of Aug 2022 the processing server implementation in OCR-D/core is not yet finished, cf. https://github.com/OCR-D/core/pull/884 and https://github.com/OCR-D/core/pull/652. 

The interaction will most probably happen with curl through a bash script inside the Nextflow process. Of course, if it is integrated inside the OCR-D core, then no direct interactions will be needed from inside the Nextflow script.

## How does the NF script interact with the METS server?
As of August, 2022, the METS server implementation is still unfinished.

The interaction will most probably happen with curl through a bash script inside the Nextflow process. Of course, if it is integrated inside the OCR-D core, then no direct interactions will be needed from inside the Nextflow script.

## How to convert the existing OCR-D process workflows we reference to NF?
I have written an OtoN (OCR-D to Nextflow) converter which converts basic OCR-D process workflows to Nextflow workflow scripts. Check here: [OtoN](https://github.com/MehmedGIT/OtoN_Converter)

Keep in mind that I have just started working on the converter. It is still very fresh and there are still known problems (related to the produced Nextflow scripts) and I am trying to fix them. It is also not convenient to use (no proper CLI). Neither it has usage instructions. Stay tuned for more updates. 

I have tested most edge cases for the lexer/parser of the OCR-D process file while implementing. There may be 
input OCR-D process files that are not handled well enough. Feel free to report any bugs, errors, or lack of errors (when an error is expected). 

The tool will probably be a part of the OCR-D software in the future when it is stable enough for general use.

## How should NF scripts be written, tested, deployed, and evaluated?
Depends on the use case. Detailed instructions for local executions and example Nextflow workflow scripts can be found here: [Nextflow](https://github.com/MehmedGIT/OPERANDI_TestRepo/tree/master/ExampleWorkflows/Nextflow)

I will provide further answers to any following questions related to this main question.

## What conventions do we encourage, naming, structure, documentation, etc.?
Try to stick to the structure provided in section [How is the NF script structured](#how-is-the-nf-script-structured) when writing Nextflow scripts. You can also check the Nextflow examples provided in section [Main workflow](#main-workflow). The naming conventions for variables, function names, process names, and workflow names are encouraged to follow the snake case.I will provide further answers to any following questions related to this main question.



## Benchmarking
