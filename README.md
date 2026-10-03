# 🚀 Terraform AWS Modular Infrastructure

> A modular AWS infrastructure project built using **Terraform** and **Infrastructure as Code (IaC)** principles.

This project provisions and manages AWS networking, security, compute, load balancing, storage, and database resources using reusable and independent Terraform modules.

---

## 📌 Project Overview

The main objective of this project is to provision a complete AWS infrastructure using **Terraform Modules** instead of manually creating resources through the AWS Management Console.

The infrastructure is divided into multiple reusable modules, making the environment:

- 🔹 Modular
- 🔹 Reusable
- 🔹 Scalable
- 🔹 Maintainable
- 🔹 Easy to manage

---

## 🏗️ AWS Services Used

| Category | AWS Services |
|---|---|
| Networking | VPC, Subnets, Route Tables, Internet Gateway, NAT Gateway |
| Network Connectivity | VPC Peering, Transit Gateway |
| Compute | EC2, Launch Template, Auto Scaling Group |
| Load Balancing | Application Load Balancer, Target Group |
| Database | Amazon RDS |
| Storage | Amazon S3, Amazon EFS |
| Security | IAM, Security Groups, AWS KMS |
| Infrastructure | Terraform |

---

🔧 Infrastructure Components

1️⃣ Networking
The networking layer creates the core AWS network infrastructure.
VPC
Creates the main Virtual Private Cloud for hosting AWS resources.
Public Subnets
Used for internet-facing resources such as:
Application Load Balancer
NAT Gateway
Private Subnets
Used for internal resources such as:
EC2 instances
RDS
EFS
Internet Gateway
Provides internet connectivity for resources inside public subnets.
NAT Gateway
Allows resources inside private subnets to access the internet for outbound communication without exposing them directly to the internet.
Route Tables
Controls traffic routing between public and private subnets.

2️⃣ VPC Peering
The VPC Peering module creates private connectivity between VPCs.
It allows resources in different VPCs to communicate using private IP addresses.

3️⃣ Transit Gateway
The Transit Gateway module provides centralized connectivity between multiple VPCs.
It can act as a central networking hub for connecting multiple VPC environments.

4️⃣ 🔐 Security
Security-related infrastructure is managed using Terraform modules.
IAM
Creates IAM roles and policies required by AWS resources.
AWS KMS
Provides encryption keys for protecting AWS resources such as:
EBS volumes
RDS storage
Other encrypted resources
Security Groups
Controls inbound and outbound network traffic for AWS resources.

5️⃣ 💻 Compute
Amazon EC2
Provides compute capacity for application workloads.
Launch Template
Defines the configuration used when launching EC2 instances.
It includes:
AMI
Instance Type
Security Group
IAM Instance Profile
EBS Configuration
User Data
Auto Scaling Group
Manages application instances dynamically.
It provides:
Minimum instance count
Desired instance count
Maximum instance count
Automatic instance replacement
Load Balancer integration

6️⃣ ⚖️ Application Load Balancer
The Application Load Balancer distributes incoming HTTP traffic across application instances.
Client
  |
  v
ALB
  |
  +--------> EC2 Instance 1
  |
  +--------> EC2 Instance 2
The ALB forwards traffic to the Target Group.

7️⃣ 🎯 Target Group
The Target Group registers application instances behind the Application Load Balancer.
Health checks are used to verify whether the application instances are responding correctly.
ALB
 |
 v
Target Group
 |
 +---- EC2-1
 |
 +---- EC2-2
 
8️⃣ 🗄️ Amazon RDS
Amazon RDS provides managed relational database infrastructure.
The database is deployed inside private subnets and protected using security groups.
The configuration includes:
Private subnet deployment
Database security group
Storage encryption
AWS KMS integration
DB subnet group

9️⃣ 🪣 Amazon S3
Amazon S3 provides object storage.
The S3 bucket is created and managed using Terraform.

🔟 📁 Amazon EFS
Amazon EFS provides shared file storage that can be accessed by multiple EC2 instances.
This is useful for applications that require shared storage across multiple servers.

🔄 Terraform Workflow
Step 1 — Initialize Terraform
terraform init

🎯 Purpose
Downloads the required Terraform providers and initializes the Terraform working directory.

✅ Outcome
Terraform initializes successfully and prepares the environment for deployment.

## 🏛️ Architecture

```text
                         🌐 Internet
                              |
                              v
                  Application Load Balancer
                              |
                    -------------------
                    |                 |
                    v                 v
                  EC2-1             EC2-2
                    |                 |
                    ---------+---------
                             |
                    Auto Scaling Group
                             |
                       Private Subnets
                             |
                       NAT Gateway
                             |
                    Internet Gateway
                             |
                            VPC


#Additional AWS Services
                         Terraform
                             |
        ------------------------------------------------
        |              |              |                |
     Networking      Security       Compute         Storage
        |              |              |                |
       VPC          IAM / KMS       EC2 / ASG       S3 / EFS
       NAT          Security        Launch          RDS
       Routes       Groups          Template
        |
   VPC Peering
        |
  Transit Gateway

