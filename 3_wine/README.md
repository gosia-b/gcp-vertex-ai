# 🍷 wine classification

## Model
The model is a random forest classifier imported from Scikit-learn.  
The idea is to predict the quality of the wine based on its parameters like volatile acidity, residual sugar, pH, density, sulfates, alcohol.  
The target to be predicted is based on the quality grade of the wine:
- 1 = good wine (quality grade >= 7)
- 0 = bad wine (quality grade < 7)

## Pipeline
The use case is implemented using 4 pipeline *components*:
1. Load data
2. Train model
3. Evaluate model
4. Deploy model

Each pipeline component uses a container image available on the *Artifact Registry*.  
In this case, we use only *pre-built* Docker images ([list of pre-built containers for prediction](https://cloud.google.com/vertex-ai/docs/predictions/pre-built-containers)).

❗ Vertex Pipelines supports running pipelines built with both *Kubeflow Pipelines* or *TFX* (Tensorflow Extended).  
Here we use Kubeflow Pipelines.

## 1️⃣ Load data
The first component is `get_wine_data`.  
It uses a pre-built Python 3.9 base image in which we additionally add pandas, sklearn, and pyarrow.

The logic is simple: we read the [wine quality dataset](https://archive.ics.uci.edu/ml/datasets/wine+quality), we choose the `best_quality` as a label, and we split the data into train and test datasets.

The configuration of the component is stored in a `.yaml` file called get_wine_data.yaml that you can later use to run the component without rewriting the code. The yaml file is very useful to generate component templates.

```python
@component(
    packages_to_install=["pandas", "pyarrow",  "sklearn"],
    base_image="python:3.9",
    output_component_file="get_wine_data.yaml"
)

def get_wine_data(
    url: str,
    dataset_train: Output[Dataset],
    dataset_test: Output[Dataset]
):
    import pandas as pd
    import numpy as np
    from sklearn.model_selection import train_test_split
    
    df_wine = pd.read_csv(url, delimiter=";")
    ...
    train.to_csv(dataset_train.path + ".csv" , index=False, encoding="utf-8-sig")
    test.to_csv(dataset_test.path + ".csv" , index=False, encoding="utf-8-sig")
```

## 2️⃣ Train model

## Reference
[Article about Vertex AI Pipelines](https://towardsdatascience.com/how-to-set-up-custom-vertex-ai-pipelines-step-by-step-467487f81cad)
