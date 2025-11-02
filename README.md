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

# Project-22: ECS with Aurora Deployment

## 🧩 **Project Structure**

```plaintext
project-22/
├── modules/
│   ├── vpc/
│   ├── ecs/
│   ├── aurora/
│   ├── route53/
│   ├── cloudwatch/
│   └── sns/
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── staging/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
├── scripts/
│   ├── build_and_push_ecr.sh
│   └── ecs_deploy.sh
│
└── README.md
```

---

## ⚙️ **Prerequisites**

* **AWS Account** with IAM permissions
* **Terraform ≥ v1.5**
* **AWS CLI** configured (`aws configure`)
* **Docker** installed locally
* **Domain registered in Route53 (optional)** for DNS setup

---

## 🪜 **Setup Steps**

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

## 👨‍💻 **Author**

**Ramagiri Jithendar** — DevOps Engineer
📧 **[ramagirijithendar1998@gmail.com](mailto:ramagirijithendar1998@gmail.com)**
💼 **[LinkedIn Profile](#)**
