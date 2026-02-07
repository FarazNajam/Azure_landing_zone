# Cloud Adoption Framework - Design Decisions

## 1. Azure Billing & Active Directory Tenancy
**Decision:** Single Entra ID tenant, single EA enrollment
**Rationale:** Organization size doesn't warrant multi-tenant complexity
**Implementation:**
- Tenant: contoso.onmicrosoft.com
- EA Enrollment: EA-CONTOSO-001
- Entra ID Premium P2 (required for PIM, Conditional Access)

## 2. Identity & Access Management
**Decision:** Entra ID-only (no AD DS in Azure)
**Rationale:** 
- Modern workloads don't require domain join
- Existing on-prem AD synced via Entra Connect
- Reduces infrastructure footprint and costs

**RBAC Model:**
- **Platform Team** (5 users): Owner on management groups
- **Security Team** (3 users): Security Admin on all subscriptions
- **Business Unit Leads** (3 users): Contributor on their app subscriptions
- **Developers** (30 users): Contributor on Dev/Test, Reader on Prod

**Privileged Access:**
- Entra ID PIM for all Owner/Contributor roles
- Maximum 8-hour elevation
- Approval required for production subscriptions

## 3. Management Group Hierarchy
**Decision:** Business-unit aligned with platform separation
```
Tenant Root Group
├── mg-contoso-platform (Platform services)
│   ├── mg-platform-management (Monitoring, automation)
│   ├── mg-platform-connectivity (Networking hub)
│   └── mg-platform-identity (Future: AD DS if needed)
├── mg-contoso-landingzones (Workload subscriptions)
│   ├── mg-lz-wealthmanagement (Wealth Management BU)
│   │   ├── mg-lz-wm-prod
│   │   └── mg-lz-wm-nonprod
│   ├── mg-lz-investmentops (Investment Operations BU)
│   │   ├── mg-lz-io-prod
│   │   └── mg-lz-io-nonprod
│   └── mg-lz-corporate (Corporate Services)
│       ├── mg-lz-corp-prod
│       └── mg-lz-corp-nonprod
└── mg-contoso-sandbox (Temporary dev/test, auto-deleted after 30 days)
```

**Rationale:**
- Clear separation of platform vs workloads
- Business unit isolation for cost tracking and security boundaries
- Prod/NonProd split enforces different policies
- Sandbox for experimentation without impacting production

## 4. Subscription Organization
**Initial Subscriptions (8 total):**

**Platform Subscriptions:**
1. `sub-platform-management-prod` - Log Analytics, Sentinel, Automation
2. `sub-platform-connectivity-prod` - Hub VNet, Firewall, VPN
3. `sub-platform-identity-prod` - (Reserved for future AD DS)

**Landing Zone Subscriptions:**
4. `sub-lz-wealthmanagement-prod` - Production wealth management apps
5. `sub-lz-wealthmanagement-nonprod` - Dev/Test environments
6. `sub-lz-investmentops-prod` - Trading platforms production
7. `sub-lz-investmentops-nonprod` - Trading dev/test
8. `sub-lz-corporate-nonprod` - Corporate apps (HR, Finance)

**Naming Convention:**
`sub-{platform|lz}-{businessunit|function}-{env}`

**Subscription Limits Consideration:**
- Start with 8, design supports scaling to 50+ subscriptions
- Each BU can request additional subscriptions via self-service pipeline

## 5. Network Topology & Connectivity
**Decision:** Hub-and-spoke with Azure Firewall

**Hub VNet (sub-platform-connectivity-prod):**
- `vnet-hub-aue-prod` (10.100.0.0/16) in Australia East
- Subnets:
  - `AzureFirewallSubnet` (10.100.0.0/26) - Azure Firewall
  - `GatewaySubnet` (10.100.1.0/27) - VPN/ExpressRoute gateway
  - `AzureBastionSubnet` (10.100.2.0/26) - Bastion for secure VM access
  - `snet-management` (10.100.10.0/24) - Jump boxes, management VMs

**Spoke VNets (each landing zone subscription):**
- Wealth Management Prod: `vnet-spoke-wm-aue-prod` (10.10.0.0/16)
- Wealth Management NonProd: `vnet-spoke-wm-aue-nonprod` (10.11.0.0/16)
- Investment Ops Prod: `vnet-spoke-io-aue-prod` (10.20.0.0/16)
- Investment Ops NonProd: `vnet-spoke-io-aue-nonprod` (10.21.0.0/16)
- Corporate NonProd: `vnet-spoke-corp-aue-nonprod` (10.30.0.0/16)

**Connectivity Rules:**
- All spoke egress traffic routes through Azure Firewall (forced tunneling)
- No spoke-to-spoke direct peering (must go through firewall)
- Private endpoints for PaaS services (SQL, Storage, Key Vault)
- No public IPs on VMs (access via Bastion only)

**DNS:**
- Azure Private DNS zones hosted in hub subscription
- Linked to all spoke VNets
- Zones: privatelink.database.windows.net, privatelink.blob.core.windows.net, etc.

## 6. Security & Compliance (APRA CPS 234)
**Decision:** Policy-driven governance with automated remediation

**Key Policies (custom + built-in):**
1. **Allowed Locations:** Australia East, Australia Southeast only
2. **Allowed Resources:** Whitelist of approved services (no VMs > D4s_v5, no public IPs on VMs)
3. **Encryption:** Enforce encryption at rest and in transit
   - Storage accounts must use HTTPS
   - SQL databases must have TDE enabled
   - Disk encryption required for all VMs
4. **Tagging:** Require tags: `CostCenter`, `BusinessUnit`, `Environment`, `Owner`, `DataClassification`
5. **Monitoring:** Diagnostic settings enforced for all resources → Log Analytics
6. **Network Security:** 
   - NSGs required on all subnets
   - No public IPs except on Azure Firewall, Bastion, App Gateway
7. **Defender for Cloud:** Enable all plans (Servers, SQL, Storage, Key Vault)

**Compliance Frameworks:**
- CIS Microsoft Azure Foundations Benchmark
- APRA CPS 234 (custom initiative)
- ISO 27001 (where applicable)

**Implementation:**
- Assign at management group level (inherited by all subscriptions)
- Deny effect for critical policies (allowed locations, encryption)
- Audit effect for cost optimization policies (unused resources)
- DeployIfNotExists for monitoring (auto-deploy diagnostic settings)

## 7. Management & Monitoring
**Decision:** Centralized Log Analytics workspace with Sentinel

**Log Analytics Workspace:**
- `law-contoso-platform-aue-prod` in sub-platform-management-prod
- Retention: 90 days online, 1 year archived to storage
- Data sources:
  - Azure Activity Logs from all subscriptions
  - Diagnostic logs from all resources
  - Security logs from Defender for Cloud
  - Firewall logs
  - VM OS logs (Windows Event Logs, Syslog)

**Microsoft Sentinel:**
- Enable on same workspace
- Analytics rules:
  - Failed login attempts (>5 in 10 minutes)
  - Privilege escalation detection
  - Suspicious Azure activity (resources created outside allowed locations)
  - Data exfiltration (large blob downloads)
- Playbooks: Auto-disable compromised accounts, alert security team via Teams

**Azure Monitor:**
- Action Group: Email + Teams webhook to security team
- Alerts:
  - Azure Firewall rule hits (anomalies)
  - Budget exceeded (>80% of $50K/month)
  - Policy compliance <95%
  - VM CPU >90% for 15 minutes

**Update Management:**
- Automation Account in management subscription
- Maintenance windows: 
  - Prod: Sunday 2-4 AM AEST
  - NonProd: Saturday 2-4 AM AEST
- Automatic patching for critical updates

## 8. Business Continuity & Disaster Recovery
**Decision:** Azure-native DR with tiered RTO/RPO

**Tiers:**
- **Tier 0 (Platform):** RTO = 1 hour, RPO = 0 (HA required)
  - Azure Firewall: Zone-redundant deployment in primary region
  - Log Analytics: Geo-redundant (Azure-managed)
  
- **Tier 1 (Wealth Management Prod):** RTO = 4 hours, RPO = 1 hour
  - SQL: Auto-failover groups to Australia Southeast
  - App Services: Deployment slots + Traffic Manager for cross-region
  - VMs: Azure Site Recovery to secondary region
  
- **Tier 2 (Investment Ops Prod):** RTO = 8 hours, RPO = 4 hours
  - SQL: Geo-replication (manual failover)
  - VMs: Daily Azure Backup, restore to secondary if needed
  
- **Tier 3 (NonProd):** RTO = 24 hours, RPO = 24 hours
  - IaC re-deployment to secondary region
  - No backup (recreate from code)

**Backup Strategy:**
- Azure Backup for all production VMs (daily)
- SQL point-in-time restore (35 days)
- Storage accounts: GRS for production data, LRS for non-prod

## 9. Platform Automation & DevOps
**Decision:** Terraform with Azure DevOps pipelines

**IaC Approach:**
- **Terraform** for all infrastructure (modules for reusability)
- **Azure DevOps** for CI/CD pipelines
- **Remote state** in Azure Storage (GRS, blob versioning enabled)

**Repository Structure:**
```
contoso-azure-landing-zone/
├── terraform/
│   ├── modules/           # Reusable modules
│   │   ├── management-group/
│   │   ├── subscription/
│   │   ├── hub-network/
│   │   ├── spoke-network/
│   │   └── policy/
│   └── environments/      # Environment-specific configs
│       ├── platform/
│       │   ├── management/
│       │   └── connectivity/
│       └── landing-zones/
│           ├── wealthmanagement-prod/
│           └── investmentops-prod/
```

**Pipeline Stages:**
1. Validate (terraform fmt, tflint, Checkov security scan)
2. Plan (terraform plan, output stored as artifact)
3. Approval (manual gate for production)
4. Apply (terraform apply)

**State Management:**
- Backend: Azure Storage Account with versioning
- Locking: Azure Blob lease
- Separate state file per environment/subscription

## 10. Resource Organization & Tagging
**Decision:** Subscription-per-environment, tags for cost allocation

**Resource Naming Convention:**
`{resource-type}-{appname}-{env}-{region}-{instance}`

Examples:
- `vnet-hub-prod-aue-001`
- `law-platform-prod-aue-001`
- `sql-clientportal-prod-aue-001`

**Required Tags (enforced via policy):**
| Tag | Values | Purpose |
|-----|--------|---------|
| CostCenter | CC001-CC050 | Chargeback |
| BusinessUnit | WealthManagement, InvestmentOps, Corporate | Cost allocation |
| Environment | Prod, Dev, Test, Sandbox | Lifecycle management |
| Owner | Email address | Accountability |
| DataClassification | Public, Internal, Confidential, Restricted | Security controls |
| Application | AppName | Logical grouping |
| Criticality | Tier0, Tier1, Tier2, Tier3 | BCDR priority |

**Cost Management:**
- Budgets set per subscription (80% alert, 100% email to finance)
- Cost analysis by BusinessUnit tag
- Unused resources detected via policy (VMs stopped >7 days)
