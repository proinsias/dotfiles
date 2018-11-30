#!/bin/bash

#
# Initial setup
#
# brew install ansible
# sudo mkdir /etc/ansible
# cat 'localhost ansible_connection=local ansible_python_interpreter="/usr/bin/env python"' >> /etc/ansible/hosts
# touch ~/.ansible.cfg
# ansible-config view

ansible-galaxy install --force --role-file requirements.yml

# FIXME: Try `--check` (with `--diff`?) to just report differences.
# https://github.com/ansible/ansible-modules-core/issues/960

ansible-playbook site.yml --forks 10 --ask-become-pass --check

# FIXME: Executing one role - https://stackoverflow.com/a/38384205
