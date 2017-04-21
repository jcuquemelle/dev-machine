#!/usr/bin/env bash

echo "Provisionning Base"

apt-get update  -y         			  > /dev/null

#for ansible
apt-get install -y libffi6 libffi-dev
apt-get install -y libssl-dev python-pip

# Install Ansible dependencies on first run:
if [ ! -f /etc/ansible/hosts ]; then
    pip install ansible
	if [ $? == 0 ]; then
        # Create a simple inventory file for localhost:
        mkdir -p /etc/ansible
        echo "[local]" > /etc/ansible/hosts
        echo "localhost	ansible_connection=local" >> /etc/ansible/hosts
    fi
fi