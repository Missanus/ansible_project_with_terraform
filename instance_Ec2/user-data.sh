#!/usr/bin/env bash 
set -xe


################################################
# Software installation (yum)
################################################ https://docs.aws.amazon.com/fr_fr/corretto/latest/corretto-8-ug/amazon-linux-install.html

echo "Mediametrie : yum update"
yum update  -y                                  # we think it's already done by default settings
yum upgrade -y                                  # we think it's already done by default settings
yum install tree -y
yum install jq -y
yum install -y awslogs
yum -y install unzip
yum install -y htop
sudo yum -y groupinstall "Development Tools" 
sudo yum -y install openssl-devel bzip2-devel libffi-devel
sudo yum -y install wget

#install Java 8 on Amazon Linux
#sudo yum install java-1.8.0-openjdk -y
#java -version



###############################################
# Variables
#
INSTANCE_ID=$(curl http://169.254.169.254/1.0/meta-data/instance-id/ 2>/dev/null ) # PIPA
TRAITEV_ID=$( aws ec2 describe-tags --region "eu-west-1" --filters "Name=resource-id,Values=${INSTANCE_ID}" | jq -c '.Tags[] | select (.Key == "traitev-id") | .Value' | sed s/\"//g )
echo "traitev-id ${TRAITEV_ID}"


#enable passwd authentification
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart


####################################################
# sourcing
#. ~/.bashrc
#source ~/.bashrc


###############################################
# AWSLOGD
###############################################
# backup
mv /etc/awslogs/awslogs.conf /etc/awslogs/awslogs.conf.backup

# AWS Cloudwatch : configure awslogd  https://docs.amazonaws.cn/en_us/AmazonCloudWatch/latest/logs/AgentReference.html
LOG_GROUP_NAME=ansible_terraform_cloud_init
echo "
[general]
# Path to the CloudWatch Logs agent's state file. The agent uses this file to maintain
# client side state across its executions.
state_file=/var/lib/awslogs/agent-state
use_gzip_http_content_encoding=true

[/var/log/cloud-init-output.log]
file=/var/log/cloud-init-output.log
encoding=utf_8
datetime_format=%Y-%m-%d %H:%M:%S
time_zone=UTC
multi_line_start_pattern={datetime_format}
buffer_duration=5000
log_group_name=${LOG_GROUP_NAME}
log_stream_name=cloud-init-output-${TRAITEV_ID}
initial_position=start_of_file
" > /etc/awslogs/awslogs.conf

#Set instance region
sed -i 's/^region = .*$/region = eu-west-1/g' /etc/awslogs/awscli.conf





##############################################
# (re)start services
service chronyd restart
systemctl enable awslogsd
systemctl start awslogsd


