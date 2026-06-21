#!/bin/bash

set -euo pipefail

LOGFILE="/tmp/kijanikiosk-provision.log"

log() {
    echo "[$(date '+%F %T')] $1"
}

phase() {
    echo
    echo "======================================="
    echo "$1"
    echo "======================================="
}

phase "PHASE 1 - AUDIT & DIRTY STATE DETECTION"

if id kk-api &>/dev/null; then
    log "FOUND: kk-api already exists"
fi

if id kk-payments &>/dev/null; then
    log "FOUND: kk-payments already exists"
fi

if id kk-logs &>/dev/null; then
    log "FOUND: kk-logs already exists"
fi

if getent group kijanikiosk >/dev/null; then
    log "FOUND: kijanikiosk group already exists"
fi

if [ -d /opt/kijanikiosk/config ]; then
    log "FOUND: config directory exists"
fi

perm=$(stat -c %a /opt/kijanikiosk/config)

if [ "$perm" = "777" ]; then
    log "FOUND: insecure config permissions (777)"
fi

phase "PHASE 2 - USERS & GROUPS"

getent group kijanikiosk >/dev/null || \
groupadd kijanikiosk

id kk-api >/dev/null 2>&1 || \
useradd -r -g kijanikiosk -s /usr/sbin/nologin kk-api

id kk-payments >/dev/null 2>&1 || \
useradd -r -g kijanikiosk -s /usr/sbin/nologin kk-payments

id kk-logs >/dev/null 2>&1 || \
useradd -r -g kijanikiosk -s /usr/sbin/nologin kk-logs

log "Users and group verified"

phase "PHASE 3 - DIRECTORY STRUCTURE & ACLS"

mkdir -p /opt/kijanikiosk/config
mkdir -p /opt/kijanikiosk/shared/logs
mkdir -p /opt/kijanikiosk/health

chmod 750 /opt/kijanikiosk/config

# Configure ACLs for shared logs

setfacl -m u:kk-api:rwx /opt/kijanikiosk/shared/logs
setfacl -m u:kk-payments:rx /opt/kijanikiosk/shared/logs
setfacl -m u:kk-logs:rwx /opt/kijanikiosk/shared/logs

# Default ACLs for future files
setfacl -d -m u:kk-api:rwx /opt/kijanikiosk/shared/logs
setfacl -d -m u:kk-payments:rx /opt/kijanikiosk/shared/logs
setfacl -d -m u:kk-logs:rwx /opt/kijanikiosk/shared/logs

log "ACLs configured"

log "Directory structure verified"
