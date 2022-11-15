# 🔧 pipelines

# Why use pipelines?

Imagine you're building an ML workflow that includes processing data, training a model, hyperparameter tuning, evaluation, and model deployment. Each of these steps may have different dependencies, which may become unwieldy if you treat the entire workflow as a monolith. As you begin to scale your ML process, you might want to share your ML workflow with others on your team so they can run it and contribute code. Without a reliable, reproducible process, this can become difficult. With pipelines, each step in your ML process is its own container. This lets you develop steps independently and track the input and output from each step in a reproducible way.

TLDR: pipelines help you automate and reproduce your ML workflow.

# Reference
[Codelabs](https://codelabs.developers.google.com/vertex-mlmd-pipelines)
