#!/bin/bash

set -e

echo "======================================"
echo "Running Terraform..."
echo "======================================"

cd terraform
terraform apply -auto-approve

cd ..

echo "======================================"
echo "Getting Multipass IP addresses..."
echo "======================================"

API_IP=$(multipass info kijanikiosk-api | awk '/IPv4/ {print $2}')
PAYMENTS_IP=$(multipass info kijanikiosk-payments | awk '/IPv4/ {print $2}')
LOGS_IP=$(multipass info kijanikiosk-logs | awk '/IPv4/ {print $2}')

echo "API: $API_IP"
echo "Payments: $PAYMENTS_IP"
echo "Logs: $LOGS_IP"

echo "======================================"
echo "Generating inventory..."
echo "======================================"

cat > ansible/hosts <<EOF
[kijanikiosk]
api ansible_host=$API_IP
payments ansible_host=$PAYMENTS_IP
logs ansible_host=$LOGS_IP

[kijanikiosk:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/daisy-munga/.ssh/multipass_id_rsa
EOF

echo "Inventory generated."

echo "======================================"
echo "Running Ansible..."
echo "======================================"

cd ansible
ansible-playbook -i hosts playbook.yaml

echo "======================================"
echo "Pipeline completed successfully."
echo "======================================"
