# Capstone Failure-Gate Evidence

## Purpose

This test verifies that an unhealthy staging deployment cannot proceed to
production approval or promotion.

## Fault Introduced

The staging `kk-payments` Deployment was temporarily changed from the known
working image:

`host.minikube.internal:8082/kk-payments:1.3.0-d4db9b0`

to an intentionally invalid image:

`host.minikube.internal:8082/kk-payments:9.9.9-broken`

The change was committed as:

`test(capstone): verify staging failure gate`

## Pipeline Result

The Jenkins pipeline successfully completed:

- Terraform validation
- Terraform staging provisioning
- Ansible staging configuration

The deployment stage then failed during Kubernetes rollout validation.

Observed result:

```text
error: timed out waiting for the condition

console output
error: timed out waiting for the condition
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Smoke Test)
Stage "Smoke Test" skipped due to earlier failure(s)
[Pipeline] getContext
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Production Approval)
Stage "Production Approval" skipped due to earlier failure(s)
[Pipeline] getContext
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Production Promotion)
Stage "Production Promotion" skipped due to earlier failure(s)
[Pipeline] getContext
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
Staging validation pipeline finished.
[Pipeline] echo
Capstone delivery pipeline failed. Production promotion was not completed.
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // timeout
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: script returned exit code 1
Finished: FAILURE

Expected Safety Behaviour

The failure stopped the delivery process before production approval and
production promotion.

This demonstrates that an unhealthy staging deployment cannot proceed
through the production delivery gate.

Recovery

The intentionally invalid image was removed and the known-good staging image
was restored:

host.minikube.internal:8082/kk-payments:1.3.0-d4db9b0

The healthy deployment will be revalidated after restoration.

Success Criterion

This test satisfies the capstone requirement:

A deliberately broken staging deployment causes the staging validation to
fail and prevents the pipeline from reaching the production
approval/promotion step.
