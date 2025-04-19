
# Jenkins on Kubernetes with Helm (Master + Agent Setup)

## 🧰 Prerequisites

- install HELM
- setup kind / minikube / k8s  cluster
- install docker

## ⎈ Add Jenkins Helm Repo & Update

```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

## 📁 Create Namespace

```bash
kubectl create ns jenkins
```

## 📦 Create `values.yaml` with Plugin + Agent Setup

```yaml
controller:
  installPlugins:
    - kubernetes
    - workflow-aggregator
    - git
    - credentials-binding
    - blueocean

  JCasC:
    enabled: true
    configScripts:
      welcome-message: |
        jenkins:
          systemMessage: "Jenkins running on KinD 🚀"

  resources:
    requests:
      cpu: "100m"
      memory: "512Mi"
    limits:
      cpu: "500m"
      memory: "1Gi"

  serviceType: ClusterIP

agent:
  enabled: true
  image:
    repository: jenkins/inbound-agent
    tag: alpine
  resources:
    requests:
      cpu: "100m"
      memory: "256Mi"
    limits:
      cpu: "200m"
      memory: "512Mi"

```

Save as: `values.yaml`

## 🚀 Install Jenkins via Helm

```bash
helm install jenkins jenkins/jenkins -n jenkins -f values.yaml
```

## 🔑 Get Admin Password

```bash
kubectl get secret jenkins -n jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

## 🌐 Port Forward and Access Jenkins UI

```bash
kubectl port-forward svc/jenkins -n jenkins 8080:8080
# Access: http://localhost:8080
```

## ✅ Test Pipeline (Create in Jenkins UI)

```groovy
pipeline {
  agent any
  stages {
    stage('Hello') {
      steps {
        echo 'Jenkins is running with agent!'
      }
    }
  }
}
```

## 🧼 Cleanup

```bash
kind delete cluster --name jenkins-cluster
```

