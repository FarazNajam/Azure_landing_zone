# Implementation Roadmap

## Phase 1: Foundation (Week 5-6)
### Week 5: Platform Subscriptions & Management Groups
- [ ] Create 3 platform subscriptions (management, connectivity, identity)
- [ ] Deploy management group hierarchy via Terraform
- [ ] Configure RBAC at MG level
- [ ] Set up Terraform remote state storage

### Week 6: Hub Network & Monitoring
- [ ] Deploy hub VNet with subnets
- [ ] Deploy Azure Firewall (Standard tier)
- [ ] Deploy Azure Bastion
- [ ] Deploy Log Analytics workspace
- [ ] Enable Sentinel
- [ ] Configure diagnostic settings for platform resources

**Milestone:** Platform infrastructure operational, ready for spoke onboarding

## Phase 2: Governance & Policies (Week 7)
- [ ] Deploy custom policy definitions
- [ ] Create policy initiatives (APRA, Cost Optimization, Network Security)
- [ ] Assign policies to management groups
- [ ] Test policy enforcement (create test resources that should be denied)
- [ ] Configure budget alerts
- [ ] Set up cost allocation tags

**Milestone:** Policy framework active, governance automated

## Phase 3: Landing Zones (Week 8-10)
### Week 8: Wealth Management Landing Zone
- [ ] Create subscriptions (Prod + NonProd)
- [ ] Deploy spoke VNets
- [ ] Configure VNet peering to hub
- [ ] Deploy UDRs for forced tunneling
- [ ] Test network connectivity (hub ↔ spoke, spoke → internet via firewall)
- [ ] Migrate 1 pilot application

### Week 9: Investment Ops Landing Zone
- [ ] Create subscriptions (Prod + NonProd)
- [ ] Deploy spoke VNets
- [ ] Onboard first trading platform application
- [ ] Configure private endpoints for SQL database

### Week 10: Corporate Services Landing Zone
- [ ] Create NonProd subscription
- [ ] Deploy spoke VNet
- [ ] Migrate HR/Finance apps

**Milestone:** All landing zones operational, dev teams self-serving

## Phase 4: Workload Migration (Week 11-12)
- [ ] Migrate remaining 15 VMs using Azure Migrate
- [ ] Migrate 8 App Services (redeploy with IaC)
- [ ] Migrate 2 SQL databases (online migration to new servers)
- [ ] Decommission old, ungoverned subscriptions
- [ ] Validate all workloads operational in new landing zones

**Milestone:** 100% workloads migrated, old environment decommissioned

## Phase 5: Optimization & Handover (Week 13-14)
- [ ] Tune Azure Firewall rules based on 2 weeks of traffic
- [ ] Optimize policy assignments (remediate vs deny where appropriate)
- [ ] Review cost reports, adjust budgets
- [ ] Train ops team on runbooks
- [ ] Conduct DR drill (failover test to secondary region)
- [ ] Document lessons learned

**Milestone:** Production-ready, team trained, continuous improvement established

## Success Criteria Checklist
- [ ] 100% resources deployed via Terraform (no manual)
- [ ] 100% policy compliance across all subscriptions
- [ ] All logs flowing to Log Analytics
- [ ] Sentinel detecting security events
- [ ] Cost allocation by business unit functional
- [ ] Dev teams successfully deploying without platform team intervention
- [ ] DR runbook tested and validated
