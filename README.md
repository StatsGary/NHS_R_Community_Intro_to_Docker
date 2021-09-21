# Introduction to Docker and API deployment

![](man/figures/DockerNHSR.png)

This is a tutorial on how to use `Docker desktop` to deploy a trained machine learning model. There are many other use cases for Docker i.e. deployment of Shiny apps to docker containers, website deployment, web service deployment, database deployment or full scale application deployment. 

The session was part of the [NHS-R communities' workshop](https://nhsrcommunity.com/events/nhs-r-community-show-and-tell-r-in-production/). 

My tutorial will focus on the following:

* Introduction to Docker
* Docker Desktop 
* Training ML Model, Serialise ML model and deploy to Docker container
* Creating a Dockerfile and the Plumber API end points
* Use CMD to interact with the service (Windows focus)
* Expose Swagger APU and use R to connect to API and send predictions to the trained ML model
* Interface with our API using httr and JSONlite

## Links to the tutorial content

The following links send you straight to the content:

* [Presentation from the day](https://github.com/StatsGary/NHS_R_Community_Intro_to_Docker/blob/main/Docker_NHSRCommunity/NHS_R_Community_Docker_Presentation.pdf)
* [ML Model training script](https://github.com/StatsGary/NHS_R_Community_Intro_to_Docker/blob/main/Docker_NHSRCommunity/MLModelTrainingScript.R) - this trains a model in caret and serialises it to the model folder in the Rocker_Deployment_R folder
* [Rocker Deployment Folder](https://github.com/StatsGary/NHS_R_Community_Intro_to_Docker/tree/main/Docker_NHSRCommunity/Rocker_Deployment_R) - this contains all the code needed to create the Docker image such as our [PlumbeR end point](https://github.com/StatsGary/NHS_R_Community_Intro_to_Docker/blob/main/Docker_NHSRCommunity/Rocker_Deployment_R/PlumbStranded.R) scripts, our GET and POST functions in [StrandedPlumberAPIHC.R](https://github.com/StatsGary/NHS_R_Community_Intro_to_Docker/blob/main/Docker_NHSRCommunity/Rocker_Deployment_R/StrandedPlumberAPIHC.R), the [Open API YAML file](https://github.com/StatsGary/NHS_R_Community_Intro_to_Docker/blob/main/Docker_NHSRCommunity/Rocker_Deployment_R/openapi.yaml) needed for setting up the structure of the [Swagger endpoint](http://127.0.0.1/__docs__/), the serialised model (tb_model.rds) and the most important Dockerfile.


