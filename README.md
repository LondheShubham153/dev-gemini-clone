# Advanced Gemini Clone with Kubernetes Setup

![Gemini Clone Logo](public/assets/readme-banner.png)

An advanced Gemini Clone built with Next.js, featuring enhanced functionality and faster response times.

---

## Purpose

Follow this guide to set up a DevSecOps-ready Google Gemini Clone if you cannot afford the AWS EKS bill and associated costs.

---

## Important Notes

- **Replace** `<INSTANCE_PUBLIC_IP>` with your actual instance IP address.  

---

## Prerequisites for Kubernetes & ArgoCD

- **Docker** installed and configured  
- **Kind** (Kubernetes in Docker)  
- **kubectl**  
- **aws-cli** (with `aws configure` completed)

---

## 1. Create the Kind Cluster

Create your cluster using the following command with your custom configuration (stored in `kind-config.yml`):

```bash
kind create cluster --name gemini-cluster --config kind-config.yml
```

---

## 2. Install ArgoCD in the Cluster

Create the ArgoCD namespace and install ArgoCD using the official manifests:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

ArgoCD’s server is exposed as a NodePort service (e.g., port mappings such as `80:30446/TCP` or `443:30884/TCP`). You can access its UI via your public IP.

---

## 3. Update Kubeconfig for External API Access

By default, Kind uses a self-signed certificate for internal IPs. Update your kubeconfig so the external API server becomes reachable and bypasses TLS verification:

```bash
kubectl config get-contexts

kubectl config set-cluster kind-gemini-cluster \
  --server=https://<INSTANCE_PUBLIC_IP>:45577 \
  --insecure-skip-tls-verify=true

kubectl config set-context kind-gemini-cluster-external \
  --cluster=kind-gemini-cluster \
  --user=kind-gemini-cluster

kubectl config use-context kind-gemini-cluster-external
```

After these commands, your kubeconfig (context `kind-gemini-cluster-external`) will point to `https://<INSTANCE_PUBLIC_IP>:45577` and ignore TLS issues.

---

## 4. Log In to ArgoCD via the Public NodePort

Since the ArgoCD service is now exposed on a NodePort, perform the following steps to log in:

1. Patch the ArgoCD service to expose it as NodePort:
   ```bash
   kubectl patch svc argocd-server -n argocd -p '{"spec":{"type": "NodePort"}}'
   kubectl get svc -n argocd
   ```
2. Port-forward the ArgoCD server to expose it on a specific NodePort (example using port `32540`):
   ```bash
   kubectl port-forward --address 0.0.0.0 svc/argocd-server <NodePort_OF_ARGOCD_SERVER>:80 -n argocd &
   ```
3. Access ArgoCD via `<INSTANCE_PUBLIC_IP>:<NodePort_OF_ARGOCD_SERVER>`.  
4. Retrieve the initial admin password:
   ```bash
   kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
   ```
5. After logging in to the ArgoCD UI, change the admin password.  
6. Log in via the CLI with:
   ```bash
   argocd login <INSTANCE_PUBLIC_IP>:<NodePort_OF_ARGOCD_SERVER> --username admin --insecure
   ```

---

## 5. Add the External Kind Cluster to ArgoCD

With your kubeconfig and ArgoCD login set up, add your external Kind cluster to ArgoCD using:

```bash
argocd cluster add kind-gemini-cluster-external --name gemini-cluster --insecure
```

This command creates (or updates) the `argocd-manager` service account on the target cluster. To verify, run:

```bash
argocd cluster list
```

The output should list two clusters:  
- The **in-cluster** cluster (`https://kubernetes.default.svc`)  
- Your external Kind cluster (`https://<INSTANCE_PUBLIC_IP>:45577`) identified as **gemini-cluster** with status **Successful**.

---

## 6. Additional Setup

### 6.1 Add a Repository in ArgoCD

- Go to the ArgoCD UI.  
- Add your repository in the settings.

### 6.2 Install Helm

Download and install Helm using the following commands:

```bash
# Download the Helm installation script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# Make the script executable
chmod 700 get_helm.sh

# Run the installation script
./get_helm.sh
```

### 6.3 Install Ingress-NGINX

Deploy Ingress-NGINX using this command:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

### 6.4 Install Metrics Server

Apply the components for the metrics server:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Then edit the metrics server deployment to add necessary arguments:

```bash
kubectl -n kube-system edit deployment metrics-server
```

Add these arguments under `spec.containers.args`:
- `--kubelet-insecure-tls`
- `--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname`

Save the changes, then restart and verify the deployment:

```bash
kubectl -n kube-system rollout restart deployment metrics-server
kubectl get pods -n kube-system
kubectl top nodes
```

### 6.5 Install Cert-Manager for SSL/TLS

Deploy Cert-Manager with the following command:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.2/cert-manager.yaml
```

---

## 7. Create an Application in ArgoCD

After completing the setup, create a new application in ArgoCD with the following details:

### **General Section**

- **Application Name:** Choose a name for your application.  
- **Project Name:** Select _default_.  
- **Sync Policy:** Set to _Automatic_.  
  - Enable **Prune Resources** and **Self-Heal**.  
  - Check **Auto Create Namespace**.

### **Source Section**

- **Repo URL:** Enter the URL of your Git repository.  
- **Revision:** Select the branch (e.g., `kind`).  
- **Path:** Specify the directory containing your Kubernetes manifests (e.g., `kind`).

### **Destination Section**

- **Cluster:** Select your desired cluster.  
- **Namespace:** Use `gemini-namespace`.

Click **Create App**. Once the application is healthy, you can access it at `<INSTANCE_PUBLIC_IP>.nip.io`. For this to work, ensure the following:

- Your `configmap.yml` file has `NEXTAUTH_URL` set to `<INSTANCE_PUBLIC_IP>.nip.io`.  
- The Ingress configuration specifies the host and TLS settings to use `<INSTANCE_PUBLIC_IP>.nip.io`.

---
