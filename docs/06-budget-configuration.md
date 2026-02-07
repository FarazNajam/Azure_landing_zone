# Budget Configuration

## Subscription-Level Budgets

### Platform Subscriptions
- **sub-platform-management-prod:** $2,000/month
  - Alert at 80% ($1,600): Email platform team
  - Alert at 100% ($2,000): Email platform team + finance

- **sub-platform-connectivity-prod:** $1,800/month
  - Alert at 80% ($1,440): Email network team
  - Alert at 100% ($1,800): Email network team + finance

### Landing Zone Subscriptions
- **sub-lz-wealthmanagement-prod:** $2,500/month
  - Alert at 80% ($2,000): Email app team lead
  - Alert at 90% ($2,250): Email BU manager
  - Alert at 100% ($2,500): Email BU manager + finance + CTO

- **sub-lz-wealthmanagement-nonprod:** $1,200/month
  - Alert at 100% ($1,200): Email app team lead

*Repeat for other landing zones...*

## Management Group Level Budget
- **mg-contoso-landingzones:** $10,000/month (all workload subscriptions combined)
  - Alert at 80% ($8,000): Email to finance team
  - Alert at 100% ($10,000): Email to CFO + CTO

## Cost Anomaly Detection
- Enable Azure Cost Management anomaly alerts
- Threshold: $500 unexpected increase in 24 hours
- Alert: Email to platform team + finance
