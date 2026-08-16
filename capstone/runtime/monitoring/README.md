# kk-payments Monitoring

This directory contains the Track A monitoring signal for the `kk-payments`
staging deployment.

## Monitoring approach

The capstone uses a log-based error-rate calculation rather than Prometheus.
This keeps the monitoring signal reproducible in the local Minikube environment
without requiring an additional monitoring platform.

The script reads the latest `kk-payments` Kubernetes pod logs and calculates
the percentage of log lines classified as errors.

## Threshold

The monitoring threshold is:

- Error rate greater than 5% → `ALERT`
- Error rate at or below 5% → `OK`

The script exits with status `1` when the threshold is exceeded, allowing it to
be used as a pipeline validation signal.

## Run

From the repository root:

```bash
./capstone/runtime/monitoring/kk-payments-error-rate.sh
