# KijaniKiosk Production Foundation

## Overview

This project provisions a secure production-ready foundation for KijaniKiosk using an idempotent Bash automation script. The solution establishes service isolation, access controls, logging infrastructure, monitoring, firewall protection, and systemd service hardening following Linux security best practices.

The provisioning script can be executed multiple times safely without creating duplicate resources or causing configuration failures.

---

## Features

### Service Accounts

Three dedicated system service accounts are created to enforce separation of duties and the principle of least privilege:

* `kk-api`
* `kk-payments`
* `kk-logs`

All accounts are configured with the `nologin` shell to prevent interactive user access.

---

### User Group Management

A shared service group is created:

* `kijanikiosk`

This group provides controlled resource sharing between KijaniKiosk services while maintaining service isolation.

---

### Directory Structure

The provisioning script creates and manages the following directory structure:

```text
/opt/kijanikiosk
├── config
├── shared
│   └── logs
└── health
```

Directory purposes:

| Directory                      | Purpose                                   |
| ------------------------------ | ----------------------------------------- |
| `/opt/kijanikiosk/config`      | Application configuration files           |
| `/opt/kijanikiosk/shared/logs` | Shared service logs                       |
| `/opt/kijanikiosk/health`      | Health check and provisioning status data |

---

### Security Controls

#### Configuration Protection

The configuration directory is secured using restrictive permissions:

```bash
chmod 750 /opt/kijanikiosk/config
```

This prevents unauthorized access while allowing required service access.

#### Access Control Lists (ACLs)

Fine-grained permissions are implemented using POSIX ACLs:

| Service       | Access Level |
| ------------- | ------------ |
| `kk-api`      | Read/Write   |
| `kk-payments` | Read Only    |
| `kk-logs`     | Read/Write   |

Default ACLs are also configured to ensure permissions remain intact when new files are created or rotated.

---

### Firewall Configuration

The provisioning process configures UFW with a default-deny security posture.

Allowed traffic:

* SSH (`22/tcp`)
* HTTP (`80/tcp`)
* Monitoring traffic (`3001/tcp`) from the monitoring subnet

Restricted traffic:

* External access to the payments service port (`3001/tcp`) is denied.

This reduces the attack surface while maintaining required service accessibility.

---

### Systemd Service Management

The script provisions and enables the following services:

* `kk-api.service`
* `kk-payments.service`
* `kk-logs.service`

Each service:

* Runs under a dedicated service account
* Uses automatic restart policies
* Is enabled to start automatically on boot

---

### Systemd Security Hardening

Services are hardened using multiple systemd security controls, including:

* `NoNewPrivileges=yes`
* `PrivateTmp=yes`
* `PrivateDevices=yes`
* `ProtectSystem=strict`
* `ProtectHome=yes`
* `ProtectClock=yes`
* `ProtectHostname=yes`
* `ProtectKernelLogs=yes`
* `ProtectControlGroups=yes`
* `MemoryDenyWriteExecute=yes`
* `RestrictSUIDSGID=yes`
* `LockPersonality=yes`
* `SystemCallArchitectures=native`
* `UMask=0077`

Security exposure was validated using:

```bash
systemd-analyze security
```

with all services achieving an **OK** security rating.

---

### Logging and Retention

#### Persistent Journald Storage

System logs are configured for persistent storage:

```ini
Storage=persistent
```

This ensures logs survive system reboots.

#### Log Rotation

Log retention is managed using Logrotate to:

* Prevent uncontrolled disk growth
* Retain historical logs
* Automate cleanup of old log files

---

### Health Monitoring

A health status file is generated during provisioning:

```text
/opt/kijanikiosk/health/last-provision.json
```

The file contains:

* Provisioning timestamp
* Service status information
* Verification results

This provides a lightweight monitoring and audit mechanism.

---

## Idempotency

The provisioning script is designed to be idempotent.

Before creating resources, the script verifies whether they already exist and reuses them when appropriate.

Resources checked include:

* Users
* Groups
* Directories
* ACLs
* Firewall rules
* Systemd services

This allows the script to be executed repeatedly without causing duplicate resources or configuration errors.

---

## Verification

The script performs automated verification of:

* Service account existence
* Group existence
* Directory structure
* ACL configuration
* Firewall configuration
* Systemd service enablement
* Journal persistence configuration
* Logrotate configuration
* Health check generation

Successful execution concludes with a final verification phase confirming that all required components have been provisioned correctly.

---

## Running the Provisioning Script

Execute the script as root:

```bash
sudo ./kijanikiosk-provision.sh
```

The script will audit the existing environment, provision missing resources, apply security controls, and perform final verification checks.

---

## Security Principles Applied

This project demonstrates the following security and operations principles:

* Principle of Least Privilege
* Service Isolation
* Defense in Depth
* Secure Defaults
* Idempotent Infrastructure Automation
* Controlled Access via ACLs
* Network Segmentation and Firewalling
* System Service Hardening
* Operational Monitoring and Logging

