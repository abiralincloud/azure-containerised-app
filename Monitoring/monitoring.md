# Monitoring – Azure Container Apps

## Monitoring Setup

The Container App is connected to an Azure Log Analytics workspace through the Container Apps environment.

- Container App: `ca-skabiral-website`
- Environment: `cae-container-platform`
- Log Analytics: `workspacergcontainerplatform934c`
- Log stream: Enabled
- Persistent logs: Available through Log Analytics

## Log Stream Validation

The Container App Log Stream was used to verify that the NGINX container started successfully and was serving HTTP requests.

Example successful request:

```text
GET / HTTP/1.1 200

HTTP 304 responses were also observed, indicating browser caching.

Troubleshooting Observed
NGINX reported 404 responses for:

/favicon.ico
/apple-touch-icon.png
/apple-touch-icon-precomposed.png

These files are not included in the current static website image. The Container App itself remained healthy and continued serving the main / page successfully.

KQL Investigation
Container logs were queried using Log Analytics:

ContainerAppConsoleLogs_CL
| where ContainerAppName_s == "ca-skabiral-website"
| order by TimeGenerated desc
| take 20

A summary query was also used to inspect the distribution of log entries:

ContainerAppConsoleLogs_CL
| where ContainerAppName_s == "ca-skabiral-website"
| summarize Count = count() by Log_s
| order by Count desc
