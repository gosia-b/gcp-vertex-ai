# 🍷 wine classification

## Model
The model is a random forest classifier imported from Scikit-learn.  
The idea is to predict the quality of the wine based on its parameters like volatile acidity, residual sugar, pH, density, sulfates, alcohol.  
The target to be predicted is based on the quality grade of the wine:
- 1 = good wine (quality grade >= 7)
- 0 = bad wine (quality grade < 7)

## Pipeline
The use case is implemented using 4 pipeline *components*:
1. Data prep
2. Train
3. Evaluation
4. Deploy

Each pipeline component uses a container image available on the *Artifact Registry*.  
In this case, we use only *pre-built* Docker images ([list of pre-built containers for prediction](https://cloud.google.com/vertex-ai/docs/predictions/pre-built-containers)).

❗ Vertex Pipelines supports running pipelines built with both *Kubeflow Pipelines* or *TFX* (Tensorflow Extended).  
Here we use Kubeflow Pipelines.

## 1️⃣ component: get_wine_data
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
    df_wine["best_quality"] = [ 1 if x>=7 else 0 for x in df_wine.quality] 
    df_wine["target"] = df_wine.best_quality
    df_wine = df_wine.drop(["quality", "total sulfur dioxide", "best_quality"], axis=1)
    
    train, test = train_test_split(df_wine, test_size=0.3)
    train.to_csv(dataset_train.path + ".csv" , index=False, encoding="utf-8-sig")
    test.to_csv(dataset_test.path + ".csv" , index=False, encoding="utf-8-sig")
```

## 2️⃣ component: train_winequality

## Reference
[Article about Vertex AI Pipelines](https://towardsdatascience.com/how-to-set-up-custom-vertex-ai-pipelines-step-by-step-467487f81cad)
