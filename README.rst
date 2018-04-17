====================
terraform-django-ecs
====================

```
If you are just beginning with your container strategy I recommend (April 2018) using EKS over ECS.
```

Deploy a dockerized Django Application to AWS in a VPC using terraform, EC2 Container
Registry and EC2 Container Service.

Includes:

* Virtual Private Cloud
* Internal DNS
* Private S3 bucket for container registry data
* Private ECR Docker repository
* ECS cluster, launch configuration and autoscaling group
* RDS cluster
* ElastiCache cluster
* EC2 instances to run ECS agent on
* ELB to distribute request across the EC2 instances
* uWSGI task definition
* Celery task definition
* Celery beat task definition

This project is split into three separate terraform projects. So they can be
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
  Builds the ECS cluster with 2 micro instances and uWSGI and Celery task
  definitions and the necessary security groups and IAM roles. Outputs the
  ELB endpoint.


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
    TF_VAR_aws_access_key=The AWS access key ID
    TF_VAR_aws_secret_key=The AWS secret key
    TF_VAR_project_name=The name of your project

3. Build the ECR registry::

    ./apply ecr

    It will output the docker repository url used below.

4. Upload your docker image to it::

    cd project
    `aws ecr get-login --region us-east-1`
    docker build -t project .
    docker tag repo/project:version
    docker push repo/project:version

5. Update the env file with the ARN to the docker image::

    TF_VAR_docker_image="repo/project:version"

6. Build the VPC::

   ./apply vpc

7. Update the env file with the output::

    TF_VAR_vpc_id="vpc-????????"
    TF_VAR_public_subnet_id="subnet-????????"
    TF_VAR_private_subnet_id="subnet-????????"

8. Build the ECS cluster::

   ./apply ecs

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
