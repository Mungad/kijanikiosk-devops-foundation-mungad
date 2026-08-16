FROM jenkins/jenkins:2.555.3-jdk21

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        python3 \
        python3-pip \
        python3-venv \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Terraform
ARG TERRAFORM_VERSION=1.15.7
RUN curl -fsSL \
        "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
        -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm /tmp/terraform.zip

# kubectl
ARG KUBECTL_VERSION=v1.35.1
RUN curl -fsSL \
        "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
        -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Ansible and Kubernetes Python client
RUN python3 -m venv /opt/ansible-venv && \
    /opt/ansible-venv/bin/pip install --no-cache-dir \
        ansible-core==2.21.1 \
        kubernetes

ENV PATH="/opt/ansible-venv/bin:${PATH}"

USER jenkins
