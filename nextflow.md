# Workflow Format (Nextflow)

One key task in phase III of OCR-D was to define a workflow format describing sequences of OCR-D processors processing the images. Our solution is based on the open source project [Nextflow (NF)](https://www.nextflow.io/).
The files (with the extension ```.nf```) describing this sequence can be generated and read both by humans and algorithms and can be more complex and flexible than the temporary solution with
```ocrd process```.

Nextflow is a workflow framework that allows the integration of various scripting languages into a single cohesive pipeline. 
Nextflow also has its own Domain Specific Language (DSL) that extends Groovy (extension of Java).

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

## Structure of the Nextflow script
The NF script contains the following structures:

### DSL and Parameters

```nextflow
// enables a syntax extension that allows definition of module libraries
nextflow.enable.dsl=2

// pipeline parameters
params.mets_path = ""  // Just a placeholder for the value to be passed by the caller
// The entry point of the workflow
params.input_file_grp = ""  // Just a placeholder for the value to be passed by the caller

// The caller of the script then executes with
// nextflow run "path/to/nf_script" --mets_path "path/to/mets" --input_file_grp "file group"

```
### Definition of a process

```nextflow
process < name > {

  [ directives ]

  input:
    < process inputs >

  output:
    < process outputs >

  when:
    < condition >

  [script|shell|exec]:
    < user script to be executed >

}
```
### Definition of a workflow
```nextflow
workflow {
  main:
    process_one(...)
    process_two(process_one.out, ...)
    process_three(process_two.out, ...)
}
```

### An example Nextflow script
```nextflow
nextflow.enable.dsl=2

params.mets_path = ""
params.input_file_grp = ""

process step_1 {
  input:
    val in_dir
    val out_dir
  output:
    val out_dir
  script:
    """
    ocrd-cis-ocropy-binarize --mets ${params.mets_path} -I ${in_dir} -O ${out_dir}
    """
}

process step_2 {
  input:
    val in_dir
    val out_dir
  output:
    val out_dir
  script:
    """
    ocrd-anybaseocr-crop --mets ${params.mets_path} -I ${in_dir} -O ${out_dir}
    """
}

process step_3 {
  input:
    val in_dir
    val out_dir
  output:
    val out_dir
  script:
    """
    ocrd-skimage-binarize --mets ${params.mets_path} -I ${in_dir} -O ${out_dir} -P method li
    """
}

process step_4 {
  input:
    val in_dir
    val out_dir
  output:
    val out_dir
  script:
    """
    ocrd-skimage-denoise --mets ${params.mets_path} -I ${in_dir} -O ${out_dir} -P level-of-operation page
    """
}

process step_5 {
  input:
    val in_dir
    val out_dir
  output:
    val out_dir
  script:
    """
    ocrd-tesserocr-deskew --mets ${params.mets_path} -I ${in_dir} -O ${out_dir} -P operation_level page
    """
}

process step_6 {
  input:
    val in_dir
    val out_dir
  output:
    val out_dir
  script:
    """
    ocrd-cis-ocropy-segment --mets ${params.mets_path} -I ${in_dir} -O ${out_dir} -P level-of-operation page
    """
}

process step_7 {
  input:
    val in_dir
    val out_dir
  output:
    val out_dir
  script:
    """
    ocrd-cis-ocropy-dewarp --mets ${params.mets_path} -I ${in_dir} -O ${out_dir}
    """
}

process step_8 {
  input:
    val in_dir
    val out_dir
  output:
    val out_dir
  script:
    """
    ocrd-calamari-recognize --mets ${params.mets_path} -I ${in_dir} -O ${out_dir} -P checkpoint_dir qurator-gt4histocr-1.0
    """
}

workflow {
  main:
    step_1(params.input_file_grp, "OCR-D-BIN")
    step_2(step_1.out[0], "OCR-D-CROP")
    step_3(step_2.out[0], "OCR-D-BIN2")
    step_4(step_3.out[0], "OCR-D-BIN-DENOISE")
    step_5(step_4.out[0], "OCR-D-BIN-DENOISE-DESKEW")
    step_6(step_5.out[0], "OCR-D-SEG")
    step_7(step_6.out[0], "OCR-D-SEG-LINE-RESEG-DEWARP")
    step_8(step_7.out[0], "OCR-D-OCR")
}
```

Note: the provided example does not cover error handling, limiting resources for specific processes, or other useful process [directives](https://www.nextflow.io/docs/latest/process.html#directives).

## For users and developers:
Detailed instructions for local executions and example Nextflow workflow scripts can be found here: [Nextflow](https://github.com/subugoe/operandi/tree/master/ExampleWorkflows/Nextflow)

### Convert the existing OCR-D process workflows we reference to NF
You can use OtoN (OCR-D to Nextflow) converter which converts basic OCR-D process workflows to Nextflow workflow scripts. Check here: [OtoN](https://github.com/MehmedGIT/OtoN_Converter)

It is still very fresh and there are still known problems (related to the produced Nextflow scripts) and we are trying to fix them. 
It is also not convenient to use (no proper CLI and no usage instructions yet). 
Stay tuned for more updates. 

Most edge cases for the lexer/parser of the OCR-D process file have been tested while implementing. 
There may be input OCR-D process files that are not handled well enough. Feel free to report any bugs, errors, or lack of errors (when an error is expected). 

The tool will probably be a part of the OCR-D software in the future when it is stable enough for general use.

### Conventions for Nextflow scripts
Try to stick to the structure provided in section [Structure of the Nextflow script](#structure-of-the-nextflow-script) when writing Nextflow scripts. 
You can also check the Nextflow examples provided in section [Main workflow](#main-workflow). 
The naming conventions for variables, function names, process names, and workflow names are encouraged to follow the snake case.

## For developers: Nextflow implementation in OCR-D related projects
The minimally used features for local runs are the parameters, processes, process decorators, and workflows.

### Parallelization

A Nextflow workflow script contains several processes. Processes are executed independently and are isolated from each other (i.e. they do not have a shared memory space). 
Communication between the processes is possible only through data channels (similar to the pipes model in Unix). These channels are basically asynchronous FIFO queues. 
Any process can define one or more channels as input and output. 
The order of interaction between these processes, and ultimately the order of workflow execution depends on the communication channel dependencies between processes. 
For example, if process A writes data to channel A and process B reads data from channel A, then Nextflow knows that process A must be executed before process B.

TODO: We will provide more parallelization details here based on the example above.

### Interaction with the processing server
As of Aug 2022 the processing server implementation in OCR-D/core is not yet finished, cf. https://github.com/OCR-D/core/pull/884 and https://github.com/OCR-D/core/pull/652. 
The interaction will most probably happen with curl through a bash script inside the Nextflow process. 
Of course, if it is integrated inside the OCR-D core, then no direct interactions will be needed from inside the Nextflow script.

### Interaction with the METS server
As of August, 2022, the METS server implementation is still unfinished.
The interaction will most probably happen with curl through a bash script inside the Nextflow process. 
Of course, if it is integrated inside the OCR-D core, then no direct interactions will be needed from inside the Nextflow script.
