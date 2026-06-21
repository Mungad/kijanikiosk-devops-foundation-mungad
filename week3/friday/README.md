# KijaniKiosk Production Foundation

## Overview

This project provisions a secure production foundation for KijaniKiosk using an idempotent Bash script.

## Features

### Service Accounts

Three dedicated service accounts are created:

* kk-api
* kk-payments
* kk-logs

These accounts use the nologin shell to prevent interactive logins.

### Directory Structure

The script creates:

* /opt/kijanikiosk/config
* /opt/kijanikiosk/shared/logs
* /opt/kijanikiosk/health

### Security Controls

The configuration directory is restricted using 750 permissions.

Access Control Lists (ACLs) are used to provide controlled access to shared logs:

* kk-api: read/write
* kk-payments: read-only
* kk-logs: read/write

Default ACLs ensure permissions survive future file creation and log rotation.

### Systemd Services

The script provisions:

* kk-api.service
* kk-payments.service
* kk-logs.service

Services run under dedicated service accounts and use systemd hardening directives such as:

* NoNewPrivileges
* PrivateTmp
* ProtectSystem
* ProtectHome

### Idempotency

The script can be run repeatedly without failure.

Existing users, groups, directories, ACLs, and services are detected and reused instead of recreated.

## Verification

The script verifies:

* Service account existence
* Group existence
* Directory structure
* ACL configuration
* Service enablement
