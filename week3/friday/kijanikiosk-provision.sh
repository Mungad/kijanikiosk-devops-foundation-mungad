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

phase "PHASE 2 - PACKAGE & VERSION CHECKS"

for pkg in curl ufw acl; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        log "PACKAGE OK: $pkg installed"
    else
        log "INSTALLING: $pkg"
        apt-get update -y
        apt-get install -y "$pkg"
    fi
done

log "Package verification completed"

phase "PHASE 3 - USERS & GROUPS"

getent group kijanikiosk >/dev/null || \
groupadd kijanikiosk

id kk-api >/dev/null 2>&1 || \
useradd -r -g kijanikiosk -s /usr/sbin/nologin kk-api

id kk-payments >/dev/null 2>&1 || \
useradd -r -g kijanikiosk -s /usr/sbin/nologin kk-payments

id kk-logs >/dev/null 2>&1 || \
useradd -r -g kijanikiosk -s /usr/sbin/nologin kk-logs

log "Users and group verified"

phase "PHASE 4 - DIRECTORY STRUCTURE & ACLS"

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

phase "PHASE 5 - FIREWALL"

ufw --force reset

ufw default deny incoming
ufw default allow outgoing

ufw allow 22/tcp comment 'SSH access'
ufw allow 80/tcp comment 'HTTP access'

ufw allow from 10.0.1.0/24 to any port 3001 proto tcp comment 'Monitoring subnet health checks'

ufw deny 3001/tcp comment 'Block external access to payments port'

ufw --force enable

log "Firewall configured"

phase "PHASE 6 - SYSTEMD SERVICES"

cat > /opt/kijanikiosk/config/api.env <<EOF
PORT=3000
EOF

cat > /opt/kijanikiosk/config/payments.env <<EOF
PORT=3001
EOF

cat > /opt/kijanikiosk/config/logs.env <<EOF
LOG_LEVEL=INFO
EOF

chown root:kijanikiosk /opt/kijanikiosk/config/*.env
chmod 640 /opt/kijanikiosk/config/*.env

cat > /etc/systemd/system/kk-api.service << 'EOF'
[Unit]
Description=KijaniKiosk API Service

[Service]
User=kk-api
Group=kijanikiosk
EnvironmentFile=/opt/kijanikiosk/config/api.env

ExecStart=/usr/bin/sleep infinity
Restart=always

NoNewPrivileges=yes
PrivateTmp=yes
PrivateDevices=yes

ProtectSystem=strict
ProtectHome=yes
ProtectClock=yes
ProtectHostname=yes
ProtectKernelLogs=yes
ProtectControlGroups=yes

MemoryDenyWriteExecute=yes
RestrictSUIDSGID=yes
LockPersonality=yes

RestrictNamespaces=yes
SystemCallArchitectures=native

CapabilityBoundingSet=
UMask=0077

ProtectProc=invisible
ProcSubset=pid
PrivateUsers=yes
RestrictAddressFamilies=AF_UNIX

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/kk-payments.service << 'EOF'
[Unit]
Description=KijaniKiosk Payments Service
After=kk-api.service
Wants=kk-api.service

[Service]
User=kk-payments
Group=kijanikiosk
EnvironmentFile=/opt/kijanikiosk/config/payments.env

ExecStart=/usr/bin/sleep infinity
Restart=always

NoNewPrivileges=yes
PrivateTmp=yes
PrivateDevices=yes

ProtectSystem=strict
ProtectHome=yes
ProtectClock=yes
ProtectHostname=yes
ProtectKernelLogs=yes
ProtectControlGroups=yes
ProtectKernelTunables=yes
ProtectKernelModules=yes

MemoryDenyWriteExecute=yes
RestrictSUIDSGID=yes
LockPersonality=yes

RestrictNamespaces=yes
SystemCallArchitectures=native

CapabilityBoundingSet=
UMask=0077

ProtectProc=invisible
ProcSubset=pid
PrivateUsers=yes
RestrictAddressFamilies=AF_UNIX

RemoveIPC=yes
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/kk-logs.service << 'EOF'
[Unit]
Description=KijaniKiosk Logging Service

[Service]
User=kk-logs
Group=kijanikiosk
EnvironmentFile=/opt/kijanikiosk/config/logs.env

ExecStart=/usr/bin/sleep infinity
Restart=always

NoNewPrivileges=yes
PrivateTmp=yes
PrivateDevices=yes

ProtectSystem=strict
ProtectHome=yes
ProtectClock=yes
ProtectHostname=yes
ProtectKernelLogs=yes
ProtectControlGroups=yes

MemoryDenyWriteExecute=yes
RestrictSUIDSGID=yes
LockPersonality=yes

RestrictNamespaces=yes
SystemCallArchitectures=native

CapabilityBoundingSet=
UMask=0077

ProtectProc=invisible
ProcSubset=pid
PrivateUsers=yes
RestrictAddressFamilies=AF_UNIX

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable kk-api.service
systemctl enable kk-payments.service
systemctl enable kk-logs.service

log "Systemd services configured"

phase "PHASE 7 - JOURNAL PERSISTENCE & LOGROTATE"

mkdir -p /var/log/journal

cat > /etc/systemd/journald.conf <<EOF
[Journal]
Storage=persistent
SystemMaxUse=500M
EOF

systemctl restart systemd-journald

cat > /etc/logrotate.d/kijanikiosk <<EOF
/opt/kijanikiosk/shared/logs/*.log {
    weekly
    rotate 4
    missingok
    notifempty
    compress
    create 0640 root kijanikiosk
}
EOF

logrotate --debug /etc/logrotate.d/kijanikiosk >/dev/null 2>&1

log "Journal persistence configured"
log "Logrotate configuration verified"

phase "PHASE 8 - MONITORING HEALTH CHECKS"

api_status=$(timeout 2 bash -c "echo >/dev/tcp/localhost/3000" 2>/dev/null && echo '"ok"' || echo '"down"')

payments_status=$(timeout 2 bash -c "echo >/dev/tcp/localhost/3001" 2>/dev/null && echo '"ok"' || echo '"down"')

printf '{"timestamp":"%s","kk-api":%s,"kk-payments":%s}\n' \
"$(date -Is)" "$api_status" "$payments_status" \
> /opt/kijanikiosk/health/last-provision.json

chown kk-logs:kijanikiosk /opt/kijanikiosk/health/last-provision.json
chmod 640 /opt/kijanikiosk/health/last-provision.json

log "Health check JSON created"

phase "FINAL VERIFICATION"

systemctl is-enabled kk-api.service >/dev/null
systemctl is-enabled kk-payments.service >/dev/null
systemctl is-enabled kk-logs.service >/dev/null

log "All services verified"

getfacl /opt/kijanikiosk/shared/logs >/dev/null 2>&1

log "ACL verification passed"
