# KijaniKiosk Capstone Scope Document

## Problem Statement

The current KijaniKiosk `kk-payments` deployment runs in a single Kubernetes environment (`kijani-project`) and does not provide an isolated staging environment with automated health validation before production promotion. Configuration is environment-specific but is currently tied to the same namespace, while Jenkins does not yet enforce a staging smoke test before a production approval gate. This increases the risk that an unhealthy application or incorrect configuration can reach production without automated validation.

## Track

**Track A — Infrastructure-First**

## What I Will Build

* **Staging infrastructure:** Provision and configure an isolated `kijani-staging` Kubernetes namespace using Terraform and Ansible.
* **Environment-separated deployment:** Deploy `kk-payments` to staging using the same Deployment manifest as production, with a staging ConfigMap containing environment-specific configuration.
* **Automated delivery:** Extend Jenkins so a merge to `main` deploys to staging, executes a smoke test, and exposes the production approval gate only after the smoke test succeeds.
* **Observability:** Add Prometheus monitoring and at least one alert rule for a meaningful `kk-payments` health signal such as pod restarts, latency, or error rate.
* **Receipt integration:** Connect the staging `kk-payments` deployment to the required `kk-payments-receipts-staging` bucket and verify that the receipt event reaches the Week 10 receipt-processing chain.

## What Is Out of Scope

* **Full production Kubernetes hardening:** HTTPS certificates, ingress authentication, rate limiting, and HPA tuning are excluded because they require additional production infrastructure and workload testing beyond the capstone delivery target.
* **Replacement of the existing CI/CD platform:** Jenkins, Kubernetes, Terraform, and Ansible remain the delivery foundation; replacing them with another platform would add complexity without demonstrating a new production capability.

## Success Criteria

1. A merge to `main` automatically deploys `kk-payments` to `kijani-staging`, and the Jenkins staging smoke test completes successfully before the production approval gate becomes available.
2. Staging and production use the same `kk-payments` Deployment manifest while their ConfigMaps contain different environment-specific values, including different `DB_HOST` values.
3. A staging receipt event is written to `kk-payments-receipts-staging`, the receipt-processing chain executes successfully, and a Prometheus health alert can be deliberately triggered and observed during the live demonstration.

## Architecture Diagram

The accompanying architecture diagram shows GitHub, Jenkins, Terraform/Ansible, Kubernetes staging and production namespaces, `kk-payments`, Prometheus, the staging receipt bucket, and the receipt-processing chain. Every connection is labelled with the operation or data flow it carries.
