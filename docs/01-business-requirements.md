# Contoso Financial Services - Business Requirements

## Company Overview
- **Industry:** Wealth Management & Financial Advisory
- **Size:** 450 employees, $2.1B AUM
- **Current State:** 3 Azure subscriptions, no governance, manual deployments
- **Regulatory:** APRA CPS 234 compliance required

## Business Units
1. **Wealth Management** (200 staff) - client-facing applications
2. **Investment Operations** (150 staff) - trading platforms, risk systems
3. **Corporate Services** (100 staff) - HR, Finance, IT

## Business Drivers
1. APRA CPS 234 compliance deadline: 6 months
2. Reduce cloud costs by 30% through governance
3. Enable self-service for dev teams while maintaining security
4. Support DR/BCP with RTO ≤ 4 hours, RPO ≤ 1 hour

## Technical Requirements
- Multi-subscription model with environment separation (Dev/Test/Prod)
- Centralized logging and security monitoring
- Network segmentation between business units
- Automated policy enforcement (no manual compliance checks)
- Infrastructure as Code for all deployments
- Hub-spoke network topology with centralized egress

## Constraints
- Budget: $50K/month Azure spend
- Timeline: 12 weeks to production
- Regions: Australia East (primary), Australia Southeast (DR)
- Existing workloads: 15 VMs, 8 App Services, 2 SQL databases (must migrate into landing zone)

## Success Criteria
- Zero manual deployments (100% IaC)
- 100% policy compliance within 30 days
- All logs centralized to Log Analytics
- Dev teams can deploy to their subscriptions within 2 hours of request
