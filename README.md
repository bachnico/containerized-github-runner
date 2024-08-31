# Simple Containerized GitHub Runner
**Simple Containerized GitHub Runner** is a project designed to facilitate running a GitHub Actions runner within a Docker container using GitHub's official [`actions/runner`](https://github.com/actions/runner) image. By containerizing the runner, this project ensures that your GitHub runner is isolated from the underlying system, providing a more controlled and consistent environment. This is especially useful for running runners in shared environments or personal computers, where you may want to avoid interference with your system, processes or files.

## Benefits of a Containerized GitHub Runner

- **Isolation**: The runner operates in a separate environment from your host system, reducing the risk of conflicts and ensuring that the build environment remains consistent across different runs.
- **Simplicity**: Containerizing the GitHub runner simplifies the setup process. With just a few input parameters, such as TOKEN and URL, you can quickly get up and running. There’s no need to configure complex environments or dependencies — just provide these essential details, and you're ready to go.
- **Shared Environment**: Ideal for use on personal computers or shared systems where you want to keep the runner's operations isolated from other users or processes on the host.

## Setup

### Step 1: Build the Docker Image

First, you need to build the Docker image for the GitHub runner. Run the following command to build the image and tag it as `containered-github-runner`:

```bash
docker build -t containered-github-runner .
```

### Step 2: Run the Container

Once the image is built, you can run the container. The following command starts the container and registers the GitHub runner:

```bash
docker run -d --restart unless-stopped -e URL={{URL}} -e TOKEN={{TOKEN}} -e NAME={{name}} -e LABELS={{labels}} containered-github-runner
```

- **`-d`**: Runs the container in detached mode, so it runs in the background.
- **`--restart unless-stopped`**: Ensures the container automatically restarts if it stops or if the Docker daemon restarts.

#### Parameters

- **`URL`**: The URL of your GitHub repository or organization where the runner should be registered. You can get this URL from the *GitHub Actions runner setup page*.
- **`TOKEN`**: The registration token from GitHub, required to authenticate the runner. This token is also available on the *GitHub Actions runner setup page*.
- **`NAME`** (optional): A custom name for your runner. If not provided, GitHub assigns a default name.
- **`LABELS`** (optional): Custom labels for your runner. These labels help you organize and target specific runners for certain jobs. If not provided, GitHub assigns a some default labels.

All these options are passed to the `config.sh` script provided by GitHub for runner registration.

## ⚠️ Caution: Security Considerations

While containerizing the GitHub runner offers significant isolation, there are still some security risks to consider:

### Container
**Access to the Host System**: Containers share the kernel with the host system, so a malicious actor who gains control of the container could potentially exploit vulnerabilities to affect the host. Also Self-hosted runners have direct access to the system they are running on. If an attacker gains control of a runner, they could potentially exploit vulnerabilities to access or manipulate the containered system, possibly leading to security breaches.
  
**Network Isolation**: By default, containers have an isolated network environment, which limits the runner’s ability to communicate with other services on your network or the internet. However, if network access is granted, this may pose security risks as the container could potentially interact with external systems or be exposed to network-based threats.

In shared environments, be mindful of these risks and consider additional security measures, such as limiting resource usage, using network policies, or running containers with restricted privileges.

### Self-hosted Runners
Using self-hosted GitHub Actions runners introduces several security risks that need to be carefully managed:  
Unlike GitHub-hosted runners, which provide a clean instance for every job execution ([GitHub Documentation](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#differences-between-github-hosted-and-self-hosted-runners)), self-hosted runners **do not automatically ensure a fresh environment for each job**. This means that temporary files, environment variables, or other artifacts from previous jobs may persist. 
This could lead to the unintended retention of **sensitive information or other residual data** that might pose security risks. For more information on the security implications of persisting unwanted or dangerous data, see [GitHub's Self-Hosted Runner Security Documentation](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#self-hosted-runner-security).
