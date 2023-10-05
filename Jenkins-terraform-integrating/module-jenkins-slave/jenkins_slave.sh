#! /bin/bash
yum update -y
yum install java-11* -y
yum install git-y
yum install docker -y && service docker start && chkconfig docker on