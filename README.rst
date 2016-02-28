====================
terraform-django-ecs
====================

Deploy a dockerized Django Application to AWS in a VPC using terraform, EC2 Container
Registry and EC2 Container Service.

Includes:

* Virutal Private Cloud
* Internal DNS
* Private S3 bucket for container registry data
* Private ECR Docker respository
* ECS cluster, launch configuration and autoscaling group
* RDS cluser
* ElastiCache cluster
* EC2 instances to run ECS agenct on
* ELB to distribute request accross the EC2 instances
* uWSGI task definition
* Celery task definition
* Celery beat task definition

This project is split into three seperate terraform projects. So they can be
built and destoryed independant of each other.

ecr
  Builds the private ECR Docker respository. Outputs the registry endpoint.

vpc
  Builds the VPC, the RDS cluster, ElastiCache cluster and their security
  groups. The DNS names for the clusters are:
      
      rds.internal
      redis.interal

  Outputs the VPC id and the public and private subnets ids.

ecs
  Builds the ECS cluster with 2 micro instances and uWSGI and Celery task
  definitions and the nesscary security groups and IAM roles. Outputs the
  elb endpoint.


Prerequisites
-------------

* Terraform installed. Get it from [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html) to grab the latest version.
* An AWS account [http://aws.amazon.com/](http://aws.amazon.com/)

Usage
-----

1. Clone the repo::

    git clone https://github.com/dpetzold/terraform-django-ecs.git

2. Copy the sample env to .env and edit it with your information:: 

    TF_VAR_key_name=name of ssh key
    TF_VAR_key_file=the ssh key file to use
    TF_VAR_aws_access_key=The AWS access key ID
    TF_VAR_aws_secret_key=The AWS secret key
    TF_VAR_project_name=The name of your project

3. Build the ECR registry::

    ./build ecr

4. Upload your docker image to it::

    cd project
    `aws ecr get-login --region us-east-1`
    docker build -t derrickpetzold .
    docker tag derrickpetzold:latest 184217501385.dkr.ecr.us-east-1.amazonaws.com/derrickpetzold:latest
    docker push 184217501385.dkr.ecr.us-east-1.amazonaws.com/derrickpetzold:latest

5. Update the env file with the ARN to the docker image::

    TF_VAR_docker_image="184217501385.dkr.ecr.us-east-1.amazonaws.com/derrickpetzold:latest"

6. Build the VPC::

   ./build vpc

7. Update the env file with the output::

    TF_VAR_vpc_id="vpc-d077bdb4"
    TF_VAR_public_subnet_id="subnet-a4cd10c0"
    TF_VAR_private_subnet_id="subnet-1be3e042"

8. Build the ECS cluster::

   ./build ecs

9. Initialize your database. Get the hostname of one of the running EC2
   instances and make sure ssh from your host is allowed in the security
   group. Then scp your database dump and load it:: 

    scp -i <your keypair> database.dump ec2-user@<hostname>
    ssh -i <your keypair> ec2-user@<hostname>
    sudo -s
    yum install -y postgresql94
    pg_restore -U <database user> -h rds.internal -d postgres -C database.dump

9. Check the status of the cluster from the AWS console. Once the status of the
   task definition changes from PENDING to ACTIVE the instances will be added
   to the ELB and your site should accessiable from the ELB endpoint returned
   from the build ecs command.


Deploy
------

To deploy new code perform the following steps::

    `aws ecr get-login --region us-east-1`
    docker build -t $TF_VAR_project_name .
    docker push $TF_VAR_docker_image

* Create a new task revision.

* Update the service.
