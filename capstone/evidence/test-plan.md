# Capstone Peer Testing Plan

## Purpose

This test plan evaluates the KijaniKiosk Capstone Track A staging delivery
workflow from the perspective of another engineer.

The reviewer should follow the repository README rather than receiving
step-by-step assistance from the author.

## Test Environment

- Repository: https://github.com/Mungad/kijanikiosk-devops-foundation-mungad
- Track: Capstone Track A — Infrastructure-First
- Infrastructure: Terraform
- Configuration: Ansible
- Runtime: Kubernetes / Minikube
- Delivery: Jenkins
- Application: `kk-payments`
- Staging namespace: `kijani-staging`

## Test 1 — Fresh Setup

The reviewer will:

1. Clone the repository.
2. Review the README prerequisites.
3. Follow the documented setup instructions.
4. Verify that the staging namespace can be provisioned.
5. Verify that the staging configuration can be applied.
6. Verify that the application can be deployed.

Expected result:

The reviewer can understand and execute the setup using the README
without requiring undocumented author-specific steps.

## Test 2 — Happy Path

The reviewer will:

1. Review the Jenkins pipeline.
2. Trigger the Jenkins delivery pipeline.
3. Verify Terraform validation succeeds.
4. Verify staging provisioning succeeds.
5. Verify Ansible configuration succeeds.
6. Verify Kubernetes deployment succeeds.
7. Verify rollout validation succeeds.
8. Verify the application health smoke test succeeds.
9. Verify the production approval gate is reached only after successful
   staging validation.

Expected result:

A healthy staging deployment reaches the production approval gate.

## Test 3 — Failure Path

The reviewer will inspect or execute a controlled staging failure using an
invalid application image.

Expected result:

1. Kubernetes rollout validation fails.
2. The smoke test is not executed.
3. Production approval is not presented.
4. Production promotion is not executed.
5. Jenkins reports the pipeline as failed.

## Test 4 — Recovery

The reviewer will verify that restoring the known-good image allows the
staging deployment to recover.

Expected result:

The deployment successfully rolls out and the `/health` endpoint reports
a healthy application.

## Test 5 — AI Governance

The reviewer will read:

`capstone/docs/ai-governance-log.md`

The reviewer will assess whether:

- AI-assisted changes are identified.
- Human validation steps are documented.
- Technical decisions were independently verified.
- The governance record is specific enough to reproduce the review process.

## Reviewer Feedback

The reviewer will record:

- Issues discovered.
- Severity.
- Suggested improvements.
- Whether the README was sufficient.
- Any unexpected behaviour.

At least three feedback items will be documented.
