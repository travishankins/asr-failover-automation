---

# Failover Automation with Azure Automation, PowerShell, and Ansible

This repository contains the necessary configuration to automate failover processes between different environments (on-premise, East US, Central US) using **Azure Automation**, **PowerShell scripts**, and **Ansible playbooks**.

The workflow is divided into two scenarios:

- **On-Premise to East US Failover**
- **East US to Central US Failover**

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [High-Level Architecture](#high-level-architecture)
3. [Steps to Set Up](#steps-to-set-up)
4. [Ansible Playbooks and PowerShell Scripts](#ansible-playbooks-and-powershell-scripts)
5. [Automation Flow](#automation-flow)

## Prerequisites

Before setting up the failover automation, ensure the following prerequisites are met:

- **Azure Automation Account** with **System-Assigned Managed Identity** enabled.
- **Azure Key Vault** to securely store SSH credentials (username and password).
- **VM** or **Hybrid Runbook Worker** with **Ansible** installed.
- **Azure DevOps Pipelines** configured for failover using the provided YAML files.
- **SSH Key** configured to access the VM/Hybrid Worker.

## High-Level Architecture

1. **Azure Automation Account**: Triggers a PowerShell runbook that handles the SSH connection to the VM/Hybrid Worker and triggers the appropriate Ansible playbook.
2. **PowerShell Script**: Retrieves the SSH username and password from Azure Key Vault, establishes an SSH connection, and executes the Ansible playbook.
3. **Ansible Playbook**: Automates the failover process by triggering an Azure DevOps pipeline that runs the failover YAML configuration for the respective scenario.
4. **Azure DevOps Pipeline**: Executes the YAML file, handling the failover of resources between environments (on-premise to East US or East US to Central US).

## Steps to Set Up

### 1. Set Up Azure Automation Account

- Create an **Azure Automation Account** in your subscription.
- Enable the **System-Assigned Managed Identity** under the **Identity** tab.
- Ensure the Automation Account has access to **Azure Key Vault** to retrieve secrets (SSH credentials).

### 2. Configure Azure Key Vault

- Store your **SSH username** and **password** as secrets in **Azure Key Vault**.
- Grant the **Automation Account’s Managed Identity** the necessary access (Get and List) to retrieve the secrets from the Key Vault.

### 3. Create PowerShell Runbooks

You will need two **PowerShell runbooks**, each corresponding to a specific failover scenario:

- **Runbook 1**: Triggers the on-premise to East US failover.
- **Runbook 2**: Triggers the East US to Central US failover.

In each runbook, use the following steps:

1. Retrieve SSH credentials from **Azure Key Vault**.
2. Establish an **SSH connection** to the **VM/Hybrid Worker**.
3. Execute the corresponding **Ansible Playbook**.

Refer to the provided PowerShell scripts for implementation details.

### 4. Set Up Ansible on the VM/Hybrid Worker

- Ensure **Ansible** is installed on the **VM** or **Hybrid Worker**.
- Place the respective **Ansible playbooks** (`automation-playbook-onpremise-to-eastus.yml` and `automation-playbook-eastus-to-centralus.yml`) on the machine.

### 5. Configure Azure DevOps Pipelines

- Create two Azure DevOps pipelines:
  - **Pipeline 1**: Handles the **on-premise to East US** failover using the `onpremise-to-eastus-failover.yml` configuration.
  - **Pipeline 2**: Handles the **East US to Central US** failover using the `eastus-to-centralus.yml` configuration.

Each pipeline should be configured to execute its corresponding failover YAML file and manage the resources as needed.

## Ansible Playbooks and PowerShell Scripts

### Ansible Playbooks

- **Playbook 1** (`automation-playbook-onpremise-to-eastus.yml`): Triggers the Azure DevOps pipeline responsible for failing over resources from **on-premise to East US**.
- **Playbook 2** (`automation-playbook-eastus-to-centralus.yml`): Triggers the Azure DevOps pipeline responsible for failing over resources from **East US to Central US**.

### PowerShell Scripts

- **Script 1** (`trigger-ansible-onpremise-failover.ps1`):

  - Retrieves SSH credentials from Key Vault.
  - Connects to the VM/Hybrid Worker.
  - Executes `automation-playbook-onpremise-to-eastus.yml`.

- **Script 2** (`trigger-ansible-eastus-failover.ps1`):
  - Retrieves SSH credentials from Key Vault.
  - Connects to the VM/Hybrid Worker.
  - Executes `automation-playbook-eastus-to-centralus.yml`.

## Automation Flow

1. **Azure Automation Account** triggers a **PowerShell runbook**.
2. **PowerShell Script** retrieves **SSH credentials** from **Azure Key Vault**.
3. The **PowerShell Script** establishes an **SSH connection** to the **VM/Hybrid Worker**.
4. The **Ansible Playbook** is executed on the **VM/Hybrid Worker**.
5. The **Ansible Playbook** triggers the respective **Azure DevOps pipeline**.
6. The **Azure DevOps pipeline** executes the **failover YAML** to complete the failover process.
7. After failover, DNS updates are handled by failover YAML files to update AD DNS.
