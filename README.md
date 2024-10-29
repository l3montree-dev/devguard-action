# Vulnerability Scanning with DevGuard GitHub Actions Workflow

This GitHub Actions workflow allows you to integrate vulnerability management into your CI/CD pipeline using DevGuard. It simplifies the process of performing security scans, including Software Composition Analysis (SCA) and Container Scanning, ensuring that vulnerabilities are identified and mitigated early in your development process.

You can see how DevGuard works in practice [here](https://main.devguard.org/l3montree-cybersecurity/projects/devguard-pipeline/assets/devguard-pipeline), where this repository is scanned using the same components.

Read more about DevGuard and its features [here](https://github.com/l3montree-dev/devguard).

## Workflow Overview

The DevGuard workflow provides various scanning capabilities to protect your applications. You can specify the type of scan, the asset to scan, and customize parameters to fit your project requirements.

### Workflow Inputs

The reusable workflow accepts the following inputs:

| Name        | Description                                           | Required | Default Value                                |
|-------------|-------------------------------------------------------|----------|----------------------------------------------|
| `scan-type` | Type of scan to be performed (options: `full`, `sca`, `container-scanning`) | No      | `full`                                       |
| `asset-name`| Name of the asset to be scanned                      | Yes      |                                              |
| `api-url`   | URL of the DevGuard API                               | No       | `https://api.main.devguard.org`             |
| `sca-path`  | Path to the source code to be scanned                 | No       | `/github/workspace`                          |
| `image-path`| Path to the Docker image to be scanned                 | No       | `/github/workspace/image.tar`                |

### Secrets

To authenticate with the DevGuard API, the following secret is required:

| Name              | Description                          | Required |
|-------------------|--------------------------------------|----------|
| `devguard-token`  | DevGuard API token                   | Yes      |

## Jobs in the Workflow

The workflow includes the following jobs:

### Software Composition Analysis (SCA)

This job runs SCA to detect vulnerabilities in your project’s dependencies. It only executes if the `scan-type` is set to `sca` or `full`.

### Docker Image Build
This job builds your Docker image and is triggered if the `scan-type` is set to `container-scanning` or `full`.

### container-scanning
This job scans the built Docker image for vulnerabilities using the DevGuard Container-Scanning component. It only executes triggered if the `scan-type` is set to `container-scanning` or `full` and it runs after the image has been built.

### Usage Example
Here’s an example of how to call this reusable workflow from another workflow file:
name: CI/CD with DevGuard
```yaml
on:
  push

jobs:
  vulnerability-scan:
    uses: l3montree-dev/devguard-action/.github/workflows/devguard-workflow.yml@main
    with:
      asset-name: 'my-application'
    secrets:
      devguard-token: ${{ secrets.DEVGUARD_TOKEN }}
```      
