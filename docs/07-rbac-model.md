# Role-Based Access Control Model

## Design Principles
1. **Least Privilege:** Users get minimum permissions needed
2. **Separation of Duties:** No single person has end-to-end control
3. **Just-In-Time Access:** Use PIM for elevated roles
4. **Role-Based, Not User-Based:** Assign to groups, not individuals

## Azure Built-In Roles Used
- **Owner:** Full access including RBAC management
- **Contributor:** Full access except RBAC
- **Reader:** Read-only access
- **Network Contributor:** Manage network resources
- **Security Admin:** Manage security policies
- **Log Analytics Contributor:** Manage Log Analytics

## Custom Roles

### Landing Zone Subscription Creator
**Purpose:** Allow platform team to create new subscriptions without full Owner
**Assignable Scopes:** mg-contoso-landingzones
**Permissions:**
```json
{
  "Name": "Landing Zone Subscription Creator",
  "IsCustom": true,
  "Description": "Can create and configure new landing zone subscriptions",
  "Actions": [
    "Microsoft.Subscription/subscriptions/write",
    "Microsoft.Management/managementGroups/write",
    "Microsoft.Authorization/roleAssignments/write",
    "Microsoft.Resources/subscriptions/resourceGroups/write"
  ],
  "NotActions": [],
  "AssignableScopes": [
    "/providers/Microsoft.Management/managementGroups/mg-contoso-landingzones"
  ]
}
```

### Policy Contributor (Read-Only)
**Purpose:** Allow security team to review policies without modification
**Assignable Scopes:** Tenant Root
**Permissions:**
```json
{
  "Name": "Policy Reader",
  "IsCustom": true,
  "Description": "Can view policy definitions, assignments, and compliance but not modify",
  "Actions": [
    "Microsoft.Authorization/policyDefinitions/read",
    "Microsoft.Authorization/policyAssignments/read",
    "Microsoft.Authorization/policySetDefinitions/read",
    "Microsoft.PolicyInsights/policyStates/queryResults/read"
  ],
  "NotActions": [],
  "AssignableScopes": [
    "/providers/Microsoft.Management/managementGroups/mg-contoso"
  ]
}
```

## RBAC Assignments by Management Group

### mg-contoso (Tenant Root)
| Group | Role | Scope | PIM Required | Max Duration |
|-------|------|-------|--------------|--------------|
| AAD-CloudPlatform-Owners | Owner | mg-contoso | Yes | 8 hours |
| AAD-Security-Admins | Security Admin | mg-contoso | No | N/A |
| AAD-Compliance-Readers | Reader | mg-contoso | No | N/A |

### mg-contoso-platform
| Group | Role | Scope | PIM Required | Max Duration |
|-------|------|-------|--------------|--------------|
| AAD-Platform-Team | Contributor | mg-contoso-platform | No | N/A |
| AAD-Network-Admins | Network Contributor | mg-platform-connectivity | No | N/A |

### mg-contoso-landingzones
| Group | Role | Scope | PIM Required | Max Duration |
|-------|------|-------|--------------|--------------|
| AAD-Platform-Team | Landing Zone Subscription Creator | mg-contoso-landingzones | No | N/A |

### mg-lz-wealthmanagement-prod
| Group | Role | Scope | PIM Required | Max Duration |
|-------|------|-------|--------------|--------------|
| AAD-WM-AppTeam-Leads | Contributor | mg-lz-wealthmanagement-prod | Yes | 8 hours |
| AAD-WM-AppTeam-Devs | Reader | mg-lz-wealthmanagement-prod | No | N/A |
| AAD-WM-BU-Manager | Reader | mg-lz-wealthmanagement-prod | No | N/A |

### mg-lz-wealthmanagement-nonprod
| Group | Role | Scope | PIM Required | Max Duration |
|-------|------|-------|--------------|--------------|
| AAD-WM-AppTeam-Leads | Contributor | mg-lz-wealthmanagement-nonprod | No | N/A |
| AAD-WM-AppTeam-Devs | Contributor | mg-lz-wealthmanagement-nonprod | No | N/A |

*Repeat for other business units...*

## Service Principal RBAC (for automation)

| Service Principal | Role | Scope | Purpose |
|-------------------|------|-------|---------|
| sp-terraform-platform | Contributor | mg-contoso-platform | Deploy platform infrastructure |
| sp-terraform-landingzones | Contributor | mg-contoso-landingzones | Deploy landing zone subscriptions |
| sp-ado-pipeline-prod | Contributor | Prod subscriptions only | Production deployments via ADO |
| sp-ado-pipeline-nonprod | Contributor | NonProd subscriptions | NonProd deployments via ADO |
| sp-sentinel-playbooks | Security Admin | sub-platform-management-prod | Sentinel automated responses |

## Entra ID Groups to Create

| Group Name | Members (initial) | Purpose |
|------------|-------------------|---------|
| AAD-CloudPlatform-Owners | platform-lead@contoso.com, azure-admin@contoso.com | Platform-wide ownership |
| AAD-Platform-Team | 5 platform engineers | Day-to-day platform management |
| AAD-Network-Admins | 2 network engineers | Network infrastructure |
| AAD-Security-Admins | 3 security analysts | Security monitoring and policy |
| AAD-WM-AppTeam-Leads | wm-lead@contoso.com | Wealth Management app team lead |
| AAD-WM-AppTeam-Devs | 5 developers | Wealth Management developers |
| AAD-IO-AppTeam-Leads | io-lead@contoso.com | Investment Ops team lead |
| AAD-IO-AppTeam-Devs | 8 developers | Investment Ops developers |

## PIM Configuration

### Activation Requirements
- **Prod subscriptions:** Require approval from BU manager + MFA
- **Platform subscriptions:** Require MFA only (auto-approve)
- **NonProd subscriptions:** No PIM (standing access)

### Notification Settings
- **Activation:** Email to resource owner + security team
- **Expiration warning:** Email 1 hour before access expires
- **Denied activation:** Email to requestor with reason

### Audit
- All PIM activations logged to Log Analytics
- Sentinel alert rule: >3 PIM activations in 1 hour by same user
