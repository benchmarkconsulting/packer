FROM jenkins/jnlp-slave

ARG packer_version=1.7.0


ENV PACKER_VER=${packer_version}

USER root

# Enable sudo
RUN apt-get update && apt-get -y install sudo
RUN adduser jenkins sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Packer
RUN wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip -O packer.zip &&\
    unzip packer.zip &&\
    mv packer /usr/bin/packer &&\
    chmod 755 /usr/bin/packer

ENV USER jenkins

USER jenkins

ENTRYPOINT ["jenkins-slave"]
