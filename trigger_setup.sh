#!/usr/bin/env bash

MUMBAI=13.232.211.39
LONDON=18.134.151.143
PARIS=52.47.163.42

echo "Setting up mumbai"
scp -i ./wos-mumbai.pem ./setup.sh ./sshd_config ec2-user@$MUMBAI:~/
ssh -i ./wos-mumbai.pem ec2-user@$MUMBAI "echo Mumbai | sudo bash ~/setup.sh"

echo "Setting up london"
scp -i ./wos_london.pem ./setup.sh ./sshd_config ec2-user@$LONDON:~/
ssh -i ./wos_london.pem ec2-user@$LONDON "echo London | sudo bash ~/setup.sh"

echo "Setting up paris"
scp -i ./wos_paris.pem ./setup.sh ./sshd_config ec2-user@$PARIS:~/
ssh -i ./wos_paris.pem ec2-user@$PARIS "echo Paris | sudo bash ~/setup.sh"
