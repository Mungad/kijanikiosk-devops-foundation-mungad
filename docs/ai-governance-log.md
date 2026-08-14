# AI Governance Log

## Entry 1 — Capstone Infrastructure and Runtime Design

**1. Date**  
2026-08-14

**2. Tool used**  
ChatGPT

**3. Task description**  
Review and assist with the design and implementation of the KijaniKiosk Track A capstone infrastructure and staging runtime. The goal was to provision an isolated Kubernetes staging namespace with Terraform, configure its environment-specific settings with Ansible, and deploy the `kk-payments` service with Kubernetes.

**4. What was provided to the AI**  
The existing KijaniKiosk repository structure, Track A scope document, architecture requirements, existing Week 4 Terraform and Ansible implementation, Week 9 Kubernetes manifests, `kk-payments` application configuration, and terminal output from Terraform, Ansible, and Kubernetes validation commands.

**5. What the AI produced**  
The AI provided implementation guidance for separating the capstone into infrastructure, configuration, and runtime layers. It recommended using Terraform to create the `kijani-staging` namespace, Ansible to configure the staging ConfigMap, and Kubernetes manifests to deploy `kk-payments` with health probes, resource limits, and a ClusterIP Service. It also recommended validating the seams between these components with rollout and smoke tests.

**6. What it got right**  
- Terraform successfully created the isolated `kijani-staging` namespace.
- Ansible successfully verified the Terraform-created namespace before configuring it.
- The staging ConfigMap contains environment-specific values, including `NODE_ENV=staging` and a staging-specific `DB_HOST`.
- The Kubernetes Deployment uses readiness and liveness probes.
- The deployment uses resource requests and limits.
- The Kubernetes rollout completed with 2/2 replicas available.
- The smoke test successfully returned a healthy response from `kk-payments`.

**7. What it got wrong**  
The initial infrastructure guidance assumed the Kubernetes API would be reachable without first verifying that the local Minikube control plane was running. Terraform and `kubectl` initially failed with `no route to host` because the Minikube host, kubelet, and API server were stopped. The guidance also initially treated the Ansible environment as if the required Python Kubernetes library were already available, but Ansible failed until the correct Python virtual environment and Kubernetes library were used.

**8. What was changed before applying the output**  
Minikube status was checked and the cluster was started before Terraform was run again. The Ansible environment was isolated in a Python virtual environment and configured with the required Kubernetes Python library. The Ansible callback configuration was also corrected after the installed Ansible version rejected the removed `community.general.yaml` callback. The implementation was then validated independently using `terraform validate`, `terraform apply`, `ansible-playbook`, `kubectl rollout status`, and an in-cluster HTTP smoke test.
