FROM alpine:3.15 AS builder

# ENV ANSIBLE_VERSION=4.10.0 \
#     TERRAFORM_VERSION=1.0.1 \
#     HELM_VERSION=3.6.3 \
#     KUBECTL_VERSION=1.22.1 \
#     GCLOUD_VERSION=347.0.0 \
#     AWSCLI_VERSION=2.0.0 \
#     PACKER_VERSION=1.8.0 \
#     VAULT_VERSION=1.9.4

RUN apk add -U --no-cache \
        ansible \
        bash \
        build-base \
        coreutils \
        curl \
        file \
        g++ \
        gcompat \
        grep \
        git \
        gzip \
        libc6-compat \
        libffi-dev \
        make \
        ncurses \
        python3 \
        python3-dev \
        py3-pip \
        py3-cffi \
        ruby \
        ruby-bigdecimal \
        ruby-etc \
        ruby-fiddle \
        ruby-irb \
        ruby-json \
        ruby-test-unit \
        sudo \
        tar \
        unzip \
    && mkdir -p /tmp/ansible/{roles,collections} \
    && chmod -R 1777 /tmp/ansible \
    && adduser -D -s /bin/bash devops \
    && ln -s /bin/touch /usr/bin/touch

USER devops
WORKDIR /home/devops
ENV SHELL=/bin/bash \
	USER=devops

COPY ./ansible/* /tmp/

RUN ansible-galaxy install -fr /tmp/requirements.yml \
    && ansible-playbook -v -i /tmp/inventory.yml /tmp/playbook.yml \
    && rm -rf ./ansible.cfg ./.ansible.cfg ./.ansible \
    && rm -r /home/devops/.cache

FROM alpine:3.15 AS workstation

RUN apk add -U --no-cache \
        bash \
        bat \
        bind-tools \
        curl \
        dasel \
        podman \
        docker \
        docker-compose \
        fzf \
        git \
        iputils \
        jq \
        openssh-client-default \
        perl \
        python3 \
        socat \
        sudo \
        vim \
    && adduser -D -s /bin/bash devops \
    && echo "devops ALL = NOPASSWD: /usr/local/bin/docker-socat \"\"" \
        > /etc/sudoers.d/docker-socat \
    && ln -s /var/run/docker-host.sock /var/run/docker.sock

COPY --from=builder --chown=devops:devops /home/devops /home/devops
COPY --chmod=755 ./docker-socat.sh /usr/local/bin/docker-socat

USER devops
WORKDIR /home/devops