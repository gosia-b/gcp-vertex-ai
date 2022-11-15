# 🔧 simple pipeline

# Overview
This notebook is an introduction to using Vertex AI Pipelines with the Kubeflow Pipelines SDK.  
We define and compile a Vertex AI Pipeline.  
Our pipeline has 3 steps, where each step is defined as a component.

# Define pipeline components

```python
@component(output_component_file="hw.yaml", base_image="python:3.9")
def hello_world(text: str) -> str:
    print(text)
    return text
```

- The `@component` decorator compiles a function to a component when the pipeline is run.
- The `base_image` parameter specifies the container image this component will use (the default base image is `python:3.7`).
- The `output_component_file` parameter specifies the yaml file to write the compiled component to. After running the cell you should see that file written to your notebook instance. If you wanted to share this component with someone, you could send them the generated yaml file and have them load it with `dataset_component = kfp.components.load_component_from_file('./hw.yaml')`.

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
