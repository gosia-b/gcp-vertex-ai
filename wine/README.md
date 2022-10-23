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

## Reference
[Article about Vertex AI Pipelines](https://towardsdatascience.com/how-to-set-up-custom-vertex-ai-pipelines-step-by-step-467487f81cad)
