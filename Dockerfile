# syntax=docker/dockerfile:1
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Use the native OS Chromium, requires xtradeb PPA for Ubuntu 24.04 and later
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

ARG IMAGE_NAME="tdock"

RUN set -e; \
    PACKAGES="\
        pandoc \
        texlive-xetex \
        texlive-latex-recommended \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        lmodern \
        graphviz \
        default-jre \
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
        fonts-noto-cjk \
        fonts-ubuntu \
        fonts-ubuntu-console \
        fonts-liberation \
        fonts-dejavu \
        fonts-dejavu-core \
        fonts-dejavu-mono \
        fonts-inconsolata \
        fonts-cantarell \
        fonts-firacode \
        fonts-jetbrains-mono \
        fonts-cascadia-code \
        fonts-freefont-ttf \
    "; \
    apt-get update \
 && apt-get install -y --no-install-recommends \
        software-properties-common \
        gpg-agent \
 # xtradeb PPA is required for Chromium on Ubuntu 24.04 and later, which is a dependency of Mermaid CLI \
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

RUN mkdir -p /opt/${IMAGE_NAME} && \
    echo '{"args": ["--no-sandbox", "--disable-setuid-sandbox"], "executablePath": "/usr/bin/chromium"}' > /opt/${IMAGE_NAME}/puppeteer-config.json

# 1. Create a Mermaid config
RUN mkdir -p /opt/${IMAGE_NAME} && \
    echo '{ "theme": "neutral", "fontFamily": "monospace" }' > /opt/${IMAGE_NAME}/mermaid-config.json

# 2. Inject BOTH the puppeteer config and the mermaid config into the mmdc wrapper
RUN mv /usr/local/bin/mmdc /usr/local/bin/mmdc-core && \
    echo '#!/bin/bash\n/usr/local/bin/mmdc-core -p /opt/'${IMAGE_NAME}'/puppeteer-config.json -c /opt/'${IMAGE_NAME}'/mermaid-config.json "$@"' > /usr/local/bin/mmdc && \
    chmod +x /usr/local/bin/mmdc

ARG PLANTUML_TAG="v1.2026.4"
RUN curl -fL "https://github.com/plantuml/plantuml/releases/download/${PLANTUML_TAG}/plantuml.jar" \
    -o /usr/local/lib/plantuml.jar && \
    printf '#!/bin/bash\nexec java -Djava.awt.headless=true -jar /usr/local/lib/plantuml.jar "$@"\n' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

RUN wget -q https://raw.githubusercontent.com/pandoc-ext/diagram/main/_extensions/diagram/diagram.lua -O /opt/${IMAGE_NAME}/diagram.lua

RUN echo 'if [ "$EUID" -eq 0 ]; then PS1="@\h:\w# "; else PS1="@\h:\w$ "; fi' >> /etc/bash.bashrc

WORKDIR /work
