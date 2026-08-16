# KijaniKiosk Payments Service SLI/SLO Specification

## Overview

This document defines the proposed Service Level Indicators (SLIs) and Service Level Objectives (SLOs) for the KijaniKiosk Payments Service. These targets are proposed because the service is currently running in a demonstration environment rather than production.


## SLI 1 – Availability

**Purpose**
Measure whether the payment service is available to customers.

**Data Source**
- Health endpoint (/health)
- Nginx access logs
- Monitoring service

**Measurement**
Percentage of successful health checks.

Calculation:

Successful health checks / Total health checks × 100

**Measurement Window**

30 days

### Proposed SLO

Availability ≥ 99.9%


## SLI 2 – Request Latency

**Purpose**

Measure how quickly payment requests are processed.

**Data Source**

- Nginx access logs
- Future metrics platform

**Measurement**

95th percentile response time.

**Measurement Window**

30 days

### Proposed SLO

95% of requests complete in under 300 ms.


## SLI 3 – Payment Error Rate

**Purpose**

Measure failed payment operations.

**Data Source**

Application logs

HTTP response codes

Future metrics platform

**Measurement**

Failed payment requests / Total payment requests × 100

**Measurement Window**

30 days

### Proposed SLO

Error rate below 1%.


# Automated Rollback Thresholds

| SLI | Rollback Threshold | Relationship to SLO |
|-----|--------------------|---------------------|
| Availability | Below 95% for 60 seconds | Prevents long outages before SLO is violated |
| Latency | 95th percentile exceeds 1 second for 60 seconds | Protects user experience before monthly target is missed |
| Payment Error Rate | Above 5% for 60 seconds | Stops faulty releases before monthly error budget is exhausted |


# Out of Scope

## Infrastructure CPU Usage

CPU utilization is monitored for capacity planning but is not an SLI because customers do not directly experience CPU percentage.

## Memory Utilization

Memory usage helps diagnose performance issues but is not used to measure customer-visible service quality.
