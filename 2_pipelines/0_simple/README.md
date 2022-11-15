# 🔧 simple pipeline

# Vertex AI Pipelines
Compared to other cloud providers, Google has made a decision not to develop product-specific pipelines (such as AWS Sagemaker) but to instead rely on the open source technologies. So two formats are supported:
- Kubeflow Pipelines (KFP)
- Tensor Flow Extended (TFX)

# This notebook
This notebook is an introduction to using Vertex AI Pipelines with the Kubeflow Pipelines SDK.  
We define and compile a Vertex AI Pipeline.  
Our pipeline has 3 steps, where each step is defined as a component.

# Define pipeline components

Each component is defined using a `@component` decorator which compiles the function to a KFP component when evaluated.  
We can specify a base image to use for the component (the default base image is `python:3.7`)  
We can specify a component YAML file - the compiled component specification is written to this file.  

```python
@component(output_component_file="hw.yaml", base_image="python:3.9")
def hello_world(text: str) -> str:
    print(text)
    return text
```

We can provide a list of packages to install before executing the component:
```python
@component(packages_to_install=["google-cloud-storage"])
```

All arguments are optional so you can use the decorator without any arguments:
```python
@component
def ...
```

# Define the pipeline
By evaluating the components definitions above, you've created *task factory functions* that are used in the pipeline definition to create the pipeline steps.  
This pipeline takes an *input parameter* and passes it as an argument to the first 2 pipeline steps (`hw_task` and `two_outputs_task`).  
The third pipeline step (`consumer_task`) consumes the outputs of those 2 steps.
```python
@dsl.pipeline(
    name="hello-world-pipeline",
    description="A simple pipeline",
    pipeline_root=PIPELINE_ROOT
)
def pipeline(text: str = "hi there"):
    hw_task = hello_world(text)
    two_outputs_task = two_outputs(text)
    consumer_task = cosumer(
        hw_task.output,
        two_outputs_task.outputs["output_one"],
        two_outputs_task.outputs["output_two"]
    )
```

# Compile the pipeline
```python
compiler.Compiler().compile(pipeline_func=pipeline, package_path="simple_pipeline.json")
```

# Run the pipeline
```python
job = aip.PipelineJob(
    display_name=PIPELINE_DISPLAY_NAME,
    template_path="simple_pipeline.json",
    pipeline_root=PIPELINE_ROOT,
    location=REGION
)

job.run(service_account=SERVICE_ACCOUNT)
```
Click on the generated link to see your run in the Cloud Console.  


<img src="https://raw.githubusercontent.com/gosia-b/gcp-vertex-ai/master/2_pipeline/pipeline.png">

# Reference
[Notebook](https://github.com/GoogleCloudPlatform/vertex-ai-samples/blob/main/notebooks/official/pipelines/pipelines_intro_kfp.ipynb)  
[Kubeflow Pipelines SDK](https://www.kubeflow.org/docs/components/pipelines/)
