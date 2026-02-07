# Contoso Financial Services - Azure Policy Framework

## Policy Structure
- **Definitions:** Individual policy rules
- **Initiatives:** Bundles of policies (e.g., "APRA CPS 234 Compliance")
- **Assignments:** Applied at Management Group or Subscription level

## Custom Policy Definitions

### 1. Require Specific Tags
**File:** `policies/definitions/require-tags.json`
**Effect:** Deny
**Parameters:** Tag names (CostCenter, BusinessUnit, Environment, Owner, DataClassification)
**Scope:** All Management Groups except Sandbox

### 2. Allowed VM SKUs
**File:** `policies/definitions/allowed-vm-skus.json`
**Effect:** Deny
**Allowed SKUs:** Standard_B2s, Standard_D2s_v5, Standard_D4s_v5 (cost control)
**Scope:** Landing Zones MG

### 3. Enforce HTTPS for Storage Accounts
**File:** `policies/definitions/storage-https-only.json`
**Effect:** Deny
**Scope:** All subscriptions

### 4. Enforce SQL TDE
**File:** `policies/definitions/sql-tde-enabled.json`
**Effect:** DeployIfNotExists
**Scope:** All subscriptions

### 5. Diagnostic Settings to Log Analytics
**File:** `policies/definitions/diagnostic-settings-law.json`
**Effect:** DeployIfNotExists
**Parameters:** Log Analytics Workspace Resource ID
**Scope:** All subscriptions
**Resources:** VNets, NSGs, Storage Accounts, SQL Databases, Key Vaults

## Policy Initiatives

### Initiative 1: APRA CPS 234 Baseline
**File:** `policies/initiatives/apra-cps234-baseline.json`

Included policies:
1. Require tags (all 5 required tags)
2. Allowed locations (Australia East, Australia Southeast)
3. Enforce HTTPS on storage
4. Enforce SQL TDE
5. Diagnostic settings to Log Analytics
6. Require NSG on subnets
7. No public IPs on VMs (except Firewall, Bastion, App Gateway)
8. Require Defender for Cloud (all plans enabled)
9. Require MFA for privileged accounts (Entra ID policy)
10. Backup required for production VMs

**Assignment:** mg-contoso-platform and mg-contoso-landingzones

### Initiative 2: Cost Optimization
**File:** `policies/initiatives/cost-optimization.json`

Included policies:
1. Allowed VM SKUs (no expensive SKUs)
2. Detect unused resources (VMs stopped >7 days → alert)
3. Require auto-shutdown for NonProd VMs (10 PM daily)
4. No premium storage for NonProd

**Assignment:** mg-contoso-landingzones (NonProd MGs)

### Initiative 3: Network Security Baseline
**File:** `policies/initiatives/network-security-baseline.json`

Included policies:
1. NSG required on all subnets
2. DDoS Protection Standard enabled on Hub VNet
3. No public IPs except approved resources
4. Azure Firewall logging to Log Analytics
5. Private endpoints required for SQL, Storage (Prod)

**Assignment:** mg-platform-connectivity and all Landing Zones
