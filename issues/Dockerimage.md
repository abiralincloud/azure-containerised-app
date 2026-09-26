# Troubleshooting – Container Architecture

## Problem

The first Azure Container Apps deployment failed even though the container image was successfully pushed to Azure Container Registry.

Azure reported:

> `no child with platform linux/amd64 in index`

## Cause

The Docker image was originally built on an Apple Silicon Mac.

The original image architecture was verified with:

```bash
docker image inspect skabiral-website:1.0 \
  --format '{{.Os}}/{{.Architecture}}'
Result:

linux/arm64

Azure Container Apps attempted to provision the container using:

linux/amd64

Therefore, the ARM64 image was not compatible with the Azure runtime.

Resolution
The image was rebuilt explicitly for AMD64:

docker build --platform linux/amd64 \
  -t skabiral-website:2.0 .

The architecture was then verified:

docker image inspect skabiral-website:2.0 \
  --format '{{.Os}}/{{.Architecture}}'

Result:

linux/amd64

The image was tagged and pushed to Azure Container Registry:

docker tag skabiral-website:2.0 \
  acrskabiral.azurecr.io/skabiral-website:2.0

docker push acrskabiral.azurecr.io/skabiral-website:2.0

The Container App was then updated to use:

acrskabiral.azurecr.io/skabiral-website:2.0

The application subsequently reached:

Status: Running

Lesson Learned
When building containers on Apple Silicon, always consider the target runtime architecture.

For Azure deployments, explicitly building for the target platform can avoid architecture-related deployment failures:

docker build --platform linux/amd64 ...
