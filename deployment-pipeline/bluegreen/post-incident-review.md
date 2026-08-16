# Post-Incident Review

## 1. Incident Summary

During an investor demonstration, the deployment process accidentally targeted the staging environment instead of the intended demonstration environment. This caused 48 seconds of service interruption for the staging system before normal service was restored. No production customer data was affected, but the interruption reduced confidence during the demonstration.


## 2. Timeline

| Time | Event |
|------|-------|
| 10:15:00 | Deployment initiated for investor demonstration |
| 10:15:08 | Pipeline targeted staging environment |
| 10:15:20 | Staging service became unavailable |
| 10:15:45 | Team identified incorrect deployment target |
| 10:16:08 | Correct environment restored |
| 10:16:08 | Total outage duration: 48 seconds |


## 3. Root Cause Analysis

### Why 1
The deployment pipeline targeted the wrong environment.

### Why 2
The pipeline did not verify the intended deployment target before executing.

### Why 3
The deployment configuration relied on manually selected environment values.

### Why 4
There was no automated safeguard preventing deployments to the wrong environment.

### Structural Finding

The deployment process lacked mandatory environment validation and automated safety checks before traffic was switched.


## 4. Contributing Factors

- Environment names were similar and easy to confuse.
- Deployment relied on manual operator selection.
- No automated deployment approval step existed.
- Environment validation was not part of the deployment pipeline.


## 5. What Went Well

The monitoring process detected the problem quickly, allowing the team to restore service with minimal disruption. Communication during the incident remained clear, and the issue was resolved before any production customers were affected.


## 6. Action Items

| Owner | Action | Target Time |
|-------|--------|-------------|
| DevOps Engineer | Add mandatory environment validation before deployment begins. | 1 week |
| Platform Engineer | Implement automatic rollback when health checks fail after deployment. | 2 weeks |
| Release Manager | Introduce deployment approval gates for environment changes. | 2 weeks |
