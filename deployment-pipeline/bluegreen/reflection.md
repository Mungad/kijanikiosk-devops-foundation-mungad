# Reflection

## 1. Plain language versus accuracy

One part of my demo script that risked overclaiming was saying that "the system switches over without users noticing." While the deployment is designed to minimize disruption, there can still be brief delays, failed requests, or health check failures during a real deployment. A more accurate explanation would be:

> "The system prepares the new version first, checks that it is healthy, and then directs new traffic to it. This reduces downtime, but it cannot guarantee that every user will experience a completely seamless transition."

This wording remains understandable for a non-technical audience while avoiding promises that the deployment cannot always guarantee.


## 2. Highest-value post-incident action item

The highest-value action item was to automate rollback immediately when health checks fail after a deployment.

I am reasonably confident that this would prevent a similar incident because unhealthy releases would spend much less time serving users. However, I cannot be completely certain without understanding more about the production pipeline. I would need to know:

* how health checks are implemented,
* how long the monitoring system waits before declaring a deployment unhealthy,
* what conditions trigger an automatic rollback, and
* whether there are failures that health checks cannot detect.

Those implementation details determine how effective an automated rollback will actually be.


## 3. Blue/green concepts that carry into Kubernetes

Several ideas from the blue/green deployment still apply when using Kubernetes. The most important concepts are validating a new version before serving traffic, monitoring application health, maintaining a known-good version, and rolling back automatically when problems are detected. These remain valuable regardless of the deployment platform.

Other parts become unnecessary because Kubernetes manages them differently. Manual state files, custom switch scripts, and rollback scripts are replaced by Kubernetes controllers, Deployments, ReplicaSets, readiness probes, and rolling update mechanisms. Kubernetes continuously watches the desired state and automatically recreates failed Pods, reducing the amount of custom deployment logic that must be maintained.


## 4. Hardcoded values that should become configuration

Several values in the deployment manifest are currently hardcoded and should be moved into ConfigMaps or Secrets in a future iteration.

| Hardcoded value                                | Better configuration                            | Operational problem                                                                            |
| ---------------------------------------------- | ----------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Docker image tag (1.3.0-d4db9b0)               | Deployment configuration                        | Every release requires editing the manifest manually.                                          |
| Container port (3000)                          | ConfigMap                                       | Port changes require modifying and redeploying manifests.                                      |
| Service port (3001)                            | ConfigMap                                       | Different environments may require different exposed ports.                                    |
| NodePort (30001)                               | ConfigMap or environment-specific manifest      | The fixed port may conflict with other services.                                               |
| Resource requests and limits                   | ConfigMap or environment-specific configuration | Development and production environments often require different resource allocations.          |
| Replica count (2)                              | ConfigMap                                       | Scaling requires editing deployment files instead of changing configuration.                   |
| Registry address (host.minikube.internal:8082) | ConfigMap                                       | The registry location changes between local development, testing, and production environments. |
| Registry credentials                           | Secret                                          | Credentials must never be stored directly in manifests because they are sensitive information. |

Moving these values into ConfigMaps and Secrets would make deployments easier to maintain across environments while improving security and reducing manual changes for each release.
