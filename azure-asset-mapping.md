# Azure Subscription Asset Mapping

**Subscription:** development
**Subscription ID:** 3a083da7-77cd-484f-b1fa-cbd058e12c42
**Tenant ID:** 4b89d64f-3b0d-4ce8-a3bc-29d30c1787ae
**Report Generated:** $(date)

## Executive Summary

This Azure subscription contains **14 resources** across **4 resource groups** in **2 regions** (East US and East US 2). The infrastructure primarily supports development environments for shared services and an infracodebase application platform.

## Resource Groups Overview

| Resource Group | Location | Resources | Purpose |
|---|---|---|---|
| `rg-use-shared-dev` | East US | 2 | Shared development services |
| `rg-dx-b2c-use-dev` | United States | 1 | Azure AD B2C directory |
| `DefaultResourceGroup-EUS` | East US | 2 | Default Azure services |
| `rg-use2-infracodebase-dev` | East US 2 | 9 | Infracodebase application platform |

---

## Detailed Resource Inventory

### 1. Compute Resources

#### App Services
- **app-infracodebase-use2-dev** (East US 2)
  - Resource Group: `rg-use2-infracodebase-dev`
  - Status: Running
  - Default Hostname: app-infracodebase-use2-dev.azurewebsites.net
  - App Service Plan: `asp-use2-infracodebase-dev`

#### App Service Plans
- **asp-use2-infracodebase-dev** (East US 2)
  - Resource Group: `rg-use2-infracodebase-dev`
  - Kind: Linux
  - Status: Ready
  - Workers: 1/3 maximum
  - Reserved: Yes (dedicated instance)
  - Zone Redundant: No

#### Virtual Machines
- **None provisioned**

---

### 2. Storage Resources

#### Storage Accounts
- **stouseshareddev** (East US)
  - Resource Group: `rg-use-shared-dev`
  - Type: StorageV2, Hot tier
  - HTTPS Only: Yes
  - Minimum TLS: 1.2
  - Public Blob Access: Disabled
  - Creation: 2024-01-31

- **stouse2icbdev** (East US 2)
  - Resource Group: `rg-use2-infracodebase-dev`
  - Type: StorageV2, Hot tier
  - HTTPS Only: Yes
  - Minimum TLS: 1.2
  - Public Blob Access: Enabled
  - Creation: 2025-10-13

#### Database Services
- **psqlflxsvr-use2-infracodebase-dev** (East US 2)
  - Resource Group: `rg-use2-infracodebase-dev`
  - Type: PostgreSQL Flexible Server
  - Version: 16
  - Storage: 32 GiB
  - Tier: Burstable (Standard_B1ms)
  - High Availability: Not Enabled
  - Availability Zone: 1
  - Status: Ready

---

### 3. Security & Identity Resources

#### Key Vaults
- **kv-use-shared-dev** (East US)
  - Resource Group: `rg-use-shared-dev`
  - Purpose: Shared development secrets

- **kv-use2-icb-dev** (East US 2)
  - Resource Group: `rg-use2-infracodebase-dev`
  - Purpose: Infracodebase application secrets

#### Azure AD B2C Directories
- **onwardplatformsb2c.onmicrosoft.com**
  - Resource Group: `rg-dx-b2c-use-dev`
  - Location: United States

- **infracodebase.onmicrosoft.com**
  - Resource Group: `DefaultResourceGroup-EUS`
  - Location: United States

#### SSL Certificates
- **dev.infracodebase.com**
  - Resource Group: `rg-use2-infracodebase-dev`
  - Associated with: app-infracodebase-use2-dev

---

### 4. Monitoring & Observability

#### Log Analytics Workspaces
- **DefaultWorkspace-3a083da7-77cd-484f-b1fa-cbd058e12c42-EUS** (East US)
  - Resource Group: `DefaultResourceGroup-EUS`
  - Retention: 30 days
  - Public Access: Enabled

- **log-use2-infracodebase-dev** (East US 2)
  - Resource Group: `rg-use2-infracodebase-dev`
  - Retention: 30 days
  - Public Access: Enabled

#### Application Insights
- **appi-use2-infracodebase-dev** (East US 2)
  - Resource Group: `rg-use2-infracodebase-dev`
  - Application Type: Node.JS
  - Connected Workspace: log-use2-infracodebase-dev
  - Retention: 90 days
  - Sampling: 100%

#### Alert Rules
- **Failure Anomalies - appi-use2-infracodebase-dev**
  - Resource Group: `rg-use2-infracodebase-dev`
  - Type: Smart Detector Alert Rule
  - Scope: Global

---

### 5. Networking Resources

#### Virtual Networks
- **None explicitly provisioned** (using default networking)

#### Network Security Groups
- **None found** (likely using default NSGs or App Service built-in security)

---

## Geographic Distribution

| Region | Resource Count | Resource Types |
|---|---|---|
| **East US** | 4 | Key Vault, Storage Account, Log Analytics, B2C Directory |
| **East US 2** | 9 | App Service, App Service Plan, Storage Account, PostgreSQL, Key Vault, Log Analytics, Application Insights, Alert Rule, SSL Certificate |
| **United States** | 1 | B2C Directory |

---

## Security Posture Summary

### Security Strengths
- HTTPS enforced on all storage accounts
- Minimum TLS 1.2 configured
- Private blob access disabled on shared storage
- Key Vaults deployed for secret management
- SSL certificate configured for custom domain

### Areas for Review
- One storage account has public blob access enabled (`stouse2icbdev`)
- No explicit network security groups identified
- PostgreSQL server accessibility needs verification
- Consider enabling High Availability for production workloads

---

## Cost Optimization Opportunities

1. **PostgreSQL Server**: Currently using Burstable tier - monitor usage to determine if this is optimal
2. **App Service Plan**: Review if dedicated instance is required for development environment
3. **Storage Accounts**: Review hot tier necessity for development data
4. **Log Analytics**: 30-day retention may be excessive for development environments

---

## Compliance & Governance

- **Naming Convention**: Resources follow consistent pattern with environment suffix `-dev`
- **Resource Tagging**: Not assessed in this inventory (requires additional query)
- **RBAC**: Not assessed in this inventory (requires identity analysis)
- **Backup Strategy**: Not identified in current resource inventory

---

## Next Steps Recommendations

1. **Enable Resource Tagging**: Implement consistent tagging strategy for cost tracking and governance
2. **Network Security Review**: Assess network security group configurations and implement as needed
3. **Backup Strategy**: Implement backup for PostgreSQL database and critical storage accounts
4. **Monitoring**: Enhance monitoring with custom alerts and dashboards
5. **Documentation**: Create architecture diagrams and operational runbooks

---

*This asset mapping provides a point-in-time view of Azure resources. For real-time information, use Azure portal or Azure Resource Graph queries.*