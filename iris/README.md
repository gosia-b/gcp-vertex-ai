# 🌷 iris classification

## Model
The model is a random forest classifier imported from Scikit-learn.  
Input is petals size, e.g.

| sepal length (cm)  | sepal width (cm) | petal length (cm) | petal width (cm) |
| ------------- | ------------- | ------------- | ------------- |
| 6.8  | 3.2  | 5.7  | 2.3  |

And the output can be:
- 0 - Iris-Setosa
- 1 - Iris-Versicolour
- 2 - Iris-Virginica

## Files

`1_iris_export.ipynb`  
- train a model and export it as a .pkl file
- also: make predictions using the .pkl file

`2_iris_deploy.ipynb`  
- create a Model
- deploy model to Endpoint

`3_iris_use.ipynb`
- online predictions using Endpoint
- batch predictions
