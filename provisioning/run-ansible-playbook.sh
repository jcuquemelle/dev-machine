#!/usr/bin/env bash

# We want Ansible's output line by line:
export PYTHONUNBUFFERED=1
PLAYBOOK="main.yml"

# We expect the host user name to be specified as the 1st argument
HOST_USER="${1}"

echo "Run the playbook: ${PLAYBOOK} with user ${HOST_USER}"
ansible-playbook /vagrant/provisioning/ansible/${PLAYBOOK} --extra-vars "host_user=${HOST_USER}"

