#!/bin/bash
sudo su
yum install git -y
yum install ansible -y
yum install python3.11-devel python3.11-pip -y
pip3.11 install ansible botocore boto3

# component=$1
# environment=$2


# ansible-pull -U https://github.com/idurgabhavani/roboshop-ansible-roles-tf.git -e component=$component -e env=$environment main-tf.yaml

# # botocore and boto3 are the AWS packages