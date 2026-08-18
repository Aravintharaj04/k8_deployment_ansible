Project Overview

This project demonstrates how to automate the deployment of a Java application into Kubernetes using Terraform and Ansible.

I used Minikube as the Kubernetes cluster for this project instead of deploying to a cloud Kubernetes cluster. Terraform is used to create the Kubernetes namespace, while Ansible is used to build the Docker image, load it into Minikube, generate Kubernetes YAML files using Jinja2 templates, and deploy the application.

1. Start Minikube

First, I started the local Kubernetes cluster using Minikube.

minikube start --driver=docker

Check the cluster:

minikube status

Check Kubernetes nodes:

kubectl get nodes

The node should show as Ready.

2. Build the Java Application

The Java application is a Maven project.

From the application directory:

mvn clean package -DskipTests

This generates the JAR file inside the target directory.

Example:

target/java-app-1.0-SNAPSHOT.jar

3. Dockerfile

The Dockerfile creates an image containing the Java application.

FROM amazoncorretto:17-alpine-jdk

WORKDIR /app

COPY target/java-app-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

The JAR is copied as app.jar, so the Dockerfile does not depend on a specific Maven version number.

5. Ansible Variables

The Kubernetes and application configuration is stored in vars.yml.

namespace: java-app

image_name: java-app

image_tag: latest

container_port: 8080

service_port: 8080

The Ansible playbook loads these variables using:

vars_files:
  - vars.yml

This is important because the Jinja2 templates use variables such as container_port and service_port.


6. Ansible Deployment

The Ansible playbook performs the application deployment.

The main steps are:

Build the Docker image.
Load the Docker image into Minikube.
Generate the Deployment YAML using Jinja2.
Generate the Service YAML using Jinja2.
Apply the Deployment.
Apply the Service.
Wait until the Deployment becomes ready.