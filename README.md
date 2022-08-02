## Onboarding Repo

## Details

This repo has been created to manage onboarding of clients from a central location.

The repo contains.

- IAM
- AWS BACKUP
- Patch Manager
- Patch Alerting
- AWS BUDGETS
- Gitlab runner

each repo can be deployed centrally but requires the following variables


this repo will use a gitlab runner with varibles sent from customer central

## Usage

```hcl
module "onboarding" {
  source  = "shadbury/onboarding/aws"
  version = "1.0.0"
  
}
```
