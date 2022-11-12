# 🔧 pipeline

# Vertex AI Pipelines
Compared to other cloud providers, Google has made a decision not to develop product-specific pipelines (such as AWS Sagemaker) but to instead rely on the open source technologies. So two formats are supported:
- Kubeflow Pipelines (KFP)
- Tensor Flow Extended (TFX)

# This notebook
This notebook is an introduction to using Vertex AI Pipelines with the Kubeflow Pipelines SDK.  
We define and compile a Vertex AI Pipeline.  
Our pipeline has 3 steps, where each step is defined as a component.

# Pipeline components

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

# Reference
[Notebook](https://github.com/GoogleCloudPlatform/vertex-ai-samples/blob/main/notebooks/official/pipelines/pipelines_intro_kfp.ipynb)  
[Kubeflow Pipelines SDK](https://www.kubeflow.org/docs/components/pipelines/)
