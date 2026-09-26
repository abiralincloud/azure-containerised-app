Architecture
Overview

This project demonstrates a simple containerized application platform on Microsoft Azure.

An existing Dockerized static website is stored in Azure Container Registry and deployed to Azure Container Apps.

Architecture Diagram
                    Internet
                       │
                       │ HTTPS
                       ▼
              ┌───────────────────┐
              │  Azure Container   │
              │       Apps         │
              │                    │
              │  ca-skabiral-      │
              │     website        │
              └─────────┬─────────┘
                        │
                        │ Pull image
                        ▼
              ┌───────────────────┐
              │ Azure Container    │
              │     Registry       │
              │                    │
              │ skabiral-website   │
              │       :1.0         │
              └───────────────────┘

              Container App Environment
              └── cae-container-platform

              Monitoring
              └── Log Analytics Workspace

Resource Group

All resources for this learning project are contained in:

rg-container-platform

This provides a logical management boundary for the platform resources.

Azure Container Registry

ACR stores the application container image:

acrskabiral.azurecr.io/skabiral-website:1.0


ACR is the image repository. It does not run the application.

Azure Container Apps

Azure Container Apps provides the managed runtime for the container.

The application is configured with:

Consumption workload profile

External ingress

HTTP transport

Container target port 80

Container Apps Environment

The Container App runs within:

cae-container-platform

The environment provides the shared runtime boundary for Container Apps workloads.

Monitoring

The environment uses an Azure Log Analytics workspace for application and platform logging.

Security

The project will explore managed identity and Azure RBAC so that the application can access ACR without relying on hard-coded registry credentials.
