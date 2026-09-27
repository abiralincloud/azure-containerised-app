Azure Containerized Application Platform
Azure Container Apps • Azure Container Registry • RBAC • Managed Identity • Azure Monitor • Log Analytics • Docker

A hands-on Azure project demonstrating how to take a simple static website, containerize it with Docker, publish the image to Azure Container Registry (ACR), and deploy it as a production-style workload using Azure Container Apps.

The project deliberately includes real deployment troubleshooting, identity-based authentication, RBAC, monitoring, and infrastructure discovery rather than stopping at a basic "Hello World" deployment.

----------------------------

Architecture
Architecture Topology

The following diagram represents the deployed Azure container platform and the flow between the application, container registry, identity, RBAC and monitoring services.


flowchart TD

    A["👤 User / Internet"]

    subgraph AZURE["☁️ Microsoft Azure"]
        
        subgraph RG["📦 Resource Group<br/>rg-container-platform"]

            subgraph REGISTRY["📦 Azure Container Registry"]
                ACR["🔐 acrskabiral.azurecr.io"]
                IMAGE["🐳 skabiral-website:2.0<br/>Linux / AMD64"]
                ACR --> IMAGE
            end

            subgraph ENV["☁️ Azure Container Apps Environment"]
                CAE["cae-container-platform"]

                subgraph APP["🚀 Azure Container App"]
                    APPNAME["ca-skabiral-website"]
                    NGINX["NGINX<br/>Container :80"]
                    INGRESS["🌐 HTTP / HTTPS Ingress"]
                    
                    APPNAME --> NGINX
                    NGINX --> INGRESS
                end

                CAE --> APP
            end

            subgraph IDENTITY["🔐 Identity & Access"]
                MI["System-Assigned<br/>Managed Identity"]
                RBAC["Azure RBAC<br/>AcrPull"]
                
                MI --> RBAC
            end

            subgraph MONITOR["📊 Monitoring"]
                LAW["Azure Log Analytics<br/>Workspace"]
                LOGS["Container Logs"]
                KQL["KQL Queries"]
                
                LAW --> LOGS
                LOGS --> KQL
            end

        end
    end

    A --> INGRESS

    IMAGE -->|"Container image pull"| APPNAME

    APPNAME -->|"Uses"| MI
    RBAC -->|"Read image"| ACR

    APPNAME -->|"Logs"| LAW

    style A fill:#0078D4,color:#fff,stroke:#005A9E,stroke-width:2px

    style RG fill:#F3F6FA,stroke:#0078D4,stroke-width:2px

    style REGISTRY fill:#FFF4CE,stroke:#FFB900,stroke-width:2px
    style ACR fill:#FFF4CE,stroke:#FFB900
    style IMAGE fill:#FFF4CE,stroke:#FFB900

    style ENV fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px
    style CAE fill:#E8F5E9,stroke:#2E7D32
    style APP fill:#E8F5E9,stroke:#2E7D32
    style APPNAME fill:#E8F5E9,stroke:#2E7D32
    style NGINX fill:#E8F5E9,stroke:#2E7D32
    style INGRESS fill:#E8F5E9,stroke:#2E7D32

    style IDENTITY fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    style MI fill:#FCE4EC,stroke:#C2185B
    style RBAC fill:#FCE4EC,stroke:#C2185B

    style MONITOR fill:#E3F2FD,stroke:#1565C0,stroke-width:2px
    style LAW fill:#E3F2FD,stroke:#1565C0
    style LOGS fill:#E3F2FD,stroke:#1565C0
    style KQL fill:#E3F2FD,stroke:#1565C0


---------------------------------------

Identity & Access Flow

-----------------------------


Container App
      │
      ▼
System-Assigned Managed Identity
      │
      │ Azure RBAC
      │ AcrPull
      ▼
Azure Container Registry
      │
      ▼
skabiral-website:2.0


-------------------------------

Project Objectives
This project was built as a practical AZ-104 learning environment with an emphasis on skills that translate to real Azure administration and cloud engineering work.

Core objectives
Containerize a static web application using Docker

Understand Docker images, containers, tags and registries

Create and configure Azure Container Registry

Push a container image from a local development environment into Azure

Deploy the container using Azure Container Apps

Configure HTTP ingress

Understand Azure Container Apps environments

Implement Managed Identity

Configure Azure RBAC using AcrPull

Troubleshoot container architecture compatibility

Implement Azure Monitor / Log Analytics

Query container logs using KQL

Understand Container Apps revisions

Build repeatable Azure discovery/documentation tooling

Maintain the project as a GitHub portfolio repository


Build -- 

HTML
 │
 ▼
Dockerfile
 │
 ▼
Docker Image
 │
 ▼
Local Docker Container
 │
 ▼
Azure Container Registry
 │
 ▼
Azure Container Apps
 │
 ▼
Public HTTPS Application


--------------

Azure Container Apps
        │
        └── ca-skabiral-website
                │
                ├── NGINX
                ├── Linux / AMD64
                ├── HTTP Ingress
                └── Managed Identity


-----------------

Containerization
The original website was packaged using NGINX.

The Docker image copies the static website into the NGINX web root:

FROM nginx:latest

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

The image was initially tested locally before being deployed to Azure.

This provided a useful separation between:

Application code

Container image

Container runtime

Azure infrastructure


-----------


Azure Container Registry
The container image is stored in:

acrskabiral.azurecr.io

Repository:

skabiral-website

Version:

2.0

The registry provides a private Azure-hosted location for container artifacts before they are consumed by the Container App.

Example CLI discovery:

az acr repository list \
  --name acrskabiral \
  --output table

az acr repository show-tags \
  --name acrskabiral \
  --repository skabiral-website \
  --output table


  --------------


  Azure Container Apps
The application is deployed using:

Container Apps Environment
cae-container-platform

Container App
ca-skabiral-website

The workload uses the Consumption profile and exposes the application through HTTP ingress.

Container configuration:

CPU:        0.5 vCPU
Memory:     1 GiB
Port:       80
Protocol:   HTTP
Platform:   Linux/AMD64

The application is publicly accessible through the Azure Container Apps HTTPS endpoint.

----------------------

RBAC & Managed Identity
One of the key objectives was to avoid using registry administrator credentials for application authentication.

A system-assigned managed identity was enabled on the Container App.

The identity was then granted:

Role:  AcrPull
Scope: acrskabiral

This implements a least-privilege access pattern:

Container App
      │
      ▼
Managed Identity
      │
      ▼
AcrPull
      │
      ▼
Specific ACR

The assignment was verified using Azure CLI:

az role assignment list \
  --scope $(az acr show --name acrskabiral --query id -o tsv) \
  --role AcrPull \
  --assignee $(az containerapp identity show \
    --name ca-skabiral-website \
    --resource-group rg-container-platform \
    --query principalId -o tsv) \
  --output table

This confirmed that the Container App identity had AcrPull permission scoped specifically to the registry.



---------------


Monitoring & Observability
The Container Apps environment is integrated with Azure Log Analytics.

Monitoring was validated through:

Container App Log Stream
The live log stream confirmed:

NGINX startup

Worker processes

HTTP requests

Successful 200 responses

Cached 304 responses

404 requests for missing browser icon assets

Example:

GET / HTTP/1.1 200

and:

GET / HTTP/1.1 304

Log Analytics + KQL
Container logs were queried using:

ContainerAppConsoleLogs_CL
| where ContainerAppName_s == "ca-skabiral-website"
| order by TimeGenerated desc
| take 20

This demonstrates the basic Azure monitoring workflow:

Application
    │
    ▼
Container stdout/stderr
    │
    ▼
Azure Monitor
    │
    ▼
Log Analytics
    │
    ▼
KQL
    │
    ▼
Troubleshooting / Analysis

----------------

Azure Architecture Discovery
The repository includes a discovery script designed to inspect the deployed Azure environment.

architecture/
└── discover.sh

The script uses Azure CLI to discover:

Resource group resources

Container Registry

Container repositories

Container App

Container App URL

Container Apps environment

Managed Identity

RBAC assignments

Log Analytics workspace

The goal is to make infrastructure documentation reproducible rather than manually maintained.

Run:

./architecture/discover.sh

The output can be captured into:

./architecture/discover.sh > architecture/architecture.md

This creates a lightweight infrastructure inventory that can be refreshed as the Azure environment changes.



------------

Repository Structure
Azure-Containerised-App/
│
├── architecture/
│   ├── discover.sh
│   ├── architecture.md
│   └── exported-template.json
│
├── docker/
│   ├── local-to-azure.md
│   ├── rbac.md
│   ├── monitoring.md
│   └── troubleshooting.md
│
├── Dockerfile
├── index.html
├── README.md
└── Screenshot...

----------------------------------------

CLI Commands
Azure login
az login

Select subscription
az account set --subscription "Azure subscription 1"

List resources
az resource list \
  --resource-group rg-container-platform \
  --output table

List ACR repositories
az acr repository list \
  --name acrskabiral \
  --output table

Inspect Container App
az containerapp show \
  --name ca-skabiral-website \
  --resource-group rg-container-platform

Inspect identity
az containerapp identity show \
  --name ca-skabiral-website \
  --resource-group rg-container-platform

Check RBAC
az role assignment list \
  --scope $(az acr show --name acrskabiral --query id -o tsv) \
  --role AcrPull \
  --output table

  -----------------------

Real-World Relevance
Although the application is intentionally simple, the architecture represents patterns used in larger cloud environments:

Containerized workloads
Applications can be packaged consistently as container images and promoted between environments.

Private image registry
ACR provides a centralized repository for application artifacts.

Identity-based authentication
Managed identities remove the need to distribute long-lived credentials to workloads.

Least-privilege access
RBAC limits what an application can access and where that access applies.

Managed application platform
Container Apps abstracts much of the underlying infrastructure while providing container deployment, ingress, revisions, scaling and monitoring capabilities.

Observability
Application logs can be centralized and queried through Azure Monitor and Log Analytics.

Infrastructure documentation
Azure CLI discovery makes the deployed environment easier to inspect, reproduce and document.

 Learning Outcome
This project demonstrates more than simply deploying a website.

It provides hands-on experience with the lifecycle of a containerized Azure workload:

Build
  ↓
Package
  ↓
Test
  ↓
Registry
  ↓
Deploy
  ↓
Authenticate
  ↓
Monitor
  ↓
Troubleshoot
  ↓
Document

The result is a small but realistic Azure platform that can be extended 



----------------
-------------------

Deployment Result
The final application was successfully deployed to Azure Container Apps and verified through:

Public HTTPS access

Container logs

NGINX request logs

Log Analytics

Azure RBAC

Managed Identity

Azure Container Registry