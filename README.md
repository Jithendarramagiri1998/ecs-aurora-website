# 🚀 Deploying a Website on AWS ECS with Aurora using Terraform

## 🧭 Overview

This project demonstrates a **complete DevOps setup** where a **containerized website** is deployed on **Amazon ECS (Fargate)** backed by an **Amazon Aurora Database Cluster**, with all infrastructure provisioned using **Terraform (Infrastructure as Code - IaC)**.

It follows **best practices** for:
- Environment isolation (Dev & Staging)
- High availability and scalability
- Secure networking and IAM policies
- Centralized logging and monitoring using CloudWatch

---

## 🎯 Project Goals / Requirements

1. Use **Terraform** for Infrastructure as Code (IaC) to provision AWS resources.  
2. Deploy the **website on Amazon ECS** using the **Fargate launch type**.  
3. Set up an **Aurora Database Cluster** with **multi-AZ availability** for fault tolerance.  
4. Implement **separate environments** for **Development** and **Staging**.  
5. Configure **Route53** for domain routing for both environments.  
6. Integrate **CloudWatch** for logging and monitoring (ECS & Aurora).  
7. Ensure **secure configurations** — proper **VPC**, **subnet isolation**, **security groups**, and **restricted database access**.

---

## 🏗️ Architecture Overview

```plaintext
                    ┌────────────────────────┐
                    │        Route53         │
                    │ dev.myapp.com          │
                    │ staging.myapp.com      │
                    └──────────┬─────────────┘
                               │
                          ┌────▼────┐
                          │  ALB    │
                          └────┬────┘
                               │
                      ┌────────▼────────┐
                      │ ECS Fargate     │
                      │ (Web Containers)│
                      └────────┬────────┘
                               │
                      ┌────────▼────────┐
                      │  Aurora Cluster │
                      │ (Multi-AZ RDS)  │
                      └─────────────────┘
                               │
                      ┌────────▼────────┐
                      │ CloudWatch + SNS│
                      │  Alerts & Logs  │
                      └─────────────────┘
```
---

## 🧩 **Project Structure**

```plaintext
app
├── Dockerfile
├── index.html

scripts
├── build_and_push_ecr.sh
├── deploy_full.sh
├── ecs_deploy.sh

terraform
├── envs
│ ├── dev
│ │ ├── backend.tf
│ │ └── main.tf
│ ├── staging
│ │ ├── backend.tf
│ │ └── main.tf
│ └── global
│ └── backend
│ └── main.tf
└── modules
├── aurora
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── cloudwatch
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── ecs
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── route53
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── sns
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
└── vpc
├── main.tf
├── outputs.tf
└── variables.tf
```

---

## ⚙️ **Prerequisites**

* **AWS Account** with IAM permissions
* **Terraform ≥ v1.5**
* **AWS CLI** configured (`aws configure`)
* **Docker** installed locally
* **Domain registered in Route53 (optional)** for DNS setup

---

## 🪜 **option-1 Setup Steps to deploy with shell script below**

### 1️⃣ Clone the Repository

```bash
git clone https://github.com//project-22-ecs-aurora.git
cd project-22-ecs-aurora
```

### 2️⃣ Initialize Terraform (Dev Environment)

```bash
cd environments/dev
terraform init
terraform plan
terraform apply -auto-approve
```

This provisions **VPC**, **ECS Cluster**, **AuroraDB**, **Route53 records**, **CloudWatch metrics**, and **SNS alerts**.

### 3️⃣ Initialize Terraform (Staging Environment)

```bash
cd ../staging
terraform init
terraform plan
terraform apply -auto-approve
```

Separate resources for **staging** environment with isolated networking, ECS cluster, and AuroraDB.

---

## 🐳 **Build & Push Docker Image**

Use the helper script to build and push your website container image to **ECR**:

```bash
cd scripts
chmod +x build_and_push_ecr.sh
./build_and_push_ecr.sh
```

---

## 🚢 **Deploy ECS Service**

After pushing the Docker image, update ECS service with the new image:

```bash
./ecs_deploy.sh
```

---

## 🌐 **Access the Website**

After deployment:

* **Dev:** [https://dev.myapp.example.com](https://dev.myapp.example.com)
* **Staging:** [https://staging.myapp.example.com](https://staging.myapp.example.com)

Both environments are isolated with different ECS, Aurora, and VPC setups.

---

## 🔒 **Security Highlights**

✅ Aurora hosted in private subnets (no public access)
✅ ECS tasks communicate via internal SG rules
✅ IAM least privilege enforced for ECS tasks and Terraform
✅ Encrypted Aurora cluster (KMS key used)
✅ HTTPS via ALB + Route53

---

## 📈 **Monitoring & Alerts**

* **CloudWatch Logs** → ECS task/application logs
* **CloudWatch Alarms** → Aurora CPU, Memory, Disk usage
* **SNS Topic** → Sends alert emails for threshold breaches

---

## 🧱 **Environment Separation**

Each environment (**dev**, **staging**) has:

* Own VPC, Subnets, Route Tables
* Independent ECS Cluster
* Separate AuroraDB Cluster
* Dedicated CloudWatch Log Groups & Alarms
* Distinct Route53 DNS records

This ensures no overlap or cross-environment impact.

---

## 🧹 **Cleanup**

To destroy the environment and avoid charges:

```bash
terraform destroy -auto-approve
```

---

## 🪜 **Option-2 Setup Steps to deploy with jenkins CI/CD flow**

---

# 🚀 Project Overview

## 🎯 Goal

Deploy a sample HTML website using:

- **Terraform** → to provision AWS infrastructure  
- **Jenkins** → to automate CI/CD pipeline  
- **AWS ECS (Fargate)** → to host the containerized web app  
- **AWS ECR** → to store Docker images  
- **CloudWatch** → for monitoring and logs
---
# 🧩 Project Components

| Component     | Purpose                                      |
|----------------|----------------------------------------------|
| **index.html** | Sample web page                              |
| **Dockerfile** | Builds the website image                     |
| **Terraform**  | Creates ECS, VPC, ECR, ALB, etc.             |
| **Jenkinsfile**| Defines the CI/CD pipeline                   |
| **AWS**        | Target cloud platform (ECS Fargate)          |

---

## 🧩 **Project Structure**

```plaintext
app
├── Dockerfile
├── index.html

scripts
├── build_and_push_ecr.sh
├── deploy_full.sh
├── ecs_deploy.sh

terraform
├── envs
│ ├── dev
│ │ ├── backend.tf
│ │ └── main.tf
│ ├── staging
│ │ ├── backend.tf
│ │ └── main.tf
│ └── global
│ └── backend
│ └── main.tf
└── modules
├── aurora
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── cloudwatch
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── ecs
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── route53
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── sns
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
└── vpc
├── main.tf
├── outputs.tf
└── variables.tf
```
---

# 🌐 1. Sample Webpage (`app/index.html`)

```html
<!DOCTYPE html>
<html>
<head>
  <title>Welcome to My Website</title>
  <style>
    body {
      font-family: Arial;
      text-align: center;
      margin-top: 10%;
      background-color: #f4f4f4;
    }
    h1 {
      color: #0078d7;
    }
  </style>
</head>
<body>
  <h1>🚀 Deployed via Jenkins on AWS ECS Fargate</h1>
  <p>This is a sample web page deployed automatically using CI/CD.</p>
</body>
</html>
```
---
# 🐳 2. Dockerfile (`app/Dockerfile`)

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```
---
# 🧱 4. Jenkinsfile (CI/CD Pipeline)

Here’s the main automation logic 👇

```groovy
pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'staging'], description: 'Select environment to deploy')
    }

    environment {
        AWS_REGION = 'us-east-1'
        AWS_CREDENTIALS = credentials('aws-jenkins-creds')
        ECR_REPO = '141559732042.dkr.ecr.us-east-1.amazonaws.com/mywebsite'
        IMAGE_TAG = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'git', url: 'https://github.com/yourname/ecs-aurora-website.git'
            }
        }

        stage('Terraform Init & Validate') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                        sh '''
                        terraform init -input=false
                        terraform validate
                        terraform workspace select ${ENV} || terraform workspace new ${ENV}
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan & Apply Infra') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                        sh '''
                        terraform plan -input=false -out=tfplan -var="env=${ENV}"
                        terraform apply -input=false -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    cd app
                    docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REPO}
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                    sh '''
                    aws ecs update-service \
                        --cluster ${ENV}-ecs-cluster \
                        --service ${ENV}-web-service \
                        --force-new-deployment \
                        --region ${AWS_REGION}
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo "✅ Deployment completed for ${ENV} environment!"
                    echo "Website: https://${ENV}.example.com"
                }
            }
        }
    }

    post {
        success {
            echo "🎉 ${ENV} deployment successful!"
        }
        failure {
            echo "❌ Deployment failed. Check logs in Jenkins & CloudWatch."
        }
    }
}

```
---
# 🧰 5. Jenkins Setup Steps

On your Jenkins server (EC2 or local):
```
---
## 🔌 Install Plugins
- Amazon ECR  
- AWS CLI  
- Docker Pipeline  
- Git  
- Terraform Plugin  
---
## 🔐 Configure AWS Credentials
1. Go to **Jenkins → Manage Jenkins → Credentials**  
2. Add credentials of type **AWS Credentials**  
3. Name it: `aws-jenkins-creds`
```
---
## 🧑‍💻 Agent Requirements
Jenkins agent/server must have:
- Docker  
- AWS CLI  
- Terraform installed
``` 
---
## 🏗️ Create a Pipeline Job
1. Name: `ecs-website-deploy`  
2. Select: **“Pipeline script from SCM”**  
3. SCM: **Git** → paste your GitHub repository URL
```  
---
## ▶️ Run the Pipeline
Jenkins will automatically:
- Build and push Docker image  
- Apply Terraform infrastructure  
- Deploy the application on ECS
  ```
---
# 🧩 1. Jenkins Server Setup (if not done)

On your Jenkins EC2 instance (**Ubuntu preferred**):

```bash
sudo apt update -y
sudo apt install -y docker.io unzip awscli
🏗️ Install Terraform
bash
Copy code
wget https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip
unzip terraform_1.9.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -version
🐳 Add Jenkins to Docker Group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
✅ Also ensure Docker and AWS CLI are installed and configured on your Jenkins server.
```
---
# ✅ Verify the Deployment

Once the pipeline finishes:

1. Go to **AWS ECS Console → Clusters → jenkins-ecs-cluster**  
2. Check the service → ensure the task is **running**  
3. Open the **Public IP** or **ALB DNS name** in your browser  

You’ll see:

> 🚀 Deployed via Jenkins on AWS ECS Fargate

---
## 👨‍💻 **Author**

**Ramagiri Jithendar** — DevOps Engineer
📧 **[ramagirijithendar1998@gmail.com](mailto:ramagirijithendar1998@gmail.com)**
💼 **[LinkedIn Profile](#)**
