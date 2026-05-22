# syntax=docker/dockerfile:1
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Use the native OS Chromium, requires xtradeb PPA for Ubuntu 24.04
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN set -e; \
    PACKAGES="\
        pandoc \
        texlive-xetex \
        texlive-latex-recommended \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        lmodern \
        default-jre \
        plantuml \
        graphviz \
        chromium \
        nodejs \
        npm \
        wget \
        curl \
        librsvg2-bin \
        fontconfig \
        fonts-roboto \
        fonts-open-sans \
        fonts-lato \
        fonts-noto \
        fonts-ubuntu \
        fonts-ubuntu-console \
        fonts-liberation \
        fonts-dejavu \
        fonts-inconsolata \
        fonts-cantarell \
    "; \
    apt-get update \
 && apt-get install -y --no-install-recommends \
        software-properties-common \
        gpg-agent \
 && add-apt-repository -y ppa:xtradeb/apps \
 && apt-get update \
 && apt-get install --dry-run $PACKAGES \
 && apt-get install -y $PACKAGES --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy local fonts into the system font directory
COPY fonts/ /usr/share/fonts/extra-fonts/

# Build font information caches
RUN fc-cache -fv

RUN npm install -g @mermaid-js/mermaid-cli

RUN mkdir -p /opt/pandock && \
    echo '{"args": ["--no-sandbox", "--disable-setuid-sandbox"], "executablePath": "/usr/bin/chromium"}' > /opt/pandock/puppeteer-config.json

RUN mv /usr/local/bin/mmdc /usr/local/bin/mmdc-core && \
    echo '#!/bin/bash\n/usr/local/bin/mmdc-core -p /opt/pandock/puppeteer-config.json "$@"' > /usr/local/bin/mmdc && \
    chmod +x /usr/local/bin/mmdc

RUN wget -q https://raw.githubusercontent.com/pandoc-ext/diagram/main/_extensions/diagram/diagram.lua -O /opt/pandock/diagram.lua

RUN echo 'PS1="@\h:\w\$ "' >> /etc/bash.bashrc

WORKDIR /work
