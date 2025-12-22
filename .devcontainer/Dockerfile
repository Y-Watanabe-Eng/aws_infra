# ベースイメージ
FROM mcr.microsoft.com/devcontainers/base:noble

# 基本パッケージ
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg \
    lsb-release \
    sudo \
    git \
    software-properties-common \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

###############################################
# Node.js（Next.js 用） LTS
###############################################
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - \
    && apt-get install -y nodejs

###############################################
# pnpm（default package manager に）
###############################################
RUN corepack enable \
    && corepack prepare pnpm@latest --activate

###############################################
# ESLint / Prettier（Next.js 用）
###############################################
RUN npm install -g eslint prettier eslint-config-next

###############################################
# AWS CLI v2
###############################################
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2*

###############################################
# AWS Copilot CLI
###############################################
RUN curl -Lo /usr/local/bin/copilot \
    https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux \
    && chmod +x /usr/local/bin/copilot

###############################################
# GitHub CLI
###############################################
RUN type -p curl >/dev/null || (apt-get update && apt-get install -y curl) \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
        https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt-get update \
    && sudo apt-get install -y gh

###############################################
# Python 3
###############################################
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

###############################################
# Terraform
###############################################
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
        | sudo tee /etc/apt/sources.list.d/hashicorp.list \
    && sudo apt-get update \
    && sudo apt-get install -y terraform \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

###############################################
# AWS-CDK（TypeScript IaC 用）
###############################################
RUN npm install -g aws-cdk

