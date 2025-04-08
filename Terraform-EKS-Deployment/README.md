# AWS EKS Cluster Deployment Using Terraform 

## Steps to implement:

- Set Up Terraform 
    - Install Terraform: Make sure Terraform is installed on your system. If not, <a href="https://github.com/DevMadhup/DevOps-Tools-Installations/blob/main/Terraform/terraform.sh">click</a> here to install.

- In the current directory you will see all the `.tf` files


- Initialize the terraform project
```bash
terraform init
```

- Validate the configuration
```bash
terraform validate
```

- Preview the infrastructure changes
```bash
terraform plan
```

- Apply the changes
```bash
terraform apply --auto-approve
```

- Update your kubeconfig file to connect to the EKS cluster
```bash
aws eks --region eu-west-1 update-kubeconfig --name gemini-eks-cluster
```

- Verify the cluster connection
```bash
kubectl get nodes
```
