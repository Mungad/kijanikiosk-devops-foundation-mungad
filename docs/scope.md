# KijaniKiosk Capstone Scope Document

## Problem Statement

The current KijaniKiosk `kk-payments` deployment runs in a single Kubernetes environment (`kijani-project`) and does not provide an isolated staging environment with automated health validation before production promotion. Configuration is environment-specific but is currently tied to the same namespace, while Jenkins does not yet enforce a staging smoke test before a production approval gate. This increases the risk that an unhealthy application or incorrect configuration can reach production without automated validation.

## Track

**Track A — Infrastructure-First**

## What I Will Build

- **Staging infrastructure:** Provision an isolated `kijani-staging` Kubernetes namespace and its supporting configuration using Terraform and Ansible.
- **Environment-separated deployment:** Deploy `kk-payments` to staging using the same application Deployment pattern as production, with a staging ConfigMap containing environment-specific configuration.
- **Automated delivery:** Extend Jenkins so a change merged to `main` deploys to staging, waits for Kubernetes rollout health, runs an application smoke test, and exposes a manual production approval gate only after staging validation succeeds.
- **Rollback protection:** Add automated deployment validation so a failed staging rollout or failed smoke test stops the pipeline before production promotion.
- **Observability:** Add a lightweight monitoring capability for the staging payment service and demonstrate detection of an intentionally unhealthy deployment.

## What Is Out of Scope

- **Serverless receipt processing:** The repository does not contain an existing receipt-processing chain, so implementing a complete serverless receipt architecture would create a separate project rather than extending the existing KijaniKiosk platform.
- **Full production Kubernetes hardening:** HTTPS certificates, ingress authentication, rate limiting, and HPA tuning are excluded because they require additional production infrastructure and workload testing beyond the capstone delivery target.
- **Replacement of the existing CI/CD platform:** Jenkins, Kubernetes, Terraform, and Ansible remain the delivery foundation; replacing them with another platform would add complexity without demonstrating a new production capability.

## Success Criteria

1. A merge to `main` triggers the Jenkins pipeline, deploys `kk-payments` to `kijani-staging`, waits for a successful Kubernetes rollout, and runs a passing smoke test before the production approval gate becomes available.

2. Staging and production use the same `kk-payments` Deployment structure while their ConfigMaps contain different environment-specific values, including different `DB_HOST` values.

3. A deliberately broken staging deployment causes the staging validation to fail and prevents the pipeline from reaching the production approval/promotion step.

## Architecture Diagram

The architecture diagram shows GitHub, Jenkins, Terraform/Ansible, the Kubernetes cluster, the `kijani-staging` namespace, the existing `kijani-project` production namespace, `kk-payments`, and the deployment and validation flows between them. Each connection is labelled with the operation or data flow it carries.
