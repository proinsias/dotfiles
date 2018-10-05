#!/bin/bash

ansible-galaxy install --role-file requirements.yml

# FIXME: Try `--check` (with `--diff`?) to just report differences.
# https://github.com/ansible/ansible-modules-core/issues/960

ansible-playbook site.yml --forks 10 --ask-become-pass --check
