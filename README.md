# Infraestructure-sample-AWS
proyecto de ejemplo de infraestructura en AWS con escalabilidad, alta disponibilidad y seguridad con minimo privilegio

---

## Comandos de despliegue

# DEV
```bash
cd IAC/terraform/live/dev
terraform init -backend-config=../../env/dev/backend.tfvars
terraform plan -var-file=../../env/dev/terraform.tfvars -out tfplan
terraform apply tfplan
```

# PROD
```bash
cd IAC/terraform/live/prod
terraform init -backend-config=../../env/prod/backend.tfvars
terraform plan -var-file=../../env/prod/terraform.tfvars -out tfplan
terraform apply tfplan
```