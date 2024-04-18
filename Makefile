.PHONY: init
init:
	terraform init

.PHONY: refresh
refresh:
	terraform refresh

.PHONY: plan
plan:
	terraform fmt && terraform validate && terraform plan -out=terraform.plan

.PHONY: apply
apply:
	terraform apply terraform.plan


.PHONY: output
output:
	terraform output

.PHONY: create-eks-cluster
create-eks-cluster:
	eksctl create cluster -f $(PWD)/test/cluster-config.yml

.PHONY: delete-eks-cluster
delete-eks-cluster:
	eksctl delete cluster -f $(PWD)/test/cluster-config.yml

.PHONY: run-check
run-check:
	pre-commit run

.PHONY: autoupdate
autoupdate:
	pre-commit autoupdate
