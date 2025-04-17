# Vulnerability Scanning with DevGuard GitHub Actions Workflow

This GitHub Actions workflow allows you to integrate vulnerability management into your CI/CD pipeline using DevGuard. It simplifies the process of performing security scans, including Software Composition Analysis (SCA) and Container Scanning, ensuring that vulnerabilities are identified and mitigated early in your development process.

You can see how DevGuard works in practice [here](https://main.devguard.org/l3montree-cybersecurity/projects/devguard-pipeline/assets/devguard-pipeline), where this repository is scanned using the same components.

Read more about DevGuard and its features [here](https://github.com/l3montree-dev/devguard).

## Workflows Overview

The DevGuard workflow automates the process of ensuring security, quality, and efficiency throughout the development and deployment pipeline. It integrates various security and build-related tasks to enhance the integrity of your code and container images before deployment. Below is a breakdown of the individual jobs included in the workflow:


## Jobs in the Workflow

The workflow includes the following jobs:


### secret-scanning
The `secret-scanning` workflow is designed to identify sensitive information such as API keys, passwords, and other secrets within your codebase. By integrating secret scanning into your CI/CD pipeline, developers can proactively prevent the accidental exposure of confidential data, enhancing the overall security posture of the application.


### sast
The `sast` component focuses on Static Application Security Testing (SAST) to analyze your source code for vulnerabilities without executing it. This component helps in identifying security flaws early in the development cycle, ensuring that code quality and security are prioritized before deployment.


### software composition analysis (SCA)

The `software-composition-analysis` workflow performs Software Composition Analysis (SCA) to detect vulnerabilities in your project’s dependencies. It scans your software for outdated or vulnerable third-party libraries, helping you manage risks early in the development process.


### build image
This workflow uses Kaniko to build and archive a Docker image. The image tag is created based on user inputs, Git tags, or commit information. The image is built, saved as a `.tar` file, and the digest is retrieved using crane. Finally, the image, tag, and digest are uploaded as artifacts. To use this component, you need to have a `Dockerfile` in your repository's root directory.



### container-scanning
The `container-scanning` component scans your container images for vulnerabilities. This ensures that your Docker images do not contain known vulnerabilities before they are deployed. 


### deploy

The devguard-deploy component deploys the created OCI (Open Container Initiative) image to the GitLab container registry. This ensures that your images are securely stored and ready for deployment in your infrastructure.
The `deploy` workflow can only be executed if the following prerequisites run successfully: build-image, container-scanning, software-composition-analysis, sast, and secret-scanning.


## Full DevGuard Scan

You can run all the previous jobs by calling the Full DevGuard Scan workflow.

### Full DevGuard Scan Workflow Inputs

The reusable workflow accepts the following inputs:

| Name                   | Description                                                                   | Required    | Default Value                                    | Workflows Using This Input                               |
|------------------------|--------------------------------------------------------------------------------------|-------------|-------------------------------------------------|----------------------------------------------------------|
| `asset-name`            | Name of the asset to be scanned                                               | Yes         |                                                 | SCA, Container Scanning                                              |
| `api-url`               | URL of the DevGuard API                                                       | No          | `https://api.main.devguard.org`                 |             SCA, Container Scanning                          |
| `path`              | Path to the source code to be scanned                                         | No          | `.`                                              | SCA                                           |
| `image-destination-path`| Path to the OCI image to be scanned. Only necessary if the reusable workflow is not used for further processing of the built image.tar | No          | `image.tar`                                      | Build-image        |
| `image`                 | OCI image tag                                                                  | No          |                                                 |  Build-image                           |
| `context`               | Path to the OCI context                                                       | No          | `.`                                              | Build-image          |
| `dockerfile`            | Path to the Dockerfile                                                        | No          | `Dockerfile`                                     |  Build-image                            |
| `should-deploy`         | Whether the deploy job should run, publishing the image to the desired Container Registry | No          | `true`                                           |  deploy            |



### Secrets

To authenticate with the DevGuard API, the following secret is required:

| Name              | Description                          | Required |
|-------------------|--------------------------------------|----------|
| `devguard-token`  | DevGuard API token                   | Yes      |




### Usage Example
Here’s an example of how to call this reusable workflow from another workflow file:

```yaml
on:
  push

jobs:
  vulnerability-scan:
    uses: l3montree-dev/devguard-action/.github/workflows/full.yml@main
    with:
      asset-name: 'my-application'
    secrets:
      devguard-token: ${{ secrets.DEVGUARD_TOKEN }}
```      
