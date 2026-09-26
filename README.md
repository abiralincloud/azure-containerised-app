📦 Azure Containerized Application Platform

A hands-on Azure administration project using an existing Dockerized website to explore Azure Container Registry (ACR) and Azure Container Apps.

🎯 Project Goal

Deploy an existing containerized website from a local Docker environment into Azure.

The project follows this path:

HTML Website
     ↓
Docker Image
     ↓
Azure Container Registry (ACR)
     ↓
Azure Container Apps
     ↓
Public HTTPS Application

Azure Services

Azure Resource Group

Azure Container Registry

Azure Container Apps

Container Apps Environment

Log Analytics

Azure Monitor

Microsoft Entra ID / Managed Identity

Azure RBAC

Current Status

 Create Azure Resource Group

 Create Azure Container Registry

 Build and test Docker image locally

 Push Docker image to ACR

 Create Container Apps Environment

 Deploy Container App

 Verify public application

 Configure and test managed identity / RBAC

 Explore revisions

 Explore scaling

 Explore monitoring and logs

 Reproduce deployment using Azure CLI

 Document troubleshooting scenarios

Resource Topology
rg-container-platform
│
├── acrskabiral
│   └── skabiral-website:1.0
│
├── cae-container-platform
│   └── ca-skabiral-website
│
└── Log Analytics Workspace

Learning Objectives

This project is focused on practical AZ-104 administration skills, including:

Managing Azure resources and resource groups

Working with Azure Container Registry

Managing container images and tags

Deploying containerized workloads

Configuring application ingress

Understanding managed identities

Applying Azure RBAC

Monitoring container workloads

Troubleshooting deployments

Using Azure Portal and Azure CLI

Documenting Azure infrastructure

Environment
Component	Value
Region	Australia East
Resource Group	rg-container-platform
Container Registry	acrskabiral
Container Image	skabiral-website:1.0
Container Apps Environment	cae-container-platform
Container App	ca-skabiral-website
Workload Profile	Consumption
Container Port	80
Ingress	External HTTP/HTTPS

No credentials, secrets, subscription IDs, or other sensitive information should be committed to this repository.
