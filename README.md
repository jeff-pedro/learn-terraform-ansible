# Learning Terraform and Ansible with AWS provider

### Useful resources
- [Official Terraform Docs](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)
- [Official Ansible Docs](https://docs.ansible.com/ansible/latest/getting_started/index.html)


## Terraform
---
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
---
> Used to manage configurations and install programs.

1. Run
    ```
    ansible-playbook playbook.yml -u [user] --private-key [key] --hosts [host_file]
    ```
