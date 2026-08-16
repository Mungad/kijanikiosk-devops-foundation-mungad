# Peer Feedback Log

## Review Information

**Reviewer:** Aisha Nuru Mohamed
**Project:** KijaniKiosk DevOps Foundation 
**Track:** Capstone Track A
**Review type:** Peer review 
**Date:** 2026-08-16

## Issue 1 — Jenkins prerequisites could be clearer

### Issue

The README explains the Jenkins delivery workflow but could make the
required Jenkins/Kubernetes command-line prerequisites more explicit for a
new engineer setting up the environment.

### Severity

Unclear documentation.

### Resolution

I added a concise prerequisites section identifying the tools required by the
Jenkins execution environment, including Terraform, Ansible, kubectl, and
access to the Kubernetes cluster.

### Evidence

Updated:

`README.md`

## Issue 2 — Failure-gate procedure could be easier to reproduce

### Issue

The failure-gate evidence explains that an invalid image was used, but a new
reviewer may need a more explicit description of how the fault was introduced,
how the rollout failure was observed, and how the known-good image was
restored.

### Severity

Unclear documentation.

###  Resolution

I added a short reproducible procedure to the failure-gate evidence describing:

- The intentionally invalid image.
- The expected Jenkins behaviour.
- The Kubernetes rollout failure.
- The recovery command.
- Verification that the known-good image successfully rolls out.


## Issue 3 — Production promotion scope could be clearer

### Issue

The Jenkins pipeline reaches a manual production approval gate, but the
production promotion stage currently acts as a controlled placeholder rather
than performing an actual production deployment.

### Severity

Minor improvement / scope clarification.

### Resolution

I clarified in the README that Track A implements the staging validation and
manual approval gate while production deployment remains outside the current
milestone.

## Feedback Evaluation

Aisha identified three areas where clarification would improve the project:

1. Jenkins environment prerequisites.
2. Failure-gate reproducibility.
3. The boundary between production approval and actual production deployment.

The feedback was reviewed against the Track A implementation and used to
identify concrete documentation improvements.

## Follow-up

The feedback demonstrates that the staging delivery workflow is understandable
but that setup prerequisites, failure recovery, and production-promotion scope
should be made more explicit for engineers unfamiliar with the project.
