FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y curl ca-certificates gnupg lsb-release && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs docker.io && \
    apt-get clean

USER jenkins
