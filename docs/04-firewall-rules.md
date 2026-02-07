# Azure Firewall Rules

## Network Rules (Layer 3/4)

### Rule Collection: Allow-Hub-to-Spokes
Priority: 100
Action: Allow

| Name | Source | Destination | Protocol | Ports | Purpose |
|------|--------|-------------|----------|-------|---------|
| Allow-Management-to-All | 10.100.10.0/24 | 10.0.0.0/8 | Any | * | Management access |

### Rule Collection: Allow-Spoke-to-Internet
Priority: 200
Action: Allow

| Name | Source | Destination | Protocol | Ports | Purpose |
|------|--------|-------------|----------|-------|---------|
| Allow-HTTPS | 10.0.0.0/8 | * | TCP | 443 | Outbound HTTPS |
| Allow-DNS | 10.0.0.0/8 | * | UDP | 53 | DNS queries |
| Allow-NTP | 10.0.0.0/8 | * | UDP | 123 | Time sync |

## Application Rules (Layer 7)

### Rule Collection: Allow-Azure-Services
Priority: 100
Action: Allow

| Name | Source | Target FQDNs | Protocol:Port | Purpose |
|------|--------|--------------|---------------|---------|
| Allow-AzureAD | 10.0.0.0/8 | login.microsoftonline.com, *.login.microsoft.com | HTTPS:443 | Entra ID authentication |
| Allow-Azure-Storage | 10.0.0.0/8 | *.blob.core.windows.net, *.queue.core.windows.net | HTTPS:443 | Azure Storage |
| Allow-Azure-Monitor | 10.0.0.0/8 | *.ods.opinsights.azure.com, *.oms.opinsights.azure.com | HTTPS:443 | Log Analytics |

### Rule Collection: Allow-External-Services
Priority: 200
Action: Allow

| Name | Source | Target FQDNs | Protocol:Port | Purpose |
|------|--------|--------------|---------------|---------|
| Allow-Ubuntu-Updates | 10.0.0.0/8 | *.ubuntu.com, *.canonical.com | HTTPS:443, HTTP:80 | Linux updates |
| Allow-Windows-Updates | 10.0.0.0/8 | *.windowsupdate.com, *.update.microsoft.com | HTTPS:443 | Windows updates |
| Allow-GitHub | 10.0.0.0/8 | github.com, *.github.com | HTTPS:443 | Source control |

## DNAT Rules (Inbound)
*None initially - all inbound goes through Application Gateway in spoke*
