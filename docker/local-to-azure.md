Local Docker to Azure
Original Application

The project started with an existing static HTML website.

The website was containerized locally using Docker and served by NGINX.

The resulting image was:

skabiral-website:1.0

Local Docker Architecture
Website source
     │
     ▼
Dockerfile
     │
     │ docker build
     ▼
Docker image
skabiral-website:1.0
     │
     │ docker run
     ▼
Docker container
     │
     ▼
localhost:8081

NGINX Container

The website uses NGINX as the container web server.

The container listens on port 80.

The local Docker port mapping was:

localhost:8081 → container:80


This allowed the website to be tested locally before deploying it to Azure.

Azure Image Tag

The existing image was given an additional Azure Container Registry tag:

docker tag skabiral-website:1.0 \
  acrskabiral.azurecr.io/skabiral-website:1.0


This did not create a new image. Both tags referenced the same underlying Docker image.

Push to Azure Container Registry

After authenticating Docker with ACR:

az acr login --name acrskabiral


the image was pushed to Azure:

docker push acrskabiral.azurecr.io/skabiral-website:1.0


The image was then verified using:

az acr repository list \
  --name acrskabiral \
  --output table


and:

az acr repository show-tags \
  --name acrskabiral \
  --repository skabiral-website \
  --output table


The resulting repository and tag were:

Repository: skabiral-website
Tag:        1.0

Key Concept

The workflow separates the application image from the runtime:

ACR
 │
 │ stores
 ▼
Container Image
 │
 │ deployed to
 ▼
Azure Container Apps
 │
 │ runs
 ▼
Application


ACR is the image registry.

Container Apps is the application runtime.
