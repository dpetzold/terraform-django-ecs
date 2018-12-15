====================
terraform-django-ecs
====================

Deploy a dockerized Django Application to AWS in a VPC using Terraform, EC2 Container
Registry and EC2 Container Service.

Includes:

* Virtual Private Cloud
* Internal DNS
* Private S3 bucket for container registry data
* Private ECR Docker repository
* ECS cluster, launch configuration and autoscaling group
* RDS cluster
* ElastiCache cluster
* uWSGI task definition
* Celery task definition
* Celery beat task definition

This project is split into three separate Terraform projects. So they can be
built and destroyed independent of each other.

ECR
  Builds the private ECR Docker repository. Outputs the registry endpoint.

VPC
  Builds the VPC, the RDS cluster, ElastiCache cluster and their security
  groups. The DNS names for the clusters are:

  * rds.internal
  * redis.interal

  Outputs the VPC id and the public and private subnets ids.

ECS
  Builds the ECS cluster with 2 micro instances and uWSGI and Celery task definitions
  and the necessary security groups and IAM roles. Outputs the ELB endpoint.

Prerequisites
-------------

This guide requires that you have terraform and the aws cli configured and
working. See:


* Terraform installed. Get it from
  `https://www.terraform.io/intro/getting-started/install.html <https://www.terraform.io/intro/getting-started/install.html>`_ to grab the latest version.
* An AWS account `http://aws.amazon.com/ <http://aws.amazon.com/>`_
* The AWS cli configured `https://docs.aws.amazon.com/cli/latest/userguide/installing.html <https://docs.aws.amazon.com/cli/latest/userguide/installing.html>`_


    aws configure
    export PROJECT_NAME="<project_name>"
    export PROJECT_VERSION=`git rev-parse --short HEAD`

To verify:

    aws sts get-caller-identity
    echo ${PROJECT_NAME}
    echo ${PROJECT_VERSION}


Usage
-----

Building the cluster is broken up into two parts:

1) Provision the VPC with; ECS respoitory, RDS and ElastiCache clusters, EC2 instances.
2) Provision the ECS cluster with the service and task definitions.


The following steps will walk you through the process:

1. Clone the repo::

    git clone https://github.com/dpetzold/terraform-django-ecs.git

2. Create the AWS key pair::

    aws ec2 create-key-pair --key-name ${PROJECT_NAME} \
        --output text --query KeyMaterial > ${PROJECT_NAME}
    chmod 400 ${PROJECT_NAME}
    mv ${PROJECT_NAME} ~/.ssh

6. Start your terrform project::

    mkdir -p <yourproject>/terraform
    cp -R examples/vpc <yourproject>/terraform
    cp -R examples/ecs <yourproject>/terraform

8. Build the VPC and its associated resources::

    cd <yourproject>/terraform/vpc
    terraform plan
    terraform apply

4. Upload your docker image to to the ECR repository::

    cd <project>
    `aws ecr get-login --region us-east-1`
    export PROJECT_IMAGE="${REPO}/${PROJECT_NAME}:${PROJECT_VERSION}"
    docker build -t ${PROJECT_IMAGE}
    docker push ${PROJECT_IMAGE}

8. Build the ECS cluster::

    cd <yourproject>/terraform/ecs
    terraform plan
    terraform apply

9. Initialize your database. scp your database dump to the bastion
   and load it::

    scp -i <your keypair> database.dump ec2-user@bastion.<domain_name>
    ssh -i <your keypair> ec2-user@bastion.<domain_name>
    sudo yum install -y postgresql94
    pg_restore -U <database user> -h rds.internal -d postgres -C database.dump

9. Check the status of the cluster from the AWS console. Once the status of the
   task definition changes from PENDING to ACTIVE the instances will be added
   to the ELB and your site should accessible from the ELB endpoint returned
   from the build ecs command.


Deploy
------

To deploy new code perform the following steps::

    `aws ecr get-login --region us-east-1`
    docker build -t $TF_VAR_project_name .
    docker push $TF_VAR_docker_image

* Create a new task revision.

* Update the service.
