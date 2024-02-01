# Learning Terraform and Ansible with AWS provider

> This repository deploy a simple API. Building the infrastructure, installation and dependencies necessary to run the web server.

### Applied Concepts

- Separation of environments: Production and Dev
- Elastic Infrastructure
- Suspend Machines
- Load Test with [Locust](https://locust.io/)

### Useful resources

- [Official Terraform Docs](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)
- [Official Ansible Docs](https://docs.ansible.com/ansible/latest/getting_started/index.html)

## Terraform

> Used to deploy the infrastructure.

### Initialize the configuration directory

```
terraform init
```

### Check and validate format code

```
terraform fmt
terraform validate
```

### Create infrastructure

1. Show the plan

   ```
   terraform plan
   ```

2. Apply changes

   ```
   terraform apply
   ```

3. Destroy resources
   ```
   terraform destroy
   ```

## Ansible

> Used to manage configurations and install programs.

1. Run
   ```
   ansible-playbook playbook.yml -u [user] --private-key [key] --hosts [host_file]
   ```

## Deploy Production

---

1. Go to
   ```
   cd ./env/Prod
   ```
2. Check
   ```
   terraform plan
   ```
3. Deploy
   ```
   terraform apply
   ```

**Web Interface**

> http://<server_ip | loadbalancer_dns>:**8000**

## Deploy Dev

---

1. Go to
   ```
   cd ./env/Dev
   ```
2. Check
   ```
   terraform plan
   ```
3. Deploy Infrastruture
   ```
   terraform apply
   ```
4. Deploy API
   ```
   ansible-playbook playbook.yml -u ubuntu --private-key IaC-DEV  --hosts ../../infra/hosts.yml
   ```

**Web Interface**

> http://<server_ip>:**8000**

## Load Test

```
locust -f ./load.py
```

**Web Interface**

> http://0.0.0.0:8089